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
from duckduckgo_search import DDGS

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

BLACKLIST_DOMAINS = [
    'pngall.com', 'pngtree.com', 'freepik.com', 'pixabay.com', 'unsplash.com',
    'e7.pngegg.com', 'w7.pngwing.com', 'banner2.cleanpng.com', 'img.lovepik.com',
    'icon-library.com', 'clipart-library.com', 'shopee', 'tokopedia', 'bukalapak', 'lazada'
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
    """Menghitung perceptual hash dari gambar."""
    try:
        img = Image.open(BytesIO(image_content))
        return imagehash.phash(img)
    except Exception as e:
        return None

def is_visually_unique(new_hash, threshold=5):
    """Cek apakah gambar unik dibandingkan dengan yang sudah ada."""
    if new_hash is None:
        return False
    
    for existing_hash in seen_hashes:
        if new_hash - existing_hash < threshold: # Hamming distance
            return False
    return True

def validate_and_process_image(url):
    """Validasi URL, Content-Type, Dimensi, dan Visual Uniqueness."""
    if url in seen_urls or is_blacklisted(url):
        return False

    try:
        # Download konten untuk hashing (limit 5MB biar gak berat)
        response = requests.get(url, headers=HEADERS, timeout=5, stream=True)
        if response.status_code == 200:
            content_type = response.headers.get('Content-Type', '')
            if not content_type.startswith('image/'):
                return False
            
            # Baca konten (max 5MB)
            content = b""
            for chunk in response.iter_content(1024):
                content += chunk
                if len(content) > 5 * 1024 * 1024:
                    return False
            
            # Buka gambar dengan PIL
            try:
                img = Image.open(BytesIO(content))
                
                # 1. Filter Resolusi Minimal (Hindari icon/thumbnail buram)
                width, height = img.size
                if width < 300 or height < 300:
                    # log(f"      [SKIP] Resolusi terlalu kecil ({width}x{height}).")
                    return False
                
                # 2. Filter Aspect Ratio (Hindari Banner/Wallpaper/Background)
                # Produk biasanya kotak (1:1) atau agak tinggi (3:4). 
                # Banner biasanya > 2:1.
                aspect_ratio = width / height
                if aspect_ratio > 1.8 or aspect_ratio < 0.5:
                    # log(f"      [SKIP] Rasio gambar aneh ({aspect_ratio:.2f}).")
                    return False
                
                # 3. Cek Visual Uniqueness
                img_hash = imagehash.phash(img)
                if img_hash and is_visually_unique(img_hash):
                    seen_urls.add(url)
                    seen_hashes.append(img_hash)
                    return True
                else:
                    log(f"      [DUPLICATE] Gambar mirip dengan produk lain.")
            except Exception:
                return False
                
    except Exception as e:
        pass
    return False

def refine_query_smartly(product_name):
    """
    Membuat query pencarian yang cerdas dengan negative keywords
    berdasarkan analisis nama produk.
    """
    name_lower = product_name.lower()
    keywords = [product_name] # Base query
    negatives = ["-wallpaper", "-background", "-scenery", "-landscape", "-bundle", "-promo"]
    
    # Logika Indomie/Mie Instan
    if "indomie" in name_lower or "mie" in name_lower:
        # Jika Kuah, hindari Goreng
        if "kuah" in name_lower or "rebus" in name_lower:
            negatives.extend(["-goreng", "-fried", "-dry"])
        # Jika Goreng, hindari Kuah
        elif "goreng" in name_lower:
            negatives.extend(["-kuah", "-soup", "-rebus", "-soto", "-kari", "-ayam bawang"])
            
        # Spesifik Rasa (Mutual Exclusion)
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
                
    # Gabungkan
    query = f'"{product_name}" kemasan produk indonesia ' + " ".join(negatives)
    return query

def search_google(query):
    # Gunakan Smart Query
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
    # Bing query lebih simple tapi tetap pakai negative
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

def search_ddg(query):
    refined_query = f"{query} indonesia kemasan"
    log(f"    [TRY] Engine: DuckDuckGo ({refined_query})")
    try:
        with DDGS() as ddgs:
            results = list(ddgs.images(refined_query, max_results=5))
            return [r['image'] for r in results]
    except Exception as e:
        log(f"    [ERR-DDG] {e}")
    return []

def get_best_image_url(query):
    # Hapus DuckDuckGo karena sering kena rate limit (403)
    engines = [search_google, search_bing]
    
    for engine in engines:
        try:
            candidates = engine(query)
            if candidates:
                log(f"    [FOUND] {len(candidates)} kandidat.")
                for url in candidates:
                    if validate_and_process_image(url):
                        log("      [VALID] URL Unik & Valid!")
                        return url
        except Exception as e:
            log(f"    [ERR] {e}")
        
    return None

def get_products_from_db():
    """Mengambil data produk dari database dengan retry."""
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
    """Membaca progress dari CSV jika ada."""
    progress = {}
    if os.path.exists(OUTPUT_CSV):
        try:
            with open(OUTPUT_CSV, 'r', encoding='utf-8') as f:
                reader = csv.DictReader(f)
                for row in reader:
                    # Support format lama (tanpa status)
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
    """Menyimpan seluruh progress ke CSV."""
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
    print("=== GENERATOR LINK GAMBAR (RETRY MODE) ===")
    
    # 1. Load data lama
    progress = load_existing_progress()
    
    # 2. Ambil data dari DB
    products = get_products_from_db()
    if not products:
        print("Tidak ada data produk dari database. Keluar.")
        return

    print(f"Total Produk di Database: {len(products)}")
    
    processed_count = 0
    
    for i, p in enumerate(products):
        nama = p['nama_produk']
        barcode = p['barcode_id']
        
        # Cek apakah sudah ada dan BERHASIL
        if barcode in progress and progress[barcode]['status'] == 'BERHASIL':
            # log(f"[{i+1}/{len(products)}] {nama} -> SUDAH ADA (SKIP)")
            continue
            
        log(f"\n[{i+1}/{len(products)}] Processing: {nama}")
        
        # Cari gambar
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
        
        # Simpan setiap kali selesai satu produk (biar aman kalau stop di tengah)
        save_progress(progress)
        processed_count += 1
        
        # Delay
        time.sleep(0.5)
                
    if processed_count == 0:
        print("\nSemua produk sudah memiliki gambar! Tidak ada yang perlu diproses.")
    else:
        print(f"\nSelesai! {processed_count} produk diproses. Data tersimpan di {OUTPUT_CSV}")

if __name__ == "__main__":
    main()
