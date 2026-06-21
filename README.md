# Universal Android Debloater

Tool GUI untuk men-disable (menonaktifkan) aplikasi bawaan/bloatware di HP Android tanpa root, menggunakan ADB (Android Debug Bridge).

## Fitur

- **Deteksi otomatis** merk & tipe HP (Xiaomi, Samsung, Oppo, Vivo, Realme, Huawei, dll)
- **Scan semua package** - menampilkan seluruh aplikasi (system + third-party)
- **Status real-time** - setiap aplikasi ditandai `[ENABLED]` atau `[DISABLED]`
- **Bloatware detection** - otomatis mendeteksi bloatware berdasarkan merk HP dan pola umum (Google, Meta, Microsoft, dll)
- **Critical system protection** - aplikasi sistem kritis (Phone, Settings, dll) otomatis terkunci
- **Filter** berdasarkan kategori: Bloatware, Aplikasi, System, Google, Critical
- **Klik kanan** pada item untuk disable/enable individual
- **Proses batch** - disable/enable banyak aplikasi sekaligus

## Persyaratan

1. **HP Android** dengan USB Debugging aktif
2. **Kabel USB data** (bukan kabel charger doang)
3. **ADB (Platform Tools)** terinstall di PC

## Cara Install ADB

Buka PowerShell/CMD sebagai Administrator:

```powershell
winget install Google.PlatformTools
```

Atau download manual dari: https://developer.android.com/studio/releases/platform-tools

## Cara Setup HP

1. Buka **Settings** > **About Phone**
2. Tap **MIUI Version / OS Version** sebanyak 7x (muncul notifikasi "You are now a developer")
3. Kembali ke Settings > **Additional Settings** > **Developer Options**
4. Aktifkan **USB Debugging**
5. Colok HP ke PC via kabel USB
6. Pada notifikasi USB di HP, pilih mode **File Transfer / MTP**
7. Di HP akan muncul popup "Allow USB debugging?" - centang **Always allow from this computer** > **OK**

Verifikasi koneksi di PowerShell:

```powershell
adb devices
```

Output harus menampilkan:
```
List of devices attached
abcdef123456    device
```

## Cara Pakai

### Via EXE (double-click)

1. Colok HP dengan USB Debugging aktif
2. Double-click **`AndroidDebloater.exe`**
3. Tool otomatis scan HP dan menampilkan semua aplikasi
4. **Centang** aplikasi yang ingin di-disable (bloatware otomatis tercentang)
5. Klik tombol **"DISABLE CENTANGAN"**
6. Konfirmasi, lalu tunggu proses selesai

### Via PowerShell

```powershell
powershell -ExecutionPolicy Bypass -File "unified-debloater.ps1"
```

### Membangun EXE sendiri (jika diedit)

```powershell
powershell -ExecutionPolicy Bypass -File "build-exe.ps1"
```

## Panduan Warna & Status

| Tampilan | Arti |
|----------|------|
| `[!] [ENABLED]` (merah, tercentang) | Bloatware terdeteksi, siap di-disable |
| `[!] [DISABLED]` (abu-abu) | Bloatware sudah di-disable |
| `[ENABLED]` (hijau) | Aplikasi normal, tidak dicentang |
| `[DISABLED]` (abu-abu) | Aplikasi sudah dinonaktifkan |
| `[SYS] [ENABLED]` (abu-abu, terkunci) | System critical, tidak bisa di-disable |

## Filter

| Tombol | Fungsi |
|--------|--------|
| Semua | Menampilkan semua aplikasi |
| Bloatware | Hanya bloatware terdeteksi |
| Aplikasi | Hanya third-party apps (bukan system) |
| System | Hanya aplikasi system (non-critical) |
| Google | Hanya aplikasi Google |
| Critical | Hanya system critical (terlindung) |

## Cara Mengembalikan (Enable Kembali)

### Via Tool
1. Buka tool, klik tombol **Refresh**
2. Aplikasi yang sudah di-disable akan muncul dengan label `[DISABLED]`
3. **Hapus centang** untuk meng-enable kembali
4. Klik **"DISABLE CENTANGAN"**

### Via ADB Manual

```powershell
adb shell pm enable <nama.package>
```

Cari nama package yang sudah di-disable:

```powershell
adb shell pm list packages --disabled
```

## Troubleshooting

| Masalah | Solusi |
|---------|--------|
| "No device detected" | USB Debugging belum aktif, atau kabel USB bukan kabel data |
| Tidak muncul popup authorization | Cabut & colok USB lagi, atau revoke USB debugging di Developer Options |
| Ada package yang tidak muncul | Tool hanya menampilkan aplikasi (third-party + system non-critical) |
| "Failure" saat disable | Beberapa aplikasi system tidak bisa di-disable tanpa root |
| Antivirus mendeteksi EXE sebagai virus | False-positive dari ps2exe. Tambahkan exception atau jalankan via PowerShell saja |

## Peringatan

- Tool ini **tidak menghapus** (uninstall) aplikasi, hanya menonaktifkan (disable)
- Semua aplikasi bisa dikembalikan (enable) kapan saja
- Jangan menonaktifkan aplikasi system critical seperti `com.android.phone`, `com.android.settings`, dll (sudah otomatis terkunci)
- Disarankan hanya menonaktifkan aplikasi yang benar-benar tidak diperlukan

## File

| File | Deskripsi |
|------|-----------|
| `AndroidDebloater.exe` | Aplikasi GUI (double-click) |
| `unified-debloater.ps1` | Script PowerShell utama |
| `build-exe.ps1` | Builder untuk membuat EXE dari script |
| `debloat-tool.ps1` | Versi awal GUI (Redmi-specific) |
| `disable-bloatware-redmi.ps1` | Script CLI khusus Redmi |
| `README.md` | Dokumentasi ini |
