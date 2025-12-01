import mysql.connector

DB_CONFIG = {
    'host': 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com',
    'user': '4HDiYTpxo4XPCdX.root',
    'password': 'LWPPf02KXP13x70h',
    'database': 'nutriscan_db',
    'port': 4000,
    'ssl_disabled': False
}

def migrate():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        print("Checking 'users' table for 'created_at' column...")
        
        # Check if column exists
        cursor.execute("SHOW COLUMNS FROM users LIKE 'created_at'")
        result = cursor.fetchone()
        
        if not result:
            print("Adding 'created_at' column...")
            cursor.execute("ALTER TABLE users ADD COLUMN created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP")
            conn.commit()
            print("✅ Column 'created_at' added successfully.")
        else:
            print("ℹ️ Column 'created_at' already exists.")
            
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"❌ Error: {e}")

if __name__ == "__main__":
    migrate()
