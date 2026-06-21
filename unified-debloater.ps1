Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Universal Android Debloater"
$form.Size = New-Object System.Drawing.Size(800, 680)
$form.StartPosition = "CenterScreen"
$form.Icon = [System.Drawing.Icon]::ExtractAssociatedIcon("powershell.exe")

$header = New-Object System.Windows.Forms.Label
$header.Text = "Scanning device..."
$header.Location = New-Object System.Drawing.Point(10, 10)
$header.Size = New-Object System.Drawing.Size(760, 25)
$header.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($header)

$infoLabel = New-Object System.Windows.Forms.Label
$infoLabel.Location = New-Object System.Drawing.Point(10, 38)
$infoLabel.Size = New-Object System.Drawing.Size(760, 20)
$infoLabel.ForeColor = "Gray"
$form.Controls.Add($infoLabel)

$filterPanel = New-Object System.Windows.Forms.FlowLayoutPanel
$filterPanel.Location = New-Object System.Drawing.Point(10, 62)
$filterPanel.Size = New-Object System.Drawing.Size(760, 30)

$filterLabel = New-Object System.Windows.Forms.Label
$filterLabel.Text = "Filter:"
$filterLabel.Size = New-Object System.Drawing.Size(40, 25)
$filterLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$filterPanel.Controls.Add($filterLabel)

$btnAll = New-Object System.Windows.Forms.Button; $btnAll.Text = "Semua"; $btnAll.Size = New-Object System.Drawing.Size(60, 25); $btnAll.Tag = "all"
$btnBloat = New-Object System.Windows.Forms.Button; $btnBloat.Text = "Bloatware"; $btnBloat.Size = New-Object System.Drawing.Size(75, 25); $btnBloat.Tag = "bloat"
$btnSystem = New-Object System.Windows.Forms.Button; $btnSystem.Text = "System"; $btnSystem.Size = New-Object System.Drawing.Size(60, 25); $btnSystem.Tag = "system"
$btnThird = New-Object System.Windows.Forms.Button; $btnThird.Text = "Third Party"; $btnThird.Size = New-Object System.Drawing.Size(80, 25); $btnThird.Tag = "third"
$btnGoogle = New-Object System.Windows.Forms.Button; $btnGoogle.Text = "Google"; $btnGoogle.Size = New-Object System.Drawing.Size(65, 25); $btnGoogle.Tag = "google"

foreach ($b in @($btnAll, $btnBloat, $btnSystem, $btnThird, $btnGoogle)) {
    $b.BackColor = "LightGray"
    $b.Add_Click({ Set-Filter $this.Tag })
    $filterPanel.Controls.Add($b)
}
$form.Controls.Add($filterPanel)

$checkPanel = New-Object System.Windows.Forms.Panel
$checkPanel.Location = New-Object System.Drawing.Point(10, 95)
$checkPanel.Size = New-Object System.Drawing.Size(760, 460)
$checkPanel.AutoScroll = $true
$form.Controls.Add($checkPanel)

$checkboxes = @{}
$allPackages = @()
$filteredPackages = @()
$currentFilter = "all"

$btnAction = New-Object System.Windows.Forms.Button
$btnAction.Text = "DISABLE CENTANGAN"
$btnAction.Location = New-Object System.Drawing.Point(550, 560)
$btnAction.Size = New-Object System.Drawing.Size(220, 40)
$btnAction.BackColor = "DodgerBlue"
$btnAction.ForeColor = "White"
$btnAction.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnAction.Add_Click({ Run-Action })
$form.Controls.Add($btnAction)

$btnRefresh = New-Object System.Windows.Forms.Button
$btnRefresh.Text = "Refresh"
$btnRefresh.Location = New-Object System.Drawing.Point(10, 560)
$btnRefresh.Size = New-Object System.Drawing.Size(80, 30)
$btnRefresh.Add_Click({ Refresh-Device })
$form.Controls.Add($btnRefresh)

