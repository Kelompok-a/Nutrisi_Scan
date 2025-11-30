const mysql = require('mysql2');

const db = mysql.createConnection({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'nutriscan_db'
});

db.connect(err => {
    if (err) {
        console.error('Error connecting:', err);
        return;
    }
    console.log('Connected to database.');

    const query = `
        SELECT COLUMN_NAME 
        FROM INFORMATION_SCHEMA.COLUMNS 
        WHERE TABLE_SCHEMA = 'nutriscan_db' AND TABLE_NAME = 'komposisi_gizi';
    `;

    db.query(query, (err, results) => {
        if (err) {
            console.error('Error querying schema:', err);
        } else {
            console.log('Columns in komposisi_gizi:');
            results.forEach(r => console.log(r.COLUMN_NAME));
        }
        db.end();
    });
});
