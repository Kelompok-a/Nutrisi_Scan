import mysql.connector

DB_CONFIG = {
    'host': 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com',
    'user': '4HDiYTpxo4XPCdX.root',
    'password': 'LWPPf02KXP13x70h',
    'database': 'nutriscan_db',
    'port': 4000,
    'ssl_disabled': False
}

def promote_user():
    print("=== PROMOTE USER TO ADMIN ===")
    email = input("Masukkan Email User yang akan dijadikan Admin: ").strip()
    
    if not email:
        print("Email tidak boleh kosong.")
        return

    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        # Cek user
        cursor.execute("SELECT user_id, nama, role FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()
        
        if not user:
            print(f"❌ User dengan email '{email}' tidak ditemukan.")
            return
            
        user_id, nama, current_role = user
        print(f"User Ditemukan: {nama} (Role saat ini: {current_role})")
        
        confirm = input(f"Apakah Anda yakin ingin mengubah {nama} menjadi ADMIN? (y/n): ").lower()
        if confirm == 'y':
            cursor.execute("UPDATE users SET role = 'admin' WHERE user_id = %s", (user_id,))
            conn.commit()
            print(f"✅ Berhasil! {nama} sekarang adalah ADMIN.")
        else:
            print("Dibatalkan.")
            
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    promote_user()