$btnCheckAll = New-Object System.Windows.Forms.Button
$btnCheckAll.Text = "Centang Semua"
$btnCheckAll.Location = New-Object System.Drawing.Point(100, 560)
$btnCheckAll.Size = New-Object System.Drawing.Size(100, 30)
$btnCheckAll.Add_Click({ $checkPanel.Controls | Where-Object { $_ -is [System.Windows.Forms.CheckBox] -and $_.Visible } | ForEach-Object { $_.Checked = $true } })
$form.Controls.Add($btnCheckAll)

$btnUncheck = New-Object System.Windows.Forms.Button
$btnUncheck.Text = "Hapus Semua"
$btnUncheck.Location = New-Object System.Drawing.Point(210, 560)
$btnUncheck.Size = New-Object System.Drawing.Size(95, 30)
$btnUncheck.Add_Click({ $checkPanel.Controls | Where-Object { $_ -is [System.Windows.Forms.CheckBox] -and $_.Visible } | ForEach-Object { $_.Checked = $false } })
$form.Controls.Add($btnUncheck)

$logBox = New-Object System.Windows.Forms.TextBox
$logBox.Location = New-Object System.Drawing.Point(10, 610)
$logBox.Size = New-Object System.Drawing.Size(760, 30)
$logBox.ReadOnly = $true
$logBox.BackColor = "Black"
$logBox.ForeColor = "Lime"
$form.Controls.Add($logBox)

$bloatPatterns = @{
    "xiaomi" = @("analytics", "bugreport", "miservice", "micloudsync", "msa", "daemon", "securityadd",
                 "cleanmaster", "voiceassist", "adSolution", "personalassistant", "touchassistant",
                 "mipicks", "midrop", "glgm", "payment", "market", "shop", "game")
    "samsung" = @("bixby", "knox", "samsungpay", "samsungpass", "samsunghealth", "samsungkids",
                  "smartthings", "findmymobile", "gameoptimizing", "gamelancher", "facebook",
                  "arzone", "bixbyvoice", "bixbyvision", "dex", "sidesync", "svoice", "chaton")
    "oppo" = @("heytap", "coloros", "browser", "gamecenter", "joycenter", "appstore", "backup",
               "music", "video", "themestore", "pay", "assistant", "clond", "cloud", "compass")
    "vivo" = @("vivo", "jovi", "appstore", "gamecenter", "ibrowser", "video", "music", "easyshare",
               "vcloud", "vnote", "vcalendar", "vivoassistant", "vivoshell")
    "realme" = @("realme", "heytap", "browser", "gamecenter", "appstore", "music", "video", "theme",
                 "pay", "community", "link", "store", "backup")
    "huawei" = @("huawei", "honor", "appgallery", "hicare", "hilink", "himovie", "video", "music",
                 "browser", "gamecenter", "mobileservices", "assistant", "backup", "cloud")
    "google" = @("google.android.apps.maps", "google.android.apps.photos", "google.android.apps.messaging",
                 "google.android.apps.tachyon", "google.android.apps.docs", "google.android.apps.sheets",
                 "google.android.apps.slides", "google.android.gm", "google.android.youtube",
                 "google.android.videos", "google.android.music", "google.android.printservice",
                 "google.android.feedback", "google.android.partnersetup", "google.android.onetimeinitializer")
    "meta" = @("facebook.katana", "facebook.orca", "facebook.lite", "facebook.system",
               "facebook.appmanager", "facebook.services", "instagram", "whatsapp")
    "microsoft" = @("microsoft.office", "microsoft.word", "microsoft.excel", "microsoft.powerpoint",
                    "microsoft.onedrive", "microsoft.teams", "microsoft.skype", "microsoft.launcher",
                    "microsoft.edge", "microsoft.bing", "microsoft.news", "microsoft.people")
}

function Get-DeviceInfo {
    $brand = (adb shell getprop ro.product.brand 2>$null).Trim()
    $model = (adb shell getprop ro.product.model 2>$null).Trim()
    $name = (adb shell getprop ro.product.name 2>$null).Trim()
    $android = (adb shell getprop ro.build.version.release 2>$null).Trim()
    $miui = (adb shell getprop ro.miui.ui.version.name 2>$null).Trim()
    
    return @{
        Brand = if ($brand) { $brand } else { "unknown" }
        Model = if ($model) { $model } else { "unknown" }
        Name = if ($name) { $name } else { "unknown" }
        Android = if ($android) { $android } else { "unknown" }
        MIUI = if ($miui) { $miui } else { $null }
    }
}

