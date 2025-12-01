import mysql.connector

DB_CONFIG = {
    'host': 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com',
    'user': '4HDiYTpxo4XPCdX.root',
    'password': 'LWPPf02KXP13x70h',
    'database': 'nutriscan_db',
    'port': 4000,
    'ssl_disabled': False
}

def check_schema():
    try:
        conn = mysql.connector.connect(**DB_CONFIG)
        cursor = conn.cursor()
        
        print("--- Columns in 'users' table ---")
        cursor.execute("DESCRIBE users")
        for column in cursor.fetchall():
            print(column)
            
        cursor.close()
        conn.close()
        
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check_schema()
