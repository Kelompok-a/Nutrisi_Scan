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

def fix_password():
    email = 'indra@gmail.com'
    new_password = '123456'
    
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        print(f"Resetting password for {email}...")
        
        salt = bcrypt.gensalt()
        hashed = bcrypt.hashpw(new_password.encode('utf-8'), salt)
        
        cursor.execute("UPDATE users SET password = %s WHERE email = %s", (hashed, email))
        conn.commit()
        
        print(f"✅ Password reset to '{new_password}'")
            
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    fix_password()
