import mysql.connector
import csv
import requests
import re
import time
import random
import datetime
import os
from io import BytesIO
from PIL import Image
import imagehash

# Konfigurasi Database
DB_CONFIG = {
    'host': 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com',
    'user': '4HDiYTpxo4XPCdX.root',
    'password': 'LWPPf02KXP13x70h',
    'database': 'nutriscan_db',
    'port': 4000,
    'ssl_disabled': False
}

OUTPUT_CSV = "product_images.csv"
HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}

# Domain yang sering memberikan gambar generik/sampah
BLACKLIST_DOMAINS = [
    'pngall.com', 'pngtree.com', 'freepik.com', 'pixabay.com', 'unsplash.com',
    'e7.pngegg.com', 'w7.pngwing.com', 'banner2.cleanpng.com', 'img.lovepik.com',
    'icon-library.com', 'clipart-library.com', 
    'shopee', 'tokopedia', 'bukalapak', 'lazada', 'blibli',
    'susercontent.com', 'tokopedia.net', 'lazcdn.com', 'static-src.com'
]

# Global state untuk tracking duplikasi
seen_urls = set()
seen_hashes = []

def log(msg):
    print(f"[{datetime.datetime.now().strftime('%H:%M:%S')}] {msg}")

def is_blacklisted(url):
    for domain in BLACKLIST_DOMAINS:
        if domain in url:
            return True
    return False

def get_image_hash(image_content):
    try:
        img = Image.open(BytesIO(image_content))
        return imagehash.phash(img)
    except Exception as e:
        return None

def is_visually_unique(new_hash, threshold=5):
    if new_hash is None:
        return False
    for existing_hash in seen_hashes:
        if new_hash - existing_hash < threshold:
            return False
    return True

def download_image_content(url):
    try:
        response = requests.get(url, headers=HEADERS, timeout=5, stream=True)
        if response.status_code == 200:
            content_type = response.headers.get('Content-Type', '')
            if not content_type.startswith('image/'):
                return None
            content = b""
            for chunk in response.iter_content(1024):
                content += chunk
                if len(content) > 5 * 1024 * 1024:
                    return None
            return content
    except:
        pass
    return None

def get_image_quality_score(img):
    width, height = img.size
    if width < 300 or height < 300:
        return 0
    ratio = width / height
    if ratio > 1.8 or ratio < 0.5:
        return 0
    area = min(width * height, 1000 * 1000)
    return area

def refine_query_smartly(product_name):
    name_lower = product_name.lower()
    negatives = ["-wallpaper", "-background", "-scenery", "-landscape", "-bundle", "-promo"]
    
    if "indomie" in name_lower or "mie" in name_lower:
        if "kuah" in name_lower or "rebus" in name_lower:
            negatives.extend(["-goreng", "-fried", "-dry"])
        elif "goreng" in name_lower:
            negatives.extend(["-kuah", "-soup", "-rebus", "-soto", "-kari", "-ayam bawang"])
            
        flavors = {
            "soto": ["-kari", "-rendang", "-ayam bawang", "-kaldu", "-special"],
            "kari": ["-soto", "-rendang", "-ayam bawang", "-kaldu"],
            "rendang": ["-soto", "-kari", "-ayam bawang", "-kaldu"],
            "ayam bawang": ["-soto", "-kari", "-rendang", "-kaldu"],
            "kaldu ayam": ["-soto", "-kari", "-rendang", "-ayam bawang"]
        }
        
        for flavor, exclusions in flavors.items():
            if flavor in name_lower:
                negatives.extend(exclusions)
                
    query = f'"{product_name}" kemasan produk indonesia ' + " ".join(negatives)
    return query

def search_google(query):
    refined_query = refine_query_smartly(query)
    log(f"    [TRY] Engine: Google ({refined_query})")
    try:
        url = f"https://www.google.com/search?q={refined_query}&tbm=isch"
        response = requests.get(url, headers=HEADERS, timeout=5)
        matches = re.findall(r'(https?://[^"]+\.(?:jpg|jpeg|png|webp))', response.text)
        valid_urls = []
        for url in matches:
            if 'gstatic' not in url and 'google' not in url:
                valid_urls.append(url)
        return valid_urls[:5] 
    except Exception as e:
        log(f"    [ERR-GOOG] {e}")
    return []

def search_bing(query):
    refined_query = refine_query_smartly(query).replace("kemasan produk indonesia", "product packaging indonesia")
    log(f"    [TRY] Engine: Bing ({refined_query})")
    try:
        url = f"https://www.bing.com/images/search?q={refined_query}"
        response = requests.get(url, headers=HEADERS, timeout=5)
        matches = re.findall(r'murl&quot;:&quot;(https?://.*?)&quot;', response.text)
        return matches[:5]
    except Exception as e:
        log(f"    [ERR-BING] {e}")
    return []

