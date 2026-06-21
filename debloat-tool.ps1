Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$packages = @(
    @{Name="Analytics & Bugreport"; Pkg="com.miui.analytics"; Cat="MIUI"},
    @{Name="Bug Report"; Pkg="com.miui.bugreport"; Cat="MIUI"},
    @{Name="Mi Service"; Pkg="com.miui.miservice"; Cat="MIUI"},
    @{Name="Mi Cloud Sync"; Pkg="com.miui.micloudsync"; Cat="MIUI"},
    @{Name="Notes"; Pkg="com.miui.notes"; Cat="MIUI"},
    @{Name="Music Player"; Pkg="com.miui.player"; Cat="MIUI"},
    @{Name="Video"; Pkg="com.miui.video"; Cat="MIUI"},
    @{Name="Gallery"; Pkg="com.miui.gallery"; Cat="MIUI"},
    @{Name="Compass"; Pkg="com.miui.compass"; Cat="MIUI"},
    @{Name="Calculator"; Pkg="com.miui.calculator"; Cat="MIUI"},
    @{Name="Screen Recorder"; Pkg="com.miui.screenrecorder"; Cat="MIUI"},
    @{Name="Weather"; Pkg="com.miui.weather2"; Cat="MIUI"},
    @{Name="Yellow Page"; Pkg="com.miui.yellowpage"; Cat="MIUI"},
    @{Name="MSA (Ads)"; Pkg="com.miui.msa.global"; Cat="MIUI"},
    @{Name="Mi Daemon"; Pkg="com.miui.daemon"; Cat="MIUI"},
    @{Name="Security Add"; Pkg="com.miui.securityadd"; Cat="MIUI"},
    @{Name="Clean Master"; Pkg="com.miui.cleanmaster"; Cat="MIUI"},
    @{Name="Voice Assistant"; Pkg="com.miui.voiceassist"; Cat="MIUI"},
    @{Name="FM Radio"; Pkg="com.miui.fm"; Cat="MIUI"},
    @{Name="System Ad Solution"; Pkg="com.miui.systemAdSolution"; Cat="MIUI"},
    @{Name="Personal Assistant"; Pkg="com.miui.personalassistant"; Cat="MIUI"},
    @{Name="Touch Assistant"; Pkg="com.miui.touchassistant"; Cat="MIUI"},
    @{Name="Mi Picks"; Pkg="com.xiaomi.mipicks"; Cat="Xiaomi"},
    @{Name="Mi Drop"; Pkg="com.xiaomi.midrop"; Cat="Xiaomi"},
    @{Name="Payment"; Pkg="com.xiaomi.payment"; Cat="Xiaomi"},
    @{Name="Game Center"; Pkg="com.xiaomi.glgm"; Cat="Xiaomi"},
    @{Name="Maps"; Pkg="com.google.android.apps.maps"; Cat="Google"},
    @{Name="YouTube"; Pkg="com.google.android.youtube"; Cat="Google"},
    @{Name="Gmail"; Pkg="com.google.android.gm"; Cat="Google"},
    @{Name="Google Photos"; Pkg="com.google.android.apps.photos"; Cat="Google"},
    @{Name="Google Docs"; Pkg="com.google.android.apps.docs"; Cat="Google"},
    @{Name="Google Sheets"; Pkg="com.google.android.apps.sheets"; Cat="Google"},
    @{Name="Google Slides"; Pkg="com.google.android.apps.slides"; Cat="Google"},
    @{Name="Google Movies"; Pkg="com.google.android.videos"; Cat="Google"},
    @{Name="Google Music"; Pkg="com.google.android.music"; Cat="Google"},
    @{Name="Google Duo"; Pkg="com.google.android.apps.tachyon"; Cat="Google"},
    @{Name="Messaging"; Pkg="com.google.android.apps.messaging"; Cat="Google"},
    @{Name="Facebook"; Pkg="com.facebook.katana"; Cat="Meta"},
    @{Name="Messenger"; Pkg="com.facebook.orca"; Cat="Meta"},
    @{Name="Facebook Lite"; Pkg="com.facebook.lite"; Cat="Meta"},
    @{Name="WhatsApp"; Pkg="com.whatsapp"; Cat="Meta"},
    @{Name="Opera Mini"; Pkg="com.opera.mini.native"; Cat="Lain"},
    @{Name="UC Browser"; Pkg="com.uc.browser.en"; Cat="Lain"},
    @{Name="SwiftKey"; Pkg="com.touchtype.swiftkey"; Cat="Lain"}
)