function Test-Bloatware {
    param($pkgName, $brand)
    
    $lower = $pkgName.ToLower()
    
    # Check brand-specific bloat
    if ($bloatPatterns.ContainsKey($brand)) {
        foreach ($pattern in $bloatPatterns[$brand]) {
            if ($lower -match [regex]::Escape($pattern.ToLower()) -or $lower -match $pattern.ToLower()) {
                return $true
            }
        }
    }
    
    # Check cross-brand bloat
    foreach ($key in @("google", "meta", "microsoft")) {
        foreach ($pattern in $bloatPatterns[$key]) {
            if ($lower -match [regex]::Escape($pattern.ToLower())) {
                return $true
            }
        }
    }
    
    return $false
}

function Get-Category {
    param($pkgName, $brand)
    
    $lower = $pkgName.ToLower()
    
    if ($lower -match "google\.android\." -or $lower -match "\.google\.") { return "google" }
    if ($lower -match "facebook|instagram|whatsapp") { return "meta" }
    if ($lower -match "microsoft\.") { return "microsoft" }
    if ($lower -match [regex]::Escape($brand)) { return "system" }
    
    return "third"
}

function Render-Packages {
    param($packages)
    
    $checkPanel.Controls.Clear()
    $checkboxes.Clear()
    
    $y = 5
    $lastCat = ""
    
    foreach ($pkg in $packages) {
        $cat = Get-Category $pkg.Name $pkg.Brand
        if ($pkg.IsBloat) { $cat = "bloatware" }
        
        if ($cat -ne $lastCat) {
            $catColor = switch ($cat) {
                "bloatware" { "Red" }
                "google" { "OrangeRed" }
                "meta" { "DarkViolet" }
                "microsoft" { "SteelBlue" }
                "system" { "DarkOrange" }
                default { "Gray" }
            }
            $catLabel = New-Object System.Windows.Forms.Label
            $catLabel.Text = "--- $cat ---  ($($packages | Where-Object { (Get-Category $_.Name $_.Brand) -eq $cat -or ($_.IsBloat -and $cat -eq "bloatware") } | Measure-Object).Count)"
            $catLabel.Location = New-Object System.Drawing.Point(5, $y)
            $catLabel.Size = New-Object System.Drawing.Size(720, 22)
            $catLabel.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
            $catLabel.ForeColor = $catColor
            $checkPanel.Controls.Add($catLabel)
            $y += 24
            $lastCat = $cat
        }
        
        $cb = New-Object System.Windows.Forms.CheckBox
        $status = if ($pkg.Disabled) { "[DISABLED] " } else { "" }
        $cb.Text = "$status$($pkg.Label)  ($($pkg.Name))"
        $cb.Location = New-Object System.Drawing.Point(20, $y)
        $cb.Size = New-Object System.Drawing.Size(710, 20)
        $cb.Tag = $pkg.Name
        $cb.Font = New-Object System.Drawing.Font("Consolas", 8)
        
        if ($pkg.IsBloat) { $cb.Checked = $true; $cb.ForeColor = "Red" }
        elseif ($cat -eq "third") { $cb.Checked = $false; $cb.ForeColor = "Green" }
        else { $cb.Checked = $false; $cb.ForeColor = "Black" }
        
        $checkPanel.Controls.Add($cb)
        $checkboxes[$pkg.Name] = $cb
        $y += 22
    }
}