def get_best_image_url(query):
    engines = [search_google, search_bing]
    candidates = []
    
    for engine in engines:
        try:
            urls = engine(query)
            for url in urls:
                if url not in seen_urls and not is_blacklisted(url):
                    candidates.append(url)
        except Exception as e:
            log(f"    [ERR] {e}")
            
    candidates = list(set(candidates))
    log(f"    [CANDIDATES] Menemukan {len(candidates)} kandidat. Menganalisis visual...")
    
    valid_images = []
    
    for url in candidates[:8]:
        content = download_image_content(url)
        if content:
            try:
                img = Image.open(BytesIO(content))
                score = get_image_quality_score(img)
                
                if score > 0:
                    phash = imagehash.phash(img)
                    if is_visually_unique(phash):
                        valid_images.append({
                            'url': url,
                            'phash': phash,
                            'score': score
                        })
            except:
                pass
                
    if not valid_images:
        return None
        
    best_candidate = None
    max_consensus_score = -1
    
    for i, img_a in enumerate(valid_images):
        consensus_score = 0
        similar_count = 0
        
        for j, img_b in enumerate(valid_images):
            if i == j: continue
            dist = img_a['phash'] - img_b['phash']
            if dist < 12:
                similar_count += 1
                consensus_score += img_b['score']
        
        consensus_score += img_a['score']
        if similar_count > 0:
            consensus_score *= (1 + similar_count)
            
        if consensus_score > max_consensus_score:
            max_consensus_score = consensus_score
            best_candidate = img_a
            
    if best_candidate:
        log(f"      [CONSENSUS] Memilih gambar terbaik dari {len(valid_images)} valid.")
        seen_hashes.append(best_candidate['phash'])
        seen_urls.add(best_candidate['url'])
        return best_candidate['url']
    elif valid_images:
        valid_images.sort(key=lambda x: x['score'], reverse=True)
        log("      [FALLBACK] Tidak ada konsensus, mengambil resolusi terbaik.")
        best = valid_images[0]
        seen_hashes.append(best['phash'])
        seen_urls.add(best['url'])
        return best['url']
        
    return None

def get_products_from_db():
    max_retries = 3
    for attempt in range(max_retries):
        try:
            log(f"Menghubungkan ke database (Percobaan {attempt+1}/{max_retries})...")
            conn = mysql.connector.connect(**DB_CONFIG)
            cursor = conn.cursor(dictionary=True)
            
            cursor.execute("SELECT barcode_id, nama_produk FROM produk")
            products = cursor.fetchall()
            
            cursor.close()
            conn.close()
            log("Koneksi database ditutup. Data berhasil diambil.")
            return products
            
        except mysql.connector.Error as err:
            log(f"Database Error: {err}")
            if attempt < max_retries - 1:
                time.sleep(2)
            else:
                log("Gagal terhubung ke database setelah beberapa percobaan.")
                return []
    return []

def load_existing_progress():
    progress = {}
    if os.path.exists(OUTPUT_CSV):
        try:
            with open(OUTPUT_CSV, 'r', encoding='utf-8') as f:
                reader = csv.DictReader(f)
                for row in reader:
                    status = row.get('status', '')
                    if not status:
                        status = 'BERHASIL' if row['image_url'] != 'NOT_FOUND' else 'GAGAL'
                    
                    progress[row['barcode_id']] = {
                        'nama_produk': row['nama_produk'],
                        'image_url': row['image_url'],
                        'status': status
                    }
            log(f"Memuat {len(progress)} data dari file sebelumnya.")
        except Exception as e:
            log(f"Warning: Gagal membaca file lama: {e}")
    return progress

def save_progress(progress_dict):
    with open(OUTPUT_CSV, 'w', newline='', encoding='utf-8') as csvfile:
        fieldnames = ['barcode_id', 'nama_produk', 'image_url', 'status']
        writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
        writer.writeheader()
        for barcode, data in progress_dict.items():
            writer.writerow({
                'barcode_id': barcode,
                'nama_produk': data['nama_produk'],
                'image_url': data['image_url'],
                'status': data['status']
            })
            
def main():
    print("=== GENERATOR LINK GAMBAR (CONSENSUS MODE) ===")
    
    progress = load_existing_progress()
    products = get_products_from_db()
    if not products:
        print("Tidak ada data produk dari database. Keluar.")
        return

    print(f"Total Produk di Database: {len(products)}")
    
    processed_count = 0
    
    for i, p in enumerate(products):
        nama = p['nama_produk']
        barcode = p['barcode_id']
        
        if barcode in progress and progress[barcode]['status'] == 'BERHASIL':
            continue
            
        log(f"\n[{i+1}/{len(products)}] Processing: {nama}")
        
        image_url = get_best_image_url(nama)
        
        if image_url:
            progress[barcode] = {
                'nama_produk': nama,
                'image_url': image_url,
                'status': 'BERHASIL'
            }
            log(f"  [BERHASIL] {image_url}")
        else:
            progress[barcode] = {
                'nama_produk': nama,
                'image_url': 'NOT_FOUND',
                'status': 'GAGAL'
            }
            log("  [GAGAL] Tidak ditemukan link yang valid.")
        
        save_progress(progress)
        processed_count += 1
        time.sleep(0.5)
                
    if processed_count == 0:
        print("\nSemua produk sudah memiliki gambar! Tidak ada yang perlu diproses.")
    else:
        print(f"\nSelesai! {processed_count} produk diproses. Data tersimpan di {OUTPUT_CSV}")

if __name__ == "__main__":
    main()
