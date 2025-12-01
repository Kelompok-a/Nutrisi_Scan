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
    host: 'gateway01.ap-southeast-1.prod.aws.tidbcloud.com',
    user: '4HDiYTpxo4XPCdX.root',
    password: 'LWPPf02KXP13x70h',
    database: 'nutriscan_db',
    port: 4000,
    ssl: {
        rejectUnauthorized: true
    }
}).promise();

// Cek koneksi database saat startup
db.getConnection()
    .then(conn => {
        console.log("Database connected successfully");
        conn.release();
    })
    .catch(err => {
        console.error("Database connection failed:", err);
    });

process.on('uncaughtException', (err) => {
    console.error('Uncaught Exception:', err);
});

process.on('unhandledRejection', (reason, promise) => {
    console.error('Unhandled Rejection at:', promise, 'reason:', reason);
});

// Middleware untuk verifikasi token
const authenticateToken = (req, res, next) => {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];
    if (!token) return res.status(401).json({ success: false, message: 'Akses ditolak' });

    jwt.verify(token, JWT_SECRET, (err, user) => {
        if (err) return res.status(403).json({ success: false, message: 'Token tidak valid' });
        req.user = user;
        next();
    });
};

// --- ADMIN MIDDLEWARE ---
const authenticateAdmin = (req, res, next) => {
    authenticateToken(req, res, () => {
        const userId = req.user.user.id;
        db.query('SELECT role FROM users WHERE user_id = ?', [userId])
            .then(([rows]) => {
                if (rows.length > 0 && rows[0].role === 'admin') {
                    next();
                } else {
                    res.status(403).json({ success: false, message: 'Akses Admin diperlukan' });
                }
            })
            .catch(err => {
                console.error('Admin check error:', err);
                res.status(500).json({ success: false, message: 'Gagal memverifikasi admin' });
            });
    });
};

