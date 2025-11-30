const mysql = require('mysql2');

const db = mysql.createPool({
    host: 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com',
    user: '4HDiYTpxo4XPCdX.root',
    password: 'LWPPf02KXP13x70h',
    database: 'nutriscan_db',
    port: 4000,
    ssl: {
        rejectUnauthorized: true
    }
}).promise();

async function createTable() {
    try {
        const query = `
            CREATE TABLE IF NOT EXISTS history (
                id_history INT AUTO_INCREMENT PRIMARY KEY,
                user_id INT NOT NULL,
                query VARCHAR(255) NOT NULL,
                type VARCHAR(50) DEFAULT 'search',
                timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
                FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
            )
        `;
        await db.query(query);
        console.log('Table history created successfully');
    } catch (error) {
        console.error('Error creating table:', error);
    } finally {
        process.exit();
    }
}

createTable();
