# Panduan Deployment NutriScan (3 Metode)

Dokumen ini berisi panduan lengkap untuk men-deploy aplikasi NutriScan menggunakan 3 platform berbeda: **Vercel**, **Render**, dan **Netlify**. Anda bisa memilih salah satu atau mengombinasikannya.

---

## 📂 Persiapan Awal (Wajib)

Sebelum mulai, pastikan Anda memiliki:
1.  **Source Code:** Folder project `Nutrisi_Scan` (bisa via ZIP atau Clone dari GitHub).
2.  **Akun GitHub:** Untuk menyimpan kode secara online.
3.  **Akun Platform:** Daftar di [vercel.com](https://vercel.com), [render.com](https://render.com), dan [netlify.com](https://netlify.com).

---

## 1️⃣ Metode 1: Vercel (All-in-One)
**Cocok untuk:** Backend (Node.js) DAN Frontend (Flutter). Paling praktis.

### A. Deploy Backend ke Vercel
1.  **Push Kode ke GitHub:** Pastikan kode backend (`server.js`, `package.json`, `vercel.json`) sudah ada di repository GitHub Anda.
2.  **Buka Dashboard Vercel:** Klik **Add New...** -> **Project**.
3.  **Import Repository:** Pilih repo `Nutrisi_Scan` Anda.
4.  **Konfigurasi Project:**
    *   **Framework Preset:** Pilih **Other**.
    *   **Root Directory:** `.` (Default).
    *   **Build Command:** (Kosongkan/Default).
    *   **Output Directory:** (Kosongkan/Default).
    *   **Environment Variables:** Masukkan kredensial DB jika tidak di-hardcode di `server.js`.
5.  **Deploy:** Klik tombol **Deploy**.
6.  **Hasil:** Salin URL yang diberikan (misal: `https://nutriscan-backend.vercel.app`).

### B. Deploy Frontend ke Vercel
1.  **Update URL API:**
    *   Buka file `lib/services/api_service.dart`.
    *   Ubah `_productionUrl` menjadi URL Backend Vercel tadi.
    *   Set `isProduction = true`.
    *   Push perubahan ini ke GitHub.
2.  **Buka Dashboard Vercel:** Buat Project Baru (**Add New...** -> **Project**).
3.  **Import Repository:** Pilih repo yang sama.
4.  **Konfigurasi Project (PENTING):**
    *   **Framework Preset:** Pilih **Flutter** (jika ada) atau **Other**.
    *   **Build Command:** `flutter build web --release --no-tree-shake-icons`
    *   **Output Directory:** `build/web`
5.  **Deploy:** Klik tombol **Deploy**.
6.  **Troubleshooting 404:** Jika di-refresh error, pastikan ada file `vercel.json` di folder `build/web` dengan isi:
    ```json
    { "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }] }
    ```

---

## 2️⃣ Metode 2: GitHub + Render
**Cocok untuk:** Backend (Node.js). Lebih stabil untuk server yang butuh koneksi database terus-menerus.

### A. Persiapan Repository
1.  Pastikan repository GitHub Anda **Public** (jika akun GitHub Anda bermasalah/shadowbanned) atau **Private** (jika akun normal).
2.  Pastikan `server.js` menggunakan port dinamis: `const PORT = process.env.PORT || 3001;`.

### B. Deploy di Render
1.  Buka [dashboard.render.com](https://dashboard.render.com).
2.  Klik **New +** -> **Web Service**.
3.  **Connect Repository:**
    *   Jika repo Public: Pilih tab **"Public Git Repository"** -> Paste URL GitHub.
    *   Jika repo Private: Connect akun GitHub dan pilih repo dari daftar.
4.  **Konfigurasi:**
    *   **Name:** `nutriscan-backend`
    *   **Region:** Singapore (rekomendasi).
    *   **Runtime:** `Node`.
    *   **Build Command:** `npm install`.
    *   **Start Command:** `node server.js`.
    *   **Plan:** Free.
5.  **Create Web Service:** Tunggu proses deploy selesai.
6.  **Hasil:** Salin URL (misal: `https://nutriscan.onrender.com`). Gunakan URL ini di `api_service.dart` Frontend.

---

## 3️⃣ Metode 3: Netlify (Manual Drag & Drop)
**Cocok untuk:** Frontend (Flutter). Solusi paling cepat jika GitHub/CLI bermasalah.

### A. Build Aplikasi Flutter
1.  Di komputer lokal, buka terminal di folder project.
2.  Jalankan perintah:
    ```bash
    flutter build web --release --no-tree-shake-icons
    ```
3.  Hasil build ada di folder: `build/web`.

### B. Konfigurasi Redirect (Wajib untuk Flutter)
1.  Buat file baru bernama `_redirects` (tanpa ekstensi) di dalam folder `build/web`.
2.  Isi file tersebut dengan satu baris ini:
    ```text
    /*  /index.html  200
    ```
    *(Ini agar website tidak error 404 saat di-refresh)*.

### C. Upload ke Netlify
1.  Buka [app.netlify.com/drop](https://app.netlify.com/drop).
2.  Buka File Explorer di komputer, cari folder `build`.
3.  **Tarik (Drag) folder `web`** dan lepaskan di halaman Netlify.
4.  Tunggu upload selesai. Website langsung online!

---

## 4️⃣ Metode 4: Replit (Manual Upload / Drag & Drop)
**Cocok untuk:** Backend (Node.js) jika Anda malas pakai Git/CLI.

1.  Buka [Replit.com](https://replit.com) dan login.
2.  Klik **Create Repl** -> Pilih template **Node.js**.
3.  Beri nama (misal: `NutriScan-Backend`) -> Klik **Create Repl**.
4.  **Upload File:**
    *   Di panel kiri (Files), hapus file default yang tidak perlu.
    *   **Drag & Drop** file `server.js` dan `package.json` dari komputer Anda ke panel Files tersebut.
5.  **Install & Run:**
    *   Klik tombol **Run** (hijau) di atas.
    *   Replit akan otomatis mendeteksi `package.json`, menjalankan `npm install`, lalu menjalankan server.
6.  **Hasil:**
    *   Jika berhasil, akan muncul jendela "Webview" kecil.
    *   Salin URL di atas Webview tersebut (misal: `https://NutriScan-Backend.username.repl.co`).
    *   Gunakan URL ini di `api_service.dart` Frontend.

---

## 5️⃣ Metode 5: Hugging Face Spaces (Manual Upload)
**Cocok untuk:** Backend & Frontend. Gratis dan mudah (mirip Google Drive).

### A. Deploy Backend (Node.js)
1.  Buka [huggingface.co/spaces](https://huggingface.co/spaces) -> **Create new Space**.
2.  **Nama:** `nutriscan-backend`.
3.  **SDK:** Pilih **Docker**.
4.  **Template:** Pilih **Blank**.
5.  Klik **Create Space**.
6.  **Upload File:**
    *   Scroll ke bawah, klik **Files**.
    *   Klik **Add file** -> **Upload files**.
    *   **Drag & Drop** 3 file ini dari komputer:
        1.  `server.js`
        2.  `package.json`
        3.  `Dockerfile` (File baru yang saya buatkan di folder project).
    *   Klik **Commit changes to main**.
7.  **Hasil:**
    *   Tunggu status "Building" jadi "Running".
    *   Klik tombol menu (tiga titik) di kanan atas -> **Embed this space**.
    *   Salin **Direct URL** (misal: `https://username-nutriscan-backend.hf.space`).
    *   Gunakan URL ini di `api_service.dart`.

### B. Deploy Frontend (Flutter)
1.  **PENTING: Sambungkan ke Backend Dulu!**
    *   Ambil URL Backend dari langkah A tadi.
    *   Buka `lib/services/api_service.dart` di komputer.
    *   Update `_productionUrl` dan set `isProduction = true`.
    *   **Build Ulang:** Jalankan `flutter build web --release --no-tree-shake-icons` di terminal.
2.  Buat Space baru lagi di Hugging Face.
3.  **Nama:** `nutriscan-web`.
4.  **SDK:** Pilih **Static**.
5.  **Upload File:**
    *   Masuk ke menu **Files**.
    *   **Drag & Drop** SEMUA isi dari folder `build/web` (yang baru di-build).
    *   Klik **Commit changes**.
6.  **Hasil:** Website langsung online!
