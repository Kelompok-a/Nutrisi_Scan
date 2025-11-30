const mysql = require('mysql2/promise');
const fs = require('fs');

const config = {
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'nutriscan_db'
};

async function exportDatabase() {
    const connection = await mysql.createConnection(config);
    let sql = '';

    try {
        const [tables] = await connection.query('SHOW TABLES');

        for (const row of tables) {
            const tableName = Object.values(row)[0];
            console.log(`Exporting table: ${tableName}`);

            // Get Create Table statement
            const [createResult] = await connection.query(`SHOW CREATE TABLE \`${tableName}\``);
            sql += `DROP TABLE IF EXISTS \`${tableName}\`;\n`;
            sql += `${createResult[0]['Create Table']};\n\n`;

            // Get Data
            const [rows] = await connection.query(`SELECT * FROM \`${tableName}\``);
            if (rows.length > 0) {
                sql += `INSERT INTO \`${tableName}\` VALUES `;
                const values = rows.map(row => {
                    return '(' + Object.values(row).map(val => {
                        if (val === null) return 'NULL';
                        if (typeof val === 'number') return val;
                        return connection.escape(val); // Escape strings safely
                    }).join(', ') + ')';
                }).join(',\n');
                sql += `${values};\n\n`;
            }
        }

        fs.writeFileSync('nutriscan_db_dump.sql', sql);
        console.log('Database exported successfully to nutriscan_db_dump.sql');

    } catch (err) {
        console.error('Export failed:', err);
    } finally {
        await connection.end();
    }
}

exportDatabase();
