import csv
import os

CSV_FILE = "product_images.csv"
HTML_FILE = "verify_images.html"

def create_html():
    if not os.path.exists(CSV_FILE):
        print(f"File {CSV_FILE} tidak ditemukan!")
        return

    html_content = """
    <!DOCTYPE html>
    <html>
    <head>
        <title>Verifikasi Gambar Produk</title>
        <style>
            body { font-family: sans-serif; padding: 20px; background: #f0f2f5; }
            .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; }
            .card { background: white; padding: 15px; border-radius: 10px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
            .card img { width: 100%; height: 200px; object-fit: contain; background: #eee; border-radius: 5px; }
            .card h3 { font-size: 14px; margin: 10px 0 5px; height: 40px; overflow: hidden; }
            .card p { font-size: 12px; color: #666; margin: 0; }
            .card a { font-size: 12px; color: blue; text-decoration: none; display: block; margin-top: 5px; }
            .error { color: red; font-weight: bold; }
        </style>
    </head>
    <body>
        <h1>Verifikasi Gambar Produk</h1>
        <p>Buka file ini di browser untuk melihat hasil generate link.</p>
        <div class="grid">
    """

    with open(CSV_FILE, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        count = 0
        for row in reader:
            count += 1
            barcode = row['barcode_id']
            nama = row['nama_produk']
            url = row['image_url']
            
            img_tag = f'<img src="{url}" loading="lazy" onerror="this.src=\'https://via.placeholder.com/200?text=Error\'">'
            if url == 'NOT_FOUND':
                img_tag = '<div style="height:200px; background:#eee; display:flex; align-items:center; justify-content:center; color:red;">NOT FOUND</div>'
            
            html_content += f"""
            <div class="card">
                {img_tag}
                <h3>{nama}</h3>
                <p>Barcode: {barcode}</p>
                <a href="{url}" target="_blank">Lihat Link Asli</a>
            </div>
            """

    html_content += """
        </div>
    </body>
    </html>
    """

    with open(HTML_FILE, 'w', encoding='utf-8') as f:
        f.write(html_content)
    
    print(f"Berhasil membuat {HTML_FILE} dengan {count} produk.")
    print("Silakan buka file tersebut di browser Anda.")

if __name__ == "__main__":
    create_html()
