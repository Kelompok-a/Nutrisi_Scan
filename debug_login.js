const mysql = require('mysql2');
const bcrypt = require('bcryptjs');

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

async function debugLogin() {
    try {
        console.log("Connecting to DB...");
        const email = 'indra@gmail.com';
        const password = '123456';

        const [users] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
        console.log("Users found:", users.length);

        if (users.length === 0) {
            console.log("User not found");
            return;
        }

        const user = users[0];
        console.log("User data:", user);
        console.log("Stored hash:", user.password);

        console.log("Comparing password...");
        const isMatch = await bcrypt.compare(password, user.password);
        console.log("Is Match:", isMatch);

    } catch (error) {
        console.error("Debug Error:", error);
    } finally {
        process.exit();
    }
}

debugLogin();
