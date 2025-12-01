from flask import Flask, render_template_string, request, jsonify
import csv
import os
import requests
import re
import webbrowser
from threading import Timer

app = Flask(__name__)

INPUT_CSV = "product_images.csv"
OUTPUT_CSV = "product_images_verified.csv"
BLACKLIST_DOMAINS = [
    'pngall.com', 'pngtree.com', 'freepik.com', 'pixabay.com', 'unsplash.com',
    'shopee', 'tokopedia', 'bukalapak', 'lazada', 'blibli'
]

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}

# --- Search Logic (Simplified from generate_image_links.py) ---
def refine_query_smartly(product_name):
    name_lower = product_name.lower()
    negatives = ["-wallpaper", "-background", "-scenery", "-landscape", "-bundle", "-promo"]
    if "indomie" in name_lower or "mie" in name_lower:
        if "kuah" in name_lower or "rebus" in name_lower:
            negatives.extend(["-goreng", "-fried", "-dry"])
        elif "goreng" in name_lower:
            negatives.extend(["-kuah", "-soup", "-rebus", "-soto", "-kari", "-ayam bawang"])
    query = f'"{product_name}" kemasan produk indonesia ' + " ".join(negatives)
    return query

def search_images(query):
    candidates = []
    
    # Google
    try:
        refined_query = refine_query_smartly(query)
        url = f"https://www.google.com/search?q={refined_query}&tbm=isch&ijn=0"
        response = requests.get(url, headers=HEADERS, timeout=5)
        matches = re.findall(r'(https?://[^"]+\.(?:jpg|jpeg|png|webp))', response.text)
        for m in matches:
            if 'gstatic' not in m and 'google' not in m and not any(b in m for b in BLACKLIST_DOMAINS):
                candidates.append(m)
    except Exception as e:
        print(f"Google Error: {e}")

    # Bing
    try:
        refined_query = refine_query_smartly(query).replace("kemasan produk indonesia", "product packaging indonesia")
        url = f"https://www.bing.com/images/search?q={refined_query}"
        response = requests.get(url, headers=HEADERS, timeout=5)
        matches = re.findall(r'murl&quot;:&quot;(https?://.*?)&quot;', response.text)
        for m in matches:
            if not any(b in m for b in BLACKLIST_DOMAINS):
                candidates.append(m)
    except Exception as e:
        print(f"Bing Error: {e}")
        
    return list(set(candidates))[:20] # Return top 20 unique