$form = New-Object System.Windows.Forms.Form
$form.Text = "Redmi 15C - Bloatware Manager"
$form.Size = New-Object System.Drawing.Size(700, 600)
$form.StartPosition = "CenterScreen"
$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("powershell.exe")

$header = New-Object System.Windows.Forms.Label
$header.Text = "Pilih aplikasi yang ingin di DISABLE (centang) atau ENABLE (hapus centang)"
$header.Location = New-Object System.Drawing.Point(10, 10)
$header.Size = New-Object System.Drawing.Size(660, 30)
$header.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($header)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(10, 40)
$statusLabel.Size = New-Object System.Drawing.Size(660, 20)
$statusLabel.Text = "Status: Menunggu koneksi ADB..."
$statusLabel.ForeColor = "Gray"
$form.Controls.Add($statusLabel)

$panel = New-Object System.Windows.Forms.Panel
$panel.Location = New-Object System.Drawing.Point(10, 65)
$panel.Size = New-Object System.Drawing.Size(660, 420)
$panel.AutoScroll = $true
$form.Controls.Add($panel)

$checkboxes = @{}
$y = 5
$lastCat = ""
foreach ($pkg in $packages) {
    if ($pkg.Cat -ne $lastCat) {
        $catLabel = New-Object System.Windows.Forms.Label
        $catLabel.Text = "--- $($pkg.Cat) ---"
        $catLabel.Location = New-Object System.Drawing.Point(10, $y)
        $catLabel.Size = New-Object System.Drawing.Size(620, 22)
        $catLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
        $catLabel.ForeColor = "DodgerBlue"
        $panel.Controls.Add($catLabel)
        $y += 25
        $lastCat = $pkg.Cat
    }

    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = "$($pkg.Name)  ($($pkg.Pkg))"
    $cb.Location = New-Object System.Drawing.Point(25, $y)
    $cb.Size = New-Object System.Drawing.Size(610, 22)
    $cb.Checked = $true
    $cb.Tag = $pkg.Pkg
    $panel.Controls.Add($cb)
    $checkboxes[$pkg.Pkg] = $cb
    $y += 25
}

# Buttons
$btnY = 495

$selectAllBtn = New-Object System.Windows.Forms.Button
$selectAllBtn.Text = "Centang Semua"
$selectAllBtn.Location = New-Object System.Drawing.Point(10, $btnY)
$selectAllBtn.Size = New-Object System.Drawing.Size(120, 30)
$selectAllBtn.Add_Click({ $checkboxes.Values | ForEach-Object { $_.Checked = $true } })
$form.Controls.Add($selectAllBtn)

$unselectAllBtn = New-Object System.Windows.Forms.Button
$unselectAllBtn.Text = "Hapus Semua"
$unselectAllBtn.Location = New-Object System.Drawing.Point(140, $btnY)
$unselectAllBtn.Size = New-Object System.Drawing.Size(120, 30)
$unselectAllBtn.Add_Click({ $checkboxes.Values | ForEach-Object { $_.Checked = $false } })
$form.Controls.Add($unselectAllBtn)

$refreshBtn = New-Object System.Windows.Forms.Button
$refreshBtn.Text = "Refresh Status"
$refreshBtn.Location = New-Object System.Drawing.Point(270, $btnY)
$refreshBtn.Size = New-Object System.Drawing.Size(120, 30)
$refreshBtn.Add_Click({ Get-AppStatus })
$form.Controls.Add($refreshBtn)

$diagBtn = New-Object System.Windows.Forms.Button
$diagBtn.Text = "Diagnostik"
$diagBtn.Location = New-Object System.Drawing.Point(400, $btnY)
$diagBtn.Size = New-Object System.Drawing.Size(120, 30)
$diagBtn.Add_Click({ Show-Diagnostic })
$form.Controls.Add($diagBtn)

$runBtn = New-Object System.Windows.Forms.Button
$runBtn.Text = "JALANKAN"
$runBtn.Location = New-Object System.Drawing.Point(530, $btnY)
$runBtn.Size = New-Object System.Drawing.Size(140, 40)
$runBtn.BackColor = "DodgerBlue"
$runBtn.ForeColor = "White"
$runBtn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$runBtn.Add_Click({ Run-Action })
$form.Controls.Add($runBtn)

