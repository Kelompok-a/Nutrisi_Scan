# NutriScan

NutriScan adalah aplikasi asisten kesehatan pribadi yang membantu pengguna mengetahui kadar gula dan informasi nutrisi pada produk makanan dan minuman kemasan secara cepat dan akurat. Dengan teknologi pemindaian barcode, NutriScan bertujuan meningkatkan kesadaran konsumen akan pola hidup sehat.

## Fitur Utama

*   **Scan Barcode Instan**: Identifikasi produk dan informasi nutrisinya dalam hitungan detik menggunakan kamera.
*   **Pencarian Manual**: Cari produk berdasarkan nama atau barcode jika pemindaian tidak memungkinkan.
*   **Analisis Nutrisi (Traffic Light)**: Indikator visual (Merah/Kuning/Hijau) untuk kadar Gula, Lemak, dan Kalori agar mudah dipahami.
*   **Riwayat & Favorit**: Simpan produk favorit dan akses riwayat pemindaian Anda kapan saja.
*   **Manajemen Pengguna**: Sistem login, register, dan profil pengguna.
*   **Admin Dashboard**: Panel admin (Web/Desktop) untuk manajemen pengguna dan melihat statistik aplikasi.
*   **Responsif**: Tampilan yang menyesuaikan dengan berbagai ukuran layar (Mobile & Web/Desktop).

## Teknologi yang Digunakan

Aplikasi ini dibangun menggunakan teknologi modern untuk memastikan performa dan skalabilitas:

### Frontend
*   **Framework**: [Flutter](https://flutter.dev/) (Dart)
*   **State Management**: Provider
*   **Fitur**: Mobile Scanner, Google Fonts, Responsive Layout

### Backend
*   **Runtime**: [Node.js](https://nodejs.org/)
*   **Framework**: Express.js
*   **Authentication**: JWT (JSON Web Tokens) & Bcrypt

### Database
*   **Database**: MySQL (TiDB Cloud)
*   **Hosting**: Cloud-based relational database

## Panduan Instalasi & Menjalankan Aplikasi

Ikuti langkah-langkah berikut untuk menjalankan proyek ini di komputer lokal Anda.

### Prasyarat
Pastikan Anda telah menginstal:
*   [Flutter SDK](https://docs.flutter.dev/get-started/install)
*   [Node.js](https://nodejs.org/) (termasuk npm)
*   Git

### 1. Clone Repository
```bash
git clone https://github.com/username/Nutrisi_Scan.git
cd Nutrisi_Scan
```

### 2. Menjalankan Backend (Server)
Backend diperlukan untuk koneksi database dan API.

1.  Buka terminal baru.
2.  Masuk ke direktori root proyek (tempat `server.js` berada).
3.  Instal dependensi (jika belum):
    ```bash
    npm install
    ```
4.  Jalankan server:
    ```bash
    node server.js
    ```
    *Server akan berjalan di `http://localhost:3001`*

### 3. Menjalankan Frontend (Aplikasi Flutter)
1.  Buka terminal baru (biarkan terminal backend tetap berjalan).
2.  Pastikan dependensi Flutter terinstal:
    ```bash
    flutter pub get
    ```
3.  Jalankan aplikasi:
    ```bash
    flutter run
    ```
    *   Pilih device target (Chrome untuk Web, atau Emulator/Device Fisik untuk Mobile).

## Tim Pengembang

Aplikasi ini dikembangkan oleh **Kelompok 2** dengan anggota sebagai berikut:

| Nama | NIM | Role | Tugas Utama |
| :--- | :--- | :--- | :--- |
| **Sukma Dwi Pangesti** | 24111814120 | Leader | Database |
| **Oktavia Rahma Widjianti** | 24111814075 | Anggota 2 | Manajemen Data |
| **Rizma Indra Pramudya** | 24111814117 | Anggota 3 | Fullstack Developer |
| **Putera Al Khalidi** | 24111814077 | Anggota 4 | Frontend Developer |

---
© 2025 NutriScan.id
