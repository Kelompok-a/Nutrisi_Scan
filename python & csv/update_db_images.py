import mysql.connector
import csv
import os

DB_CONFIG = {
    'host': 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com',
    'user': '4HDiYTpxo4XPCdX.root',
    'password': 'LWPPf02KXP13x70h',
    'database': 'nutriscan_db',
    'port': 4000,
    'ssl_disabled': False
}

INPUT_CSV = "product_images_verified.csv"

def update_database():
    if not os.path.exists(INPUT_CSV):
        print(f"File {INPUT_CSV} tidak ditemukan!")
        return

    print("Menghubungkan ke database...")
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        with open(INPUT_CSV, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            rows = list(reader)
            
        print(f"Memproses {len(rows)} data produk...")
        
        updated_count = 0
        for row in rows:
            barcode = row['barcode_id']
            url = row['image_url']
            
            # Jika status GAGAL atau NOT_FOUND, set NULL (atau biarkan kosong)
            if url == 'NOT_FOUND' or not url.startswith('http'):
                sql = "UPDATE produk SET image_product_link = NULL WHERE barcode_id = %s"
                val = (barcode,)
            else:
                sql = "UPDATE produk SET image_product_link = %s WHERE barcode_id = %s"
                val = (url, barcode)
                
            try:
                cursor.execute(sql, val)
                updated_count += 1
                if updated_count % 10 == 0:
                    print(f"  Updated {updated_count}...")
            except mysql.connector.Error as err:
                print(f"  Error updating {barcode}: {err}")
                
        conn.commit()
        cursor.close()
        conn.close()
        print(f"\n✅ Selesai! {updated_count} produk berhasil diupdate di database.")
        
    except Exception as e:
        print(f"Database connection failed: {e}")

if __name__ == "__main__":
    update_database()