$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Location = New-Object System.Drawing.Point(10, 535)
$logBox.Size = New-Object System.Drawing.Size(660, 25)
$logBox.ReadOnly = $true
$logBox.BackColor = "Black"
$logBox.ForeColor = "Lime"
$form.Controls.Add($logBox)

function Get-AppStatus {
    $statusLabel.Text = "Status: Mengecek status package..."
    $statusLabel.ForeColor = "Blue"
    $logBox.Text = "Mohon tunggu..."
    [System.Windows.Forms.Application]::DoEvents()

    $device = adb devices 2>$null | Where-Object { $_ -match "device$" }
    if (-not $device) {
        $statusLabel.Text = "Status: TIDAK TERHUBUNG - Aktifkan USB Debugging"
        $statusLabel.ForeColor = "Red"
        $logBox.Text = "ERROR: Tidak ada perangkat terdeteksi"
        return
    }

    $count = 0
    foreach ($pkg in $packages) {
        $pkgName = $pkg.Pkg
        $result = adb shell pm list packages --disabled 2>$null | Where-Object { $_ -match [regex]::Escape($pkgName) }
        if ($result) {
            $checkboxes[$pkgName].Checked = $true
            $checkboxes[$pkgName].ForeColor = "Red"
        } else {
            $checkboxes[$pkgName].Checked = $false
            $checkboxes[$pkgName].ForeColor = "Green"
        }
        $count++
    }

    $statusLabel.Text = "Status: Terhubung - $count package terdeteksi (Centang = Disabled)"
    $statusLabel.ForeColor = "Green"
    $logBox.Text = "OK - Status package berhasil di-refresh"
}

function Run-Action {
    $device = adb devices 2>$null | Where-Object { $_ -match "device$" }
    if (-not $device) {
        $logBox.Text = "ERROR: Tidak ada perangkat. USB debugging aktif?"
        return
    }

    $runBtn.Enabled = $false
    $runBtn.Text = "PROSES..."

    $toDisable = @()
    $toEnable = @()

    # First get current state
    $disabledPkgs = adb shell pm list packages --disabled 2>$null

    foreach ($pkg in $packages) {
        $pkgName = $pkg.Pkg
        $isChecked = $checkboxes[$pkgName].Checked
        $isDisabled = $disabledPkgs -match [regex]::Escape($pkgName)

        if ($isChecked -and -not $isDisabled) {
            $toDisable += $pkgName
        } elseif (-not $isChecked -and $isDisabled) {
            $toEnable += $pkgName
        }
    }

    $total = $toDisable.Count + $toEnable.Count
    if ($total -eq 0) {
        $logBox.Text = "Tidak ada perubahan yang diperlukan."
        $runBtn.Enabled = $true
        $runBtn.Text = "JALANKAN"
        return
    }

    # Disable
    $ok = 0; $fail = 0
    foreach ($pkg in $toDisable) {
        $logBox.Text = "Disable: $pkg ..."
        [System.Windows.Forms.Application]::DoEvents()
        $r = adb shell pm disable-user --user 0 $pkg 2>&1
        if ($LASTEXITCODE -eq 0) { $ok++ } else { $fail++ }
    }

    # Enable
    foreach ($pkg in $toEnable) {
        $logBox.Text = "Enable: $pkg ..."
        [System.Windows.Forms.Application]::DoEvents()
        $r = adb shell pm enable $pkg 2>&1
        if ($LASTEXITCODE -eq 0) { $ok++ } else { $fail++ }
    }

    $logBox.Text = "Selesai! Berhasil: $ok, Gagal: $fail"
    $runBtn.Enabled = $true
    $runBtn.Text = "JALANKAN"
    Get-AppStatus
}

function Show-Diagnostic {
    $msg = @"
Langkah troubleshooting:

1. Buka Settings > About Phone > Tap "MIUI/HyperOS Version" 7x
2. Settings > Additional Settings > Developer Options
3. Aktifkan: USB Debugging
4. Setelah colok USB, pilih mode "File Transfer / MTP"
5. Di HP akan muncul popup "Allow USB debugging?" -> OK
6. Coba ganti kabel USB (harus kabel data, bukan charger)

Cek manual di PowerShell:
   adb devices

Jika masih error, install driver:
   winget install Google.PlatformTools
"@
    [System.Windows.Forms.MessageBox]::Show($msg, "Diagnostik - HP Tidak Terdeteksi", "OK", "Information")
}

$form.Add_Shown({ Get-AppStatus })
$form.Topmost = $true
[void]$form.ShowDialog()
