import mysql.connector
import os
import webbrowser

DB_CONFIG = {
    'host': 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com',
    'user': '4HDiYTpxo4XPCdX.root',
    'password': 'LWPPf02KXP13x70h',
    'database': 'nutriscan_db',
    'port': 4000,
    'ssl_disabled': False
}

def create_db_gallery():
    print("Mengambil data dari database...")
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor(dictionary=True)
        
        cursor.execute("SELECT nama_produk, image_product_link, barcode_id FROM produk WHERE image_product_link IS NOT NULL")
        products = cursor.fetchall()
        
        cursor.close()
        conn.close()
        
        if not products:
            print("Belum ada gambar di database.")
            return

        html_content = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>Database Image Gallery</title>
            <style>
                body { font-family: sans-serif; background: #f0f2f5; padding: 20px; }
                h1 { text-align: center; color: #333; }
                .grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 20px; }
                .card { background: white; padding: 10px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); text-align: center; }
                img { width: 100%; height: 200px; object-fit: contain; border-radius: 4px; }
                .name { margin-top: 10px; font-size: 14px; font-weight: bold; color: #333; }
                .barcode { font-size: 12px; color: #666; }
            </style>
        </head>
        <body>
            <h1>Galeri Gambar Database NutriScan</h1>
            <p style="text-align: center">Total: """ + str(len(products)) + """ Produk</p>
            <div class="grid">
        """
        
        for p in products:
            html_content += f"""
                <div class="card">
                    <img src="{p['image_product_link']}" loading="lazy" onerror="this.src='https://via.placeholder.com/200?text=Error'">
                    <div class="name">{p['nama_produk']}</div>
                    <div class="barcode">{p['barcode_id']}</div>
                </div>
            """
            
        html_content += """
            </div>
        </body>
        </html>
        """
        
        filename = "db_gallery.html"
        with open(filename, "w", encoding="utf-8") as f:
            f.write(html_content)
            
        print(f"Berhasil membuat {filename}. Membuka di browser...")
        webbrowser.open(f"file:///{os.path.abspath(filename)}")
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    create_db_gallery()
