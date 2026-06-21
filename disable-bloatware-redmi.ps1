# Redmi 15C Bloatware Disabler
# Jalankan setelah ADB terinstall dan HP terhubung via USB debugging

$packages = @(
    # MIUI / HyperOS bloatware
    "com.miui.analytics"
    "com.miui.bugreport"
    "com.miui.miservice"
    "com.miui.micloudsync"
    "com.miui.notes"
    "com.miui.player"
    "com.miui.video"
    "com.miui.gallery"
    "com.miui.compass"
    "com.miui.calculator"
    "com.miui.screenrecorder"
    "com.miui.weather2"
    "com.miui.yellowpage"
    "com.miui.msa.global"
    "com.miui.daemon"
    "com.miui.securityadd"
    "com.miui.cleanmaster"
    "com.miui.voiceassist"
    "com.miui.miwallpaper"
    "com.miui.hybrid"
    "com.miui.hybrid.accessory"
    "com.miui.fm"
    "com.miui.misound"
    "com.miui.systemAdSolution"
    "com.miui.videoplayer"
    "com.miui.notes"
    "com.miui.personalassistant"
    "com.miui.touchassistant"
    "com.miui.phrase"
    "com.miui.miinput"
    "com.miui.miwallpaper.earth"
    "com.miui.miwallpaper.mars"

    # Xiaomi apps
    "com.xiaomi.glgm"
    "com.xiaomi.mipicks"
    "com.xiaomi.payment"
    "com.xiaomi.midrop"
    "com.xiaomi.powerchecker"
    "com.xiaomi.simactivate.service"
    "com.xiaomi.mi_connect_service"
    "com.xiaomi.xmsf"
    "com.xiaomi.finddevice"

    # Google bloatware (optional)
    "com.google.android.apps.maps"
    "com.google.android.apps.photos"
    "com.google.android.apps.messaging"
    "com.google.android.apps.tachyon"
    "com.google.android.apps.docs"
    "com.google.android.apps.sheets"
    "com.google.android.apps.slides"
    "com.google.android.gm"
    "com.google.android.youtube"
    "com.google.android.videos"
    "com.google.android.music"
    "com.google.android.printservice.recommendation"
    "com.google.android.feedback"
    "com.google.android.partnersetup"
    "com.google.android.onetimeinitializer"

    # Facebook / Meta
    "com.facebook.katana"
    "com.facebook.orca"
    "com.facebook.lite"
    "com.facebook.system"
    "com.facebook.appmanager"
    "com.facebook.services"
    "com.whatsapp"

    # Game & tools
    "com.tencent.sogou"
    "com.mfashiongallery.emag"
    "com.opera.mini.native"
    "com.uc.browser.en"
    "com.swiftkey.languageprovider"
    "com.touchtype.swiftkey"
)

Write-Host "Menyambungkan ke perangkat..." -ForegroundColor Cyan
$device = adb devices | Where-Object {$_ -match "device$"}
if (-not $device) {
    Write-Host "Tidak ada perangkat terdeteksi. Pastikan USB debugging aktif." -ForegroundColor Red
    exit 1
}

Write-Host "Memulai disable bloatware..." -ForegroundColor Yellow
$count = 0
foreach ($pkg in $packages) {
    $result = adb shell pm disable-user --user 0 $pkg 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[OK] Disabled: $pkg" -ForegroundColor Green
        $count++
    } else {
        Write-Host "[--] Skipped: $pkg ($result)" -ForegroundColor Gray
    }
}

Write-Host "Selesai! $count package berhasil di-disable." -ForegroundColor Cyan
Write-Host "Catatan: Untuk mengembalikan, jalankan: adb shell pm enable <package-name>" -ForegroundColor Yellow