function Set-Filter {
    param($filter)
    $script:currentFilter = $filter
    $visible = switch ($filter) {
        "bloat" { $filteredPackages | Where-Object { $_.IsBloat } }
        "system" { $filteredPackages | Where-Object { (Get-Category $_.Name $_.Brand) -eq "system" } }
        "third" { $filteredPackages | Where-Object { (Get-Category $_.Name $_.Brand) -eq "third" -and -not $_.IsBloat } }
        "google" { $filteredPackages | Where-Object { $_.google } }
        default { $filteredPackages }
    }
    
    foreach ($ctrl in $checkPanel.Controls) {
        if ($ctrl -is [System.Windows.Forms.CheckBox]) {
            $ctrl.Visible = $false
            foreach ($pkg in $visible) {
                if ($ctrl.Tag -eq $pkg.Name) { $ctrl.Visible = $true; break }
            }
        } elseif ($ctrl -is [System.Windows.Forms.Label]) {
            $ctrl.Visible = ($filter -eq "all")
        }
    }
    
    foreach ($b in @($btnAll, $btnBloat, $btnSystem, $btnThird, $btnGoogle)) {
        $b.BackColor = if ($b.Tag -eq $filter) { "DodgerBlue"; $b.ForeColor = "White" } else { "LightGray"; $b.ForeColor = "Black" }
    }
}

function Refresh-Device {
    $header.Text = "Scanning device..."
    $infoLabel.Text = ""
    [System.Windows.Forms.Application]::DoEvents()
    
    $device = adb devices 2>$null | Where-Object { $_ -match "device$" }
    if (-not $device) {
        $logBox.Text = "ERROR: Tidak ada perangkat terdeteksi. USB debugging aktif?"
        $header.Text = "Universal Android Debloater - NO DEVICE"
        return
    }
    
    $devInfo = Get-DeviceInfo
    $brand = $devInfo.Brand.ToLower()
    $header.Text = "$($devInfo.Brand) $($devInfo.Model) | Android $($devInfo.Android)"
    if ($devInfo.MIUI) { $header.Text += " | MIUI $($devInfo.MIUI)" }
    
    $infoLabel.Text = "Scanning packages (this may take a moment)..."
    [System.Windows.Forms.Application]::DoEvents()
    
    # Get all 3rd-party packages
    $rawPkgs = adb shell pm list packages -3 2>$null
    $rawDisabled = adb shell pm list packages --disabled 2>$null
    $disabledSet = @{}
    if ($rawDisabled) {
        $rawDisabled | ForEach-Object { $p = $_ -replace "package:", ""; $p = $p.Trim(); $disabledSet[$p] = $true }
    }
    
    $script:allPackages = @()
    $script:filteredPackages = @()
    
    if ($rawPkgs) {
        $i = 0; $total = $rawPkgs.Count
        foreach ($line in $rawPkgs) {
            $pkgName = ($line -replace "package:", "").Trim()
            if (-not $pkgName) { continue }
            
            # Simple label from package name
            $label = $pkgName -replace ".*\.", ""
            
            $isBloat = Test-Bloatware $pkgName $brand
            $isDisabled = $disabledSet.ContainsKey($pkgName)
            
            $script:allPackages += @{
                Name = $pkgName
                Label = $label
                Size = 0
                IsBloat = $isBloat
                Disabled = $isDisabled
                Brand = $brand
                google = (Get-Category $pkgName $brand) -eq "google"
            }
            
            $i++
            if ($i % 20 -eq 0) {
                $infoLabel.Text = "Scanning... $i / $total packages"
                [System.Windows.Forms.Application]::DoEvents()
            }
        }
    }
    
    # Sort: bloatware first, then by category
    $script:allPackages = $script:allPackages | Sort-Object { -([int]$_.IsBloat) }, { $_.google -eq $true }, Name
    $script:filteredPackages = $script:allPackages
    
    Render-Packages $script:filteredPackages
    
    $total = $allPackages.Count
    $bloatCount = ($allPackages | Where-Object { $_.IsBloat }).Count
    $disabledCount = ($allPackages | Where-Object { $_.Disabled }).Count
    $logBox.Text = "Total: $total packages | Bloatware terdeteksi: $bloatCount | Sudah di-disable: $disabledCount"
    $infoLabel.Text = "Klik kanan pada package untuk disable/enable individual | Centang = akan di-disable"
}

# Context menu for right-click
$contextMenu = New-Object System.Windows.Forms.ContextMenuStrip

$disableMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
$disableMenuItem.Text = "Disable app ini"
$contextMenu.Items.Add($disableMenuItem)

$enableMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
$enableMenuItem.Text = "Enable app ini"
$contextMenu.Items.Add($enableMenuItem)

$checkPanel.Add_MouseDown({
    if ($_.Button -eq [System.Windows.Forms.MouseButtons]::Right) {
        $ctrl = $checkPanel.GetChildAtPoint($_.Location)
        if ($ctrl -is [System.Windows.Forms.CheckBox]) {
            $contextMenu.SourceControl = $ctrl
            $contextMenu.Show($checkPanel, $_.Location)
        }
    }
})

$disableMenuItem.Add_Click({
    $cb = $contextMenu.SourceControl
    if (-not $cb) { return }
    $pkg = $cb.Tag
    $r = adb shell pm disable-user --user 0 $pkg 2>&1
    if ($LASTEXITCODE -eq 0) { $cb.Checked = $true; $cb.ForeColor = "Red"; $logBox.Text = "OK: ${pkg} di-disable" }
    else { $logBox.Text = "Gagal disable ${pkg}: $r" }
})

$enableMenuItem.Add_Click({
    $cb = $contextMenu.SourceControl
    if (-not $cb) { return }
    $pkg = $cb.Tag
    $r = adb shell pm enable $pkg 2>&1
    if ($LASTEXITCODE -eq 0) { $cb.Checked = $false; $cb.ForeColor = "Green"; $logBox.Text = "OK: ${pkg} di-enable" }
    else { $logBox.Text = "Gagal enable ${pkg}: $r" }
})

function Run-Action {
    $device = adb devices 2>$null | Where-Object { $_ -match "device$" }
    if (-not $device) { $logBox.Text = "ERROR: No device"; return }
    
    $btnAction.Enabled = $false
    $btnAction.Text = "PROSES..."
    
    $toDisable = @()
    $toEnable = @()
    $disabledNow = adb shell pm list packages --disabled 2>$null
    
    foreach ($kv in $checkboxes.GetEnumerator()) {
        $pkgName = $kv.Key
        $isChecked = $kv.Value.Checked
        $isDisabled = $disabledNow -match [regex]::Escape($pkgName)
        
        if ($isChecked -and -not $isDisabled) { $toDisable += $pkgName }
        elseif (-not $isChecked -and $isDisabled) { $toEnable += $pkgName }
    }
    
    $total = $toDisable.Count + $toEnable.Count
    if ($total -eq 0) { $logBox.Text = "Tidak ada perubahan."; $btnAction.Enabled = $true; $btnAction.Text = "DISABLE CENTANGAN"; return }
    
    $action = [System.Windows.Forms.MessageBox]::Show("Disable: $($toDisable.Count) apps`nEnable: $($toEnable.Count) apps`nLanjutkan?", "Konfirmasi", "YesNo", "Question")
    if ($action -eq "No") { $btnAction.Enabled = $true; $btnAction.Text = "DISABLE CENTANGAN"; return }
    
    $ok = 0; $fail = 0
    foreach ($pkg in $toDisable) {
        $r = adb shell pm disable-user --user 0 $pkg 2>&1
        if ($LASTEXITCODE -eq 0) { $ok++ } else { $fail++ }
        $logBox.Text = "[$($ok+$fail)/$($toDisable.Count)] $([math]::Round(($ok+$fail)/$toDisable.Count*100))% Disable: $pkg"
        [System.Windows.Forms.Application]::DoEvents()
    }
    foreach ($pkg in $toEnable) {
        $r = adb shell pm enable $pkg 2>&1
        if ($LASTEXITCODE -eq 0) { $ok++ } else { $fail++ }
        $logBox.Text = "Enable: $pkg"
        [System.Windows.Forms.Application]::DoEvents()
    }
    
    $logBox.Text = "Selesai! Berhasil: $ok, Gagal: $fail"
    $btnAction.Enabled = $true
    $btnAction.Text = "DISABLE CENTANGAN"
    
    Refresh-Device
}

$form.Add_Shown({ Refresh-Device })
$form.Topmost = $true
[void]$form.ShowDialog()
