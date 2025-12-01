import mysql.connector
import bcrypt

DB_CONFIG = {
    'host': 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com',
    'user': '4HDiYTpxo4XPCdX.root',
    'password': 'LWPPf02KXP13x70h',
    'database': 'nutriscan_db',
    'port': 4000,
    'ssl_disabled': False
}

def reset_password():
    print("=== RESET PASSWORD USER ===")
    email = input("Masukkan Email User: ").strip()
    new_password = input("Masukkan Password Baru: ").strip()
    
    if not email or not new_password:
        print("Email dan Password tidak boleh kosong.")
        return

    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        # Cek user
        cursor.execute("SELECT user_id, nama FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()
        
        if not user:
            print(f"❌ User dengan email '{email}' tidak ditemukan.")
            return
            
        user_id, nama = user
        print(f"User Ditemukan: {nama}")
        
        # Hash password
        salt = bcrypt.gensalt()
        hashed = bcrypt.hashpw(new_password.encode('utf-8'), salt)
        
        # Update password
        cursor.execute("UPDATE users SET password = %s WHERE user_id = %s", (hashed, user_id))
        conn.commit()
        
        print(f"✅ Berhasil! Password untuk {nama} ({email}) telah direset.")
        print(f"Silakan login dengan password baru: {new_password}")
            
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    reset_password()
