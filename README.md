# Studi Kasus Deployment Laravel Docker

> 📚 **Ingin belajar lebih dalam tentang Laravel Best Practices?**  
> Dapatkan ebook lengkap dengan panduan deployment, testing, security, dan banyak lagi!  
> **[👉 Beli Ebook Laravel Best Practice Sekarang](https://codingtengahmalam.myr.id/ebook/laravel-best-practice)**

---

Repository ini berisi aplikasi contoh untuk bab **Deployment** dari ebook _Laravel Best Practice_. Cocok buat kamu yang mau belajar cara deploy aplikasi Laravel 12 + Livewire dengan Docker, atau sekadar ingin menjalankan project ini di lokal.

## Tentang Project

Project ini menggunakan:
- **Laravel 12** sebagai backend framework
- **Livewire/Volt** untuk komponen interaktif
- **Fortify** untuk autentikasi (login, register, 2FA, dll)
- **Vite + Tailwind CSS** untuk frontend tooling
- **Docker Compose** untuk containerization (opsional)

## Prasyarat

### Untuk Instalasi Biasa (Tanpa Docker)
- PHP >= 8.2
- Composer
- Node.js >= 18 dan npm
- Database (MySQL/PostgreSQL/SQLite)
- Redis (opsional, untuk queue dan cache)

### Untuk Instalasi dengan Docker
- Docker Desktop atau Docker Engine
- Docker Compose

## Cara Instalasi

Kamu bisa pilih salah satu cara instalasi di bawah ini, sesuai kebutuhan kamu.

### Opsi 1: Instalasi Biasa (Tanpa Docker)

Cara ini cocok kalau kamu sudah punya PHP, Composer, dan database yang terinstall di sistem kamu.

#### Langkah 1: Clone Repository
```bash
git clone <repository-url>
cd laravel-docker
```

#### Langkah 2: Install Dependencies
```bash
# Install PHP dependencies
composer install

# Install Node.js dependencies
npm install
```

#### Langkah 3: Setup Environment
```bash
# Copy file .env
cp .env.example .env

# Generate application key
php artisan key:generate
```

#### Langkah 4: Konfigurasi Database
Edit file `.env` dan sesuaikan konfigurasi database kamu:
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=nama_database
DB_USERNAME=username
DB_PASSWORD=password
```

#### Langkah 5: Jalankan Migrasi
```bash
php artisan migrate
```

#### Langkah 6: Build Assets
```bash
npm run build
```

#### Langkah 7: Jalankan Development Server
```bash
# Opsi 1: Menggunakan script composer (recommended)
# Script ini akan menjalankan server, queue worker, logs, dan Vite sekaligus
composer dev

# Opsi 2: Manual (jalankan di terminal terpisah)
php artisan serve          # Terminal 1
php artisan queue:listen   # Terminal 2
npm run dev                # Terminal 3
```

Aplikasi akan berjalan di `http://localhost:8000`

### Opsi 2: Instalasi dengan Docker

Cara ini lebih mudah karena semua dependency sudah dikemas dalam container. Cocok buat kamu yang belum install PHP atau database di sistem lokal.

#### Langkah 1: Clone Repository
```bash
git clone <repository-url>
cd laravel-docker
```

#### Langkah 2: Setup Environment
```bash
# Copy file .env
cp .env.example .env

# Edit file .env dan sesuaikan konfigurasi database untuk Docker
# Biasanya menggunakan service name dari docker-compose.yml
```

#### Langkah 3: Build dan Jalankan Container
```bash
# Build dan jalankan semua service
docker compose up -d

# Lihat logs untuk memastikan semua service berjalan
docker compose logs -f
```

#### Langkah 4: Install Dependencies (di dalam container)
```bash
# Install PHP dependencies
docker compose exec app composer install

# Install Node.js dependencies
docker compose exec app npm install
```

#### Langkah 5: Setup Laravel
```bash
# Generate application key
docker compose exec app php artisan key:generate

# Jalankan migrasi
docker compose exec app php artisan migrate

# Build assets
docker compose exec app npm run build
```

#### Langkah 6: Akses Aplikasi
Aplikasi akan berjalan di `http://localhost:8081`

#### Perintah Docker yang Berguna
```bash
# Stop semua container
docker compose down

# Stop dan hapus volume (data akan hilang)
docker compose down -v

# Masuk ke container app
docker compose exec app bash

# Lihat logs
docker compose logs -f app

# Rebuild container setelah perubahan Dockerfile
docker compose up -d --build
```

## Script Composer yang Tersedia

Project ini sudah dilengkapi dengan beberapa script composer yang memudahkan development:

- `composer setup` - Setup lengkap: install dependencies, generate key, migrate, dan build assets
- `composer dev` - Jalankan development server dengan semua service (server, queue, logs, vite)
- `composer test` - Jalankan test suite

## Troubleshooting

### Masalah dengan Permission
```bash
# Set permission untuk storage dan bootstrap/cache
chmod -R 775 storage bootstrap/cache
```

### Masalah dengan Queue Worker
Pastikan Redis sudah berjalan atau sesuaikan konfigurasi queue di `.env`:
```env
QUEUE_CONNECTION=redis
REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379
```

### Masalah dengan Docker
- Pastikan Docker Desktop sudah berjalan
- Cek port yang digunakan tidak bentrok (8081, 4433)
- Coba rebuild container: `docker compose up -d --build`

## Sumber Daya

📖 **Ebook Laravel Best Practice**  
Untuk panduan lebih lengkap tentang deployment, testing, security, performance optimization, dan best practices lainnya, dapatkan ebook lengkapnya:

**[👉 Beli Ebook Laravel Best Practice](https://codingtengahmalam.myr.id/ebook/laravel-best-practice)**

Bab Deployment di ebook merujuk repository ini untuk demonstrasi dan latihan langsung. Dengan membeli ebook, kamu akan mendapatkan:
- Panduan lengkap deployment dengan berbagai metode
- Best practices untuk testing dan security
- Tips optimasi performance
- Dan masih banyak lagi!
