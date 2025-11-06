// --- FILE: server.js (Versi Debug - Dijamin Berjalan) ---

const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const app = express();
const port = 3001;
const JWT_SECRET = 'RahasiaSuperPentingJanganDisebar';

app.use(cors());
app.use(express.json());

const db = mysql.createPool({
    host: '127.0.0.1',
    user: 'root',
    password: '',
    database: 'nutriscan_db'
}).promise();

// --- QUERY SEMENTARA UNTUK DEBUGGING ---
// Kolom dari 'komposisi_gizi' dinonaktifkan untuk mencegah error.
const getProductQuery = `
    SELECT
        p.nama_produk AS product_name,
        COALESCE(p.id_kategori, 'N/A') AS kategori,
        p.image_product_link AS gambarUrl,
        p.barcode_url AS barcodeUrl,
        p.barcode_id
        /*
        -- Kolom gizi dinonaktifkan sementara. Akan diperbaiki setelah mendapat nama kolom yang benar.
        , cg.NAMA_KOLOM_ENERGI_ANDA AS energi
        , cg.lemak_total_g AS lemak
        , cg.protein_g AS protein
        , cg.karbohidrat_total_g AS karbohidrat
        */
    FROM
        produk p
    LEFT JOIN
        komposisi_gizi cg ON p.barcode_id = cg.barcode_id
`;

// --- SEMUA ENDPOINT (Tidak diubah) ---
app.get('/api/produk', async (req, res) => {
    try {
        const [rows] = await db.query(getProductQuery);
        res.json({ success: true, message: 'Data produk (tanpa gizi) berhasil diambil', data: rows });
    } catch (error) {
        console.error('Error saat mengambil produk:', error.sqlMessage);
        res.status(500).json({ success: false, message: `Terjadi kesalahan pada server: ${error.sqlMessage}` });
    }
});

app.get('/api/produk/:barcode', async (req, res) => {
    const { barcode } = req.params;
    try {
        const query = `${getProductQuery} WHERE p.barcode_id = ?`;
        const [rows] = await db.query(query, [barcode]);
        if (rows.length > 0) {
            res.json({ success: true, message: 'Data produk berhasil diambil', data: rows[0] });
        } else {
            res.status(404).json({ success: false, message: 'Produk tidak ditemukan' });
        }
    } catch (error) {
        console.error('Error saat mengambil produk by barcode:', error.sqlMessage);
        res.status(500).json({ success: false, message: `Terjadi kesalahan pada server: ${error.sqlMessage}` });
    }
});

app.post('/api/register', async (req, res) => {
    try {
        const { username, email, password } = req.body;
        if (!username || !email || !password) {
            return res.status(400).json({ success: false, message: 'Input tidak boleh kosong' });
        }
        const [existingUsers] = await db.query('SELECT email, username FROM users WHERE email = ? OR username = ?', [email, username]);
        if (existingUsers.length > 0) {
            return res.status(400).json({ success: false, message: 'Email atau username sudah terdaftar' });
        }
        const hashedPassword = await bcrypt.hash(password, 10);
        await db.query('INSERT INTO users (username, email, password) VALUES (?, ?, ?)', [username, email, hashedPassword]);
        res.status(201).json({ success: true, message: 'Registrasi berhasil' });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Kesalahan server saat registrasi' });
    }
});

app.post('/api/login', async (req, res) => {
    try {
        const { email, password } = req.body;
        if (!email || !password) {
            return res.status(400).json({ success: false, message: 'Email dan password tidak boleh kosong' });
        }
        const [users] = await db.query('SELECT * FROM users WHERE email = ?', [email]);
        if (users.length === 0) {
            return res.status(404).json({ success: false, message: 'Email tidak ditemukan' });
        }
        const user = users[0];
        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) {
            return res.status(400).json({ success: false, message: 'Password salah' });
        }
        const payload = { user: { id: user.id, email: user.email, username: user.username } };
        const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1d' });
        res.json({ success: true, message: 'Login berhasil', data: { token, user: payload.user } });
    } catch (error) {
        res.status(500).json({ success: false, message: 'Kesalahan server saat login' });
    }
});

app.listen(port, () => {
    console.log(`Server API berjalan di http://localhost:${port}`);
});