# --- Data Management ---
def load_data():
    products = []
    if os.path.exists(INPUT_CSV):
        with open(INPUT_CSV, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            products = list(reader)
    
    verified_ids = set()
    if os.path.exists(OUTPUT_CSV):
        with open(OUTPUT_CSV, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            for row in reader:
                verified_ids.add(row['barcode_id'])
                
    # Filter out verified
    pending = [p for p in products if p['barcode_id'] not in verified_ids]
    return pending

def save_selection(barcode, name, url, status):
    file_exists = os.path.exists(OUTPUT_CSV)
    with open(OUTPUT_CSV, 'a', newline='', encoding='utf-8') as f:
        fieldnames = ['barcode_id', 'nama_produk', 'image_url', 'status']
        writer = csv.DictWriter(f, fieldnames=fieldnames)
        if not file_exists:
            writer.writeheader()
        writer.writerow({
            'barcode_id': barcode,
            'nama_produk': name,
            'image_url': url,
            'status': status
        })

# --- Routes ---
@app.route('/')
def index():
    return render_template_string("""
    <!DOCTYPE html>
    <html>
    <head>
        <title>NutriScan Image Picker</title>
        <style>
            body { font-family: 'Segoe UI', sans-serif; background: #f0f2f5; padding: 20px; }
            .container { max-width: 1200px; margin: 0 auto; }
            .header { background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); margin-bottom: 20px; text-align: center; }
            .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 15px; }
            .card { background: white; border-radius: 8px; overflow: hidden; cursor: pointer; transition: transform 0.2s; box-shadow: 0 2px 5px rgba(0,0,0,0.1); position: relative; }
            .card:hover { transform: scale(1.05); border: 3px solid #1a73e8; }
            .card img { width: 100%; height: 200px; object-fit: contain; background: #fff; }
            .card .res { position: absolute; bottom: 0; right: 0; background: rgba(0,0,0,0.6); color: white; font-size: 10px; padding: 2px 5px; }
            .loading { text-align: center; font-size: 20px; color: #666; margin-top: 50px; }
            .actions { margin-top: 20px; text-align: center; }
            input[type="text"] { padding: 10px; width: 300px; border: 1px solid #ddd; border-radius: 5px; }
            button { padding: 10px 20px; background: #1a73e8; color: white; border: none; border-radius: 5px; cursor: pointer; }
            button.skip { background: #666; }
        </style>
    </head>
    <body>
        <div class="container" id="app">
            <div class="header">
                <h1 id="product-name">Loading...</h1>
                <p id="progress">Products remaining: ...</p>
            </div>
            
            <div id="gallery" class="grid"></div>
            <div id="loader" class="loading">Searching images...</div>
            
            <div class="actions">
                <input type="text" id="custom-url" placeholder="Paste custom URL here...">
                <button onclick="submitCustom()">Use Custom URL</button>
                <button class="skip" onclick="skipProduct()">Skip (No Image)</button>
            </div>
        </div>

        <script>
            let currentProduct = null;

            function loadNext() {
                document.getElementById('gallery').innerHTML = '';
                document.getElementById('loader').style.display = 'block';
                document.getElementById('product-name').innerText = 'Loading next product...';
                
                fetch('/api/next')
                    .then(r => r.json())
                    .then(data => {
                        if (data.done) {
                            document.body.innerHTML = "<h1>All products verified! 🎉</h1>";
                            return;
                        }
                        currentProduct = data;
                        document.getElementById('product-name').innerText = data.nama_produk;
                        document.getElementById('progress').innerText = `Remaining: ${data.remaining}`;
                        
                        // Render images
                        const gallery = document.getElementById('gallery');
                        document.getElementById('loader').style.display = 'none';
                        
                        data.images.forEach(url => {
                            const div = document.createElement('div');
                            div.className = 'card';
                            div.onclick = () => selectImage(url);
                            div.innerHTML = `<img src="${url}" onerror="this.parentElement.style.display='none'">`;
                            gallery.appendChild(div);
                        });
                        
                        if (data.images.length === 0) {
                            gallery.innerHTML = "<p style='grid-column: 1/-1; text-align: center;'>No images found automatically. Please use custom URL.</p>";
                        }
                    });
            }

            function selectImage(url) {
                save(url, 'BERHASIL');
            }

            function submitCustom() {
                const url = document.getElementById('custom-url').value.trim();
                if (url) save(url, 'BERHASIL');
            }

            function skipProduct() {
                save('NOT_FOUND', 'GAGAL');
            }

            function save(url, status) {
                fetch('/api/save', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify({
                        barcode_id: currentProduct.barcode_id,
                        nama_produk: currentProduct.nama_produk,
                        image_url: url,
                        status: status
                    })
                }).then(() => {
                    document.getElementById('custom-url').value = '';
                    loadNext();
                });
            }

            // Start
            loadNext();
        </script>
    </body>
    </html>
    """)

@app.route('/api/next')
def get_next():
    pending = load_data()
    if not pending:
        return jsonify({'done': True})
    
    product = pending[0]
    # Search live
    images = search_images(product['nama_produk'])
    
    return jsonify({
        'done': False,
        'barcode_id': product['barcode_id'],
        'nama_produk': product['nama_produk'],
        'remaining': len(pending),
        'images': images
    })

@app.route('/api/save', methods=['POST'])
def save_data():
    data = request.json
    save_selection(data['barcode_id'], data['nama_produk'], data['image_url'], data['status'])
    return jsonify({'success': True})

def open_browser():
    webbrowser.open("http://127.0.0.1:5000")

if __name__ == '__main__':
    Timer(1, open_browser).start()
    app.run(port=5000)
