import csv
import webbrowser
import os
import time

INPUT_CSV = "product_images.csv"
OUTPUT_CSV = "product_images_verified.csv"

def main():
    print("=== MANUAL IMAGE VERIFICATION TOOL ===")
    print("Program ini akan membuka link gambar satu per satu di browser.")
    print("Anda bisa memverifikasi dan mengganti link jika salah.")
    print("-" * 50)

    if not os.path.exists(INPUT_CSV):
        print(f"File {INPUT_CSV} tidak ditemukan. Jalankan generate_image_links.py terlebih dahulu.")
        return

    # Load data
    rows = []
    with open(INPUT_CSV, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        fieldnames = reader.fieldnames
        rows = list(reader)

    verified_rows = []
    
    # Cek jika ada progress sebelumnya
    start_index = 0
    if os.path.exists(OUTPUT_CSV):
        with open(OUTPUT_CSV, 'r', encoding='utf-8') as f:
            reader = csv.DictReader(f)
            verified_rows = list(reader)
            start_index = len(verified_rows)
            if start_index > 0:
                print(f"Melanjutkan verifikasi dari produk ke-{start_index + 1}...")

    try:
        for i in range(start_index, len(rows)):
            row = rows[i]
            nama = row['nama_produk']
            url = row['image_url']
            barcode = row['barcode_id']

            print(f"\n[{i+1}/{len(rows)}] Produk: {nama}")
            print(f"URL: {url}")

            if url == 'NOT_FOUND':
                print("Status: BELUM ADA GAMBAR")
                webbrowser.open(f"https://www.google.com/search?q={nama} kemasan produk indonesia&tbm=isch")
            else:
                # Buat file HTML sementara agar bisa menampilkan Nama Produk di atas gambar
                html_content = f"""
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Verifikasi: {nama}</title>
                    <style>
                        body {{ font-family: sans-serif; text-align: center; padding: 20px; background: #f0f2f5; }}
                        .card {{ background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); display: inline-block; }}
                        h1 {{ color: #1a73e8; margin-bottom: 10px; }}
                        img {{ max-height: 500px; max-width: 100%; border: 1px solid #ddd; border-radius: 5px; }}
                        .url {{ color: #666; font-size: 12px; margin-top: 10px; word-break: break-all; }}
                        .hint {{ margin-top: 20px; font-weight: bold; color: #333; }}
                    </style>
                </head>
                <body>
                    <div class="card">
                        <h1>{nama}</h1>
                        <img src="{url}" alt="Gambar Produk">
                        <div class="url">{url}</div>
                    </div>
                    <div class="hint">Silakan kembali ke Terminal untuk Verifikasi (Y/N/Ganti)</div>
                </body>
                </html>
                """
                
                temp_file = os.path.abspath("temp_view.html")
                with open(temp_file, "w", encoding="utf-8") as f:
                    f.write(html_content)
                
                webbrowser.open(f"file:///{temp_file}")

            while True:
                print("\nApakah gambar ini BENAR?")
                print("  [Enter] : YA - Simpan & Lanjut")
                print("  [x]     : TIDAK - Hapus & Ganti Link")
                
                choice = input("Pilihan Anda: ").strip()

                if choice == "":
                    # Keep existing
                    verified_rows.append(row)
                    print("✅ Disimpan.")
                    break
                elif choice.lower() == 'x':
                    # Wrong image flow
                    print("\n--- MENGGANTI GAMBAR ---")
                    print("1. Membuka pencarian Google untuk Anda...")
                    webbrowser.open(f"https://www.google.com/search?q={nama} kemasan produk indonesia&tbm=isch")
                    
                    # 2. Force input new link
                    while True:
                        new_link = input(">> Paste Link Gambar Baru (atau ketik 'skip' jika menyerah): ").strip()
                        
                        if new_link.lower() == 'skip':
                            row['image_url'] = 'NOT_FOUND'
                            row['status'] = 'GAGAL'
                            print("❌ Dilewati (Tanpa Gambar).")
                            break
                        elif new_link.startswith("http"):
                            row['image_url'] = new_link
                            row['status'] = 'BERHASIL'
                            print("✅ Link diperbarui.")
                            break
                        else:
                            print("Link tidak valid. Harus diawali http atau https.")
                    
                    verified_rows.append(row)
                    break
                else:
                    print("Input tidak valid.")

            # Save progress after each step
            with open(OUTPUT_CSV, 'w', newline='', encoding='utf-8') as f:
                writer = csv.DictWriter(f, fieldnames=fieldnames)
                writer.writeheader()
                writer.writerows(verified_rows)

    except KeyboardInterrupt:
        print("\n\nVerifikasi dihentikan pengguna. Progress tersimpan.")
    
    print(f"\nSelesai! Data terverifikasi disimpan di {OUTPUT_CSV}")

if __name__ == "__main__":
    main()
