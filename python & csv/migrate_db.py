import mysql.connector
import time

DB_CONFIG = {
    'host': 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com',
    'user': '4HDiYTpxo4XPCdX.root',
    'password': 'LWPPf02KXP13x70h',
    'database': 'nutriscan_db',
    'port': 4000,
    'ssl_disabled': False
}

def migrate():
    print("Connecting to database...")
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        # 1. Add 'allergies' to 'users' table
        print("Checking 'users' table...")
        try:
            cursor.execute("ALTER TABLE users ADD COLUMN allergies TEXT DEFAULT NULL")
            print("✅ Added 'allergies' column to 'users'")
        except mysql.connector.Error as err:
            if "Duplicate column" in str(err):
                print("ℹ️ Column 'allergies' already exists in 'users'")
            else:
                print(f"❌ Error adding column to users: {err}")

        # 2. Add 'allergens' to 'produk' table
        print("Checking 'produk' table...")
        try:
            cursor.execute("ALTER TABLE produk ADD COLUMN allergens TEXT DEFAULT NULL")
            print("✅ Added 'allergens' column to 'produk'")
        except mysql.connector.Error as err:
            if "Duplicate column" in str(err):
                print("ℹ️ Column 'allergens' already exists in 'produk'")
            else:
                print(f"❌ Error adding column to produk: {err}")

        conn.commit()
        cursor.close()
        conn.close()
        print("Migration complete.")
        
    except Exception as e:
        print(f"Migration failed: {e}")

if __name__ == "__main__":
    migrate()
