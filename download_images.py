import mysql.connector
import os
import requests
import re
from barcode import Code128
from barcode.writer import ImageWriter
from duckduckgo_search import DDGS
import time
import random

# Konfigurasi Database
DB_CONFIG = {
    'host': 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com',
    'user': '4HDiYTpxo4XPCdX.root',
    'password': 'LWPPf02KXP13x70h',
    'database': 'nutriscan_db',
    'port': 4000,
    'ssl_disabled': False
}

# Direktori Output
ASSETS_DIR = "assets/images"
PRODUCTS_DIR = os.path.join(ASSETS_DIR, "products")
BARCODES_DIR = os.path.join(ASSETS_DIR, "barcodes")

# Buat direktori jika belum ada
os.makedirs(PRODUCTS_DIR, exist_ok=True)
os.makedirs(BARCODES_DIR, exist_ok=True)

HEADERS = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}

def sanitize_filename(name):
    """Membersihkan nama file dari karakter ilegal."""
    s = re.sub(r'[^\w\s-]', '', str(name)).strip().lower()
    return re.sub(r'[-\s]+', '_', s)

def download_file(url, save_path):
    """Helper untuk download file dari URL."""
    try:
        response = requests.get(url, headers=HEADERS, timeout=10)
        if response.status_code == 200:
            with open(save_path, 'wb') as f:
                f.write(response.content)
            return True
    except Exception as e:
        print(f"    [ERR-DL] {e}")
    return False

def search_ddg(query):
    """Search using DuckDuckGo."""
    print("    [TRY] Engine: DuckDuckGo")
    try:
        with DDGS() as ddgs:
            results = list(ddgs.images(query, max_results=1))
            if results:
                return results[0]['image']
    except Exception as e:
        print(f"    [ERR-DDG] {e}")
    return None

def search_google(query):
    """Fallback Search using Google (Scraping)."""
    print("    [TRY] Engine: Google")
    try:
        url = f"https://www.google.com/search?q={query}&tbm=isch"
        response = requests.get(url, headers=HEADERS, timeout=10)
        # Cari URL gambar dalam source code (biasanya ada di dalam pola ["http...", ...])
        # Ini regex sederhana dan mungkin tidak selalu dapat high-res, tapi cukup untuk fallback
        matches = re.findall(r'"(https?://[^"]+\.(?:jpg|jpeg|png))"', response.text)
        for match in matches:
            # Filter url yang aneh/kecil jika perlu
            if 'gstatic' not in match: # Hindari thumbnail google cached jika memungkinkan
                return match
        if matches:
            return matches[0] # Ambil apa saja jika tidak ada yang non-gstatic
    except Exception as e:
        print(f"    [ERR-GOOG] {e}")
    return None

def search_bing(query):
    """Fallback Search using Bing (Scraping)."""
    print("    [TRY] Engine: Bing")
    try:
        url = f"https://www.bing.com/images/search?q={query}"
        response = requests.get(url, headers=HEADERS, timeout=10)
        # Bing biasanya menaruh url di murl":"..."
        matches = re.findall(r'murl&quot;:&quot;(https?://.*?)&quot;', response.text)
        if matches:
            return matches[0]
    except Exception as e:
        print(f"    [ERR-BING] {e}")
    return None

def search_and_download_multi_engine(query, save_path, type_desc="Gambar"):
    """Mencoba download dengan 3 engine dan retry."""
    if os.path.exists(save_path):
        print(f"  [SKIP] {type_desc} sudah ada.")
        return True

    print(f"  [SEARCH] Mencari {type_desc}: {query}...")
    
    engines = [search_ddg, search_google, search_bing]
    
    # Coba setiap engine
    for engine in engines:
        # Retry 3x per engine (atau total? User minta "3x metode download ulang")
        # Kita buat retry logic sederhana: Coba engine ini, kalau gagal retry 2x lagi, lalu pindah engine.
        
        for attempt in range(3):
            image_url = engine(query)
            if image_url:
                print(f"    [FOUND] URL: {image_url[:60]}...")
                if download_file(image_url, save_path):
                    print(f"  [SUCCESS] {type_desc} tersimpan.")
                    return True
                else:
                    print(f"    [FAIL-DL] Gagal download, mencoba lagi ({attempt+1}/3)...")
            else:
                print(f"    [FAIL-FIND] Tidak ketemu di engine ini, mencoba lagi ({attempt+1}/3)...")
            
            time.sleep(1) # Jeda dikit antar retry
            
        print("    [NEXT] Pindah ke engine berikutnya...")
    
    print(f"  [FAIL-ALL] Gagal mendapatkan {type_desc} dari semua engine.")
    return False

def generate_barcode_fallback(barcode_id, save_path_no_ext):
    """Fallback: Generate barcode jika download gagal."""
    expected_path = save_path_no_ext + ".png"
    if os.path.exists(expected_path):
        return

    print(f"  [GENERATE] Membuat barcode lokal: {barcode_id}")
    try:
        barcode_id = str(barcode_id)
        rv = Code128(barcode_id, writer=ImageWriter())
        rv.save(save_path_no_ext)
        print(f"  [SUCCESS] Barcode generated.")
    except Exception as e:
        print(f"  [ERROR] Gagal generate barcode: {e}")

def main():
    print("=== MULAI PROSES DOWNLOAD GAMBAR & BARCODE (MULTI-ENGINE) ===")
    
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor(dictionary=True)
        
        cursor.execute("SELECT barcode_id, nama_produk FROM produk")
        products = cursor.fetchall()
        
        print(f"Ditemukan {len(products)} produk.")
        
        for i, p in enumerate(products):
            nama = p['nama_produk']
            barcode = p['barcode_id']
            safe_name = sanitize_filename(nama)
            
            print(f"\n[{i+1}/{len(products)}] Memproses: {nama}")
            
            # 1. Download Product Image
            product_img_path = os.path.join(PRODUCTS_DIR, f"{safe_name}.jpg")
            search_and_download_multi_engine(nama, product_img_path, "Produk")
            
            # 2. Download Barcode Image
            barcode_img_path = os.path.join(BARCODES_DIR, f"{safe_name}.jpg")
            barcode_query = f"barcode {barcode}"
            
            if not search_and_download_multi_engine(barcode_query, barcode_img_path, "Barcode"):
                # Fallback Generate
                barcode_gen_path = os.path.join(BARCODES_DIR, safe_name)
                generate_barcode_fallback(barcode, barcode_gen_path)
            
            time.sleep(random.uniform(1.0, 2.0))
            
    except mysql.connector.Error as err:
        print(f"Database Error: {err}")
    finally:
        if 'conn' in locals() and conn.is_connected():
            cursor.close()
            conn.close()
            print("\nKoneksi database ditutup.")

if __name__ == "__main__":
    main()