// --- QUERY SEMENTARA UNTUK DEBUGGING ---
// Kolom dari 'komposisi_gizi' dinonaktifkan untuk mencegah error.
const getProductQuery = `
    SELECT
        p.nama_produk AS product_name,
        COALESCE(p.id_kategori, 'N/A') AS kategori,
        p.image_product_link AS gambarUrl,
        p.barcode_url AS barcodeUrl,
        p.barcode_id
        , cg.total_calories AS energi
        , cg.total_fat AS lemak
        , cg.protein AS protein
        , cg.total_carbohydrates AS karbohidrat
        , cg.total_sugar AS gula
        , cg.saturated_fat AS lemak_jenuh
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

app.get('/api/produk/:barcode', authenticateToken, async (req, res) => {
    const { barcode } = req.params;
    const userId = req.user.user.id; // Ambil ID user dari token

    try {
        // 1. Ambil Data Produk & Gizi
        const query = `${getProductQuery} WHERE p.barcode_id = ?`;
        const [rows] = await db.query(query, [barcode]);

        if (rows.length === 0) {
            return res.status(404).json({ success: false, message: 'Produk tidak ditemukan' });
        }

        const product = rows[0];

        // 2. Ambil Data Alergi User
        const [userRows] = await db.query('SELECT allergies FROM users WHERE user_id = ?', [userId]);
        const userAllergies = userRows.length > 0 && userRows[0].allergies ? JSON.parse(userRows[0].allergies) : [];

        // 3. Logika Traffic Light (Lampu Gizi)
        // Standar Kemenkes/WHO (per 100g/ml approx)
        const getStatus = (value, low, high) => {
            if (value > high) return 'red';
            if (value > low) return 'yellow';
            return 'green';
        };

        const nutritionStatus = {
            gula: getStatus(product.gula || 0, 5, 10),      // >10g Merah
            lemak: getStatus(product.lemak || 0, 3, 17.5),  // >17.5g Merah
            garam: getStatus(0, 0.3, 1.5),                  // Placeholder (data garam belum ada)
            kalori: (product.energi || 0) > 200 ? 'red' : 'green' // Simplifikasi
        };

        // 4. Logika Cek Alergi
        // Asumsi kolom 'allergens' di produk berisi JSON array string: '["kacang", "susu"]'
        // Atau string CSV: "kacang, susu"
        let productAllergens = [];
        if (product.allergens) {
            try {
                productAllergens = JSON.parse(product.allergens);
            } catch (e) {
                productAllergens = product.allergens.split(',').map(s => s.trim().toLowerCase());
            }
        }

        const allergenAlerts = [];
        userAllergies.forEach(allergy => {
            if (productAllergens.includes(allergy.toLowerCase())) {
                allergenAlerts.push(allergy);
            }
        });

        // 5. Gabungkan Response
        res.json({
            success: true,
            message: 'Data produk berhasil diambil',
            data: {
                ...product,
                nutritionStatus,
                allergenAlerts,
                hasAllergenConflict: allergenAlerts.length > 0
            }
        });

    } catch (error) {
        console.error('Error saat mengambil produk by barcode:', error);
        res.status(500).json({ success: false, message: `Terjadi kesalahan pada server: ${error.message}` });
    }
});

// Endpoint Update Alergi User
app.put('/api/profile/allergies', authenticateToken, async (req, res) => {
    try {
        const { allergies } = req.body; // Expect array: ["kacang", "udang"]
        const userId = req.user.user.id;

        await db.query('UPDATE users SET allergies = ? WHERE user_id = ?', [JSON.stringify(allergies), userId]);
        res.json({ success: true, message: 'Data alergi berhasil diupdate' });
    } catch (error) {
        console.error('Update allergies error:', error);
        res.status(500).json({ success: false, message: 'Gagal update alergi' });
    }
});

app.post('/api/register', async (req, res) => {
    try {
        const { nama, email, password } = req.body; // Changed username to nama
        if (!nama || !email || !password) {
            return res.status(400).json({ success: false, message: 'Input tidak boleh kosong' });
        }
        const [existingUsers] = await db.query('SELECT email, nama FROM users WHERE email = ?', [email]); // Removed OR username check for simplicity/correctness
        if (existingUsers.length > 0) {
            return res.status(400).json({ success: false, message: 'Email sudah terdaftar' });
        }
        const hashedPassword = await bcrypt.hash(password, 10);
        await db.query('INSERT INTO users (nama, email, password, role) VALUES (?, ?, ?, ?)', [nama, email, hashedPassword, 'user']); // Added role default
        res.status(201).json({ success: true, message: 'Registrasi berhasil' });
    } catch (error) {
        console.error('Register error:', error);
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
        // Fix: Use correct column names (user_id, nama)
        const payload = { user: { id: user.user_id, email: user.email, nama: user.nama, role: user.role } };
        const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1d' });
        res.json({ success: true, message: 'Login berhasil', data: { token, user: payload.user } });
    } catch (error) {
        console.error('Login error:', error);
        res.status(500).json({ success: false, message: 'Kesalahan server saat login' });
    }
});


app.put('/api/profile', authenticateToken, async (req, res) => {
    try {
        const { nama } = req.body;
        const userId = req.user.user.id;

        if (!nama) {
            return res.status(400).json({ success: false, message: 'Nama tidak boleh kosong' });
        }

        await db.query('UPDATE users SET nama = ? WHERE user_id = ?', [nama, userId]);

        // Ambil data user terbaru
        const [users] = await db.query('SELECT user_id, email, nama FROM users WHERE user_id = ?', [userId]);
        const updatedUser = users[0];

        res.json({
            success: true,
            message: 'Profil berhasil diperbarui',
            data: {
                user: { id: updatedUser.user_id, email: updatedUser.email, nama: updatedUser.nama }
            }
        });
    } catch (error) {
        console.error('Update profile error:', error);
        res.status(500).json({ success: false, message: 'Gagal memperbarui profil' });
    }
});

app.put('/api/profile/password', authenticateToken, async (req, res) => {
    try {
        const { oldPassword, newPassword } = req.body;
        const userId = req.user.user.id;

        if (!oldPassword || !newPassword) {
            return res.status(400).json({ success: false, message: 'Password lama dan baru harus diisi' });
        }

        // Ambil password lama dari DB
        const [users] = await db.query('SELECT password FROM users WHERE user_id = ?', [userId]);
        const user = users[0];

        const isMatch = await bcrypt.compare(oldPassword, user.password);
        if (!isMatch) {
            return res.status(400).json({ success: false, message: 'Password lama salah' });
        }

        const hashedPassword = await bcrypt.hash(newPassword, 10);
        await db.query('UPDATE users SET password = ? WHERE user_id = ?', [hashedPassword, userId]);

        res.json({ success: true, message: 'Password berhasil diubah' });
    } catch (error) {
        console.error('Change password error:', error);
        res.status(500).json({ success: false, message: 'Gagal mengubah password' });
    }
});

// --- FAVORITES ENDPOINTS ---

// Add to favorites
app.post('/api/favorites', authenticateToken, async (req, res) => {
    try {
        const { barcodeId } = req.body;
        const userId = req.user.user.id;

        if (!barcodeId) {
            return res.status(400).json({ success: false, message: 'Barcode ID diperlukan' });
        }

        // Check if already exists
        const [existing] = await db.query(
            'SELECT id_favorite FROM favorite WHERE user_id = ? AND barcode_id = ?',
            [userId, barcodeId]
        );

        if (existing.length > 0) {
            return res.status(400).json({ success: false, message: 'Produk sudah ada di favorit' });
        }

        await db.query(
            'INSERT INTO favorite (user_id, barcode_id, tanggal_disimpan) VALUES (?, ?, NOW())',
            [userId, barcodeId]
        );

        res.json({ success: true, message: 'Berhasil ditambahkan ke favorit' });
    } catch (error) {
        console.error('Add favorite error:', error);
        res.status(500).json({ success: false, message: 'Gagal menambahkan favorit' });
    }
});

// Remove from favorites
app.delete('/api/favorites/:barcode', authenticateToken, async (req, res) => {
    try {
        const { barcode } = req.params;
        const userId = req.user.user.id;

        await db.query(
            'DELETE FROM favorite WHERE user_id = ? AND barcode_id = ?',
            [userId, barcode]
        );

        res.json({ success: true, message: 'Berhasil dihapus dari favorit' });
    } catch (error) {
        console.error('Remove favorite error:', error);
        res.status(500).json({ success: false, message: 'Gagal menghapus favorit' });
    }
});

// Get all favorites
app.get('/api/favorites', authenticateToken, async (req, res) => {
    try {
        const userId = req.user.user.id;

        // Join with produk and komposisi_gizi to get full details
        const query = `
            SELECT 
                p.nama_produk AS product_name,
                p.image_product_link AS gambarUrl,
                p.barcode_url AS barcodeUrl,
                p.barcode_id,
                cg.total_calories AS energi,
                cg.total_fat AS lemak,
                cg.protein AS protein,
                cg.total_carbohydrates AS karbohidrat,
                cg.total_sugar AS gula,
                cg.saturated_fat AS lemak_jenuh
            FROM favorite f
            JOIN produk p ON f.barcode_id = p.barcode_id
            LEFT JOIN komposisi_gizi cg ON p.barcode_id = cg.barcode_id
            WHERE f.user_id = ?
            ORDER BY f.tanggal_disimpan DESC
        `;

        const [rows] = await db.query(query, [userId]);
        res.json({ success: true, data: rows });
    } catch (error) {
        console.error('Get favorites error:', error);
        res.status(500).json({ success: false, message: 'Gagal mengambil data favorit' });
    }
});

// Check if favorite
app.get('/api/favorites/check/:barcode', authenticateToken, async (req, res) => {
    try {
        const { barcode } = req.params;
        const userId = req.user.user.id;

        const [rows] = await db.query(
            'SELECT id_favorite FROM favorite WHERE user_id = ? AND barcode_id = ?',
            [userId, barcode]
        );

        res.json({ success: true, isFavorite: rows.length > 0 });
    } catch (error) {
        console.error('Check favorite error:', error);
        res.status(500).json({ success: false, message: 'Gagal mengecek status favorit' });
    }
});

// --- HISTORY ENDPOINTS ---

// Add to history
app.post('/api/history', authenticateToken, async (req, res) => {
    try {
        const { query, type } = req.body;
        const userId = req.user.user.id;

        if (!query) {
            return res.status(400).json({ success: false, message: 'Query diperlukan' });
        }

        // Remove duplicate if exists (to move it to top)
        await db.query(
            'DELETE FROM history WHERE user_id = ? AND query = ? AND type = ?',
            [userId, query, type || 'search']
        );

        // Insert new
        await db.query(
            'INSERT INTO history (user_id, query, type, timestamp) VALUES (?, ?, ?, NOW())',
            [userId, query, type || 'search']
        );

        // Limit history to 100 items per user
        // (Optional: Implement cleanup job or trigger, but for now simple insert is fine)

        res.json({ success: true, message: 'Riwayat disimpan' });
    } catch (error) {
        console.error('Add history error:', error);
        res.status(500).json({ success: false, message: 'Gagal menyimpan riwayat' });
    }
});

// Get history
app.get('/api/history', authenticateToken, async (req, res) => {
    try {
        const userId = req.user.user.id;

        const [rows] = await db.query(
            'SELECT id_history, query, type, timestamp FROM history WHERE user_id = ? ORDER BY timestamp DESC LIMIT 100',
            [userId]
        );

        res.json({ success: true, data: rows });
    } catch (error) {
        console.error('Get history error:', error);
        res.status(500).json({ success: false, message: 'Gagal mengambil riwayat' });
    }
});

// Delete specific history
app.delete('/api/history/:id', authenticateToken, async (req, res) => {
    try {
        const { id } = req.params;
        const userId = req.user.user.id;

        await db.query(
            'DELETE FROM history WHERE id_history = ? AND user_id = ?',
            [id, userId]
        );

        res.json({ success: true, message: 'Riwayat dihapus' });
    } catch (error) {
        console.error('Delete history error:', error);
        res.status(500).json({ success: false, message: 'Gagal menghapus riwayat' });
    }
});

// Clear all history
app.delete('/api/history', authenticateToken, async (req, res) => {
    try {
        const userId = req.user.user.id;

        await db.query('DELETE FROM history WHERE user_id = ?', [userId]);

        res.json({ success: true, message: 'Semua riwayat dihapus' });
    } catch (error) {
        console.error('Clear history error:', error);
        res.status(500).json({ success: false, message: 'Gagal menghapus semua riwayat' });
    }
});

app.get('/api/image-proxy', async (req, res) => {
    const { url } = req.query;
    if (!url) {
        return res.status(400).send('URL parameter is required');
    }

    try {
        const response = await fetch(url);
        if (!response.ok) {
            return res.status(response.status).send('Failed to fetch image');
        }

        const contentType = response.headers.get('content-type');
        if (contentType) {
            res.setHeader('Content-Type', contentType);
        }

        const arrayBuffer = await response.arrayBuffer();
        const buffer = Buffer.from(arrayBuffer);
        res.send(buffer);
    } catch (error) {
        console.error('Image proxy error:', error);
        res.status(500).send('Error fetching image');
    }
});


// --- ADMIN ENDPOINTS ---

// Get All Users
app.get('/api/admin/users', authenticateAdmin, async (req, res) => {
    try {
        const [rows] = await db.query('SELECT user_id, nama, email, role, created_at FROM users ORDER BY created_at DESC');
        res.json({ success: true, data: rows });
    } catch (error) {
        console.error('Get users error:', error);
        res.status(500).json({ success: false, message: 'Gagal mengambil data user' });
    }
});

// Delete User
app.delete('/api/admin/users/:id', authenticateAdmin, async (req, res) => {
    try {
        const { id } = req.params;
        // Jangan biarkan admin menghapus dirinya sendiri
        if (parseInt(id) === req.user.user.id) {
            return res.status(400).json({ success: false, message: 'Tidak bisa menghapus akun sendiri' });
        }

        await db.query('DELETE FROM users WHERE user_id = ?', [id]);
        res.json({ success: true, message: 'User berhasil dihapus' });
    } catch (error) {
        console.error('Delete user error:', error);
        res.status(500).json({ success: false, message: 'Gagal menghapus user' });
    }
});

// Get Dashboard Stats
app.get('/api/admin/stats', authenticateAdmin, async (req, res) => {
    try {
        const [userCount] = await db.query('SELECT COUNT(*) as total FROM users');
        const [productCount] = await db.query('SELECT COUNT(*) as total FROM produk');
        const [scanCount] = await db.query('SELECT COUNT(*) as total FROM history'); // Asumsi history = scan activity

        res.json({
            success: true,
            data: {
                totalUsers: userCount[0].total,
                totalProducts: productCount[0].total,
                totalScans: scanCount[0].total
            }
        });
    } catch (error) {
        console.error('Get stats error:', error);
        res.status(500).json({ success: false, message: 'Gagal mengambil statistik' });
    }
});

app.listen(port, () => {
    console.log(`Server API berjalan di http://localhost:${port}`);
});
