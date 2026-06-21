# Build .EXE dari PowerShell script
# Usage: .\build-exe.ps1

$scriptPath = "D:\OpenCode\test debloat\unified-debloater.ps1"
$outputPath = "D:\OpenCode\test debloat\AndroidDebloater.exe"

# 1. Install ps2exe jika belum ada
$mod = Get-Module -ListAvailable -Name ps2exe
if (-not $mod) {
    Write-Host "Menginstall ps2exe..." -ForegroundColor Yellow
    Install-Module -Name ps2exe -Force -Scope CurrentUser -AllowClobber
    if (-not $?) { 
        Write-Host "Gagal install ps2exe. Coba admin: Install-Module ps2exe -Force" -ForegroundColor Red
        exit 1
    }
}

Import-Module ps2exe -Force

# 2. Convert ke EXE
Write-Host "Mengkonversi ke EXE..." -ForegroundColor Cyan
$params = @{
    InputFile = $scriptPath
    OutputFile = $outputPath
    Title = "Universal Android Debloater"
    Description = "Tool untuk disable bloatware Android via ADB"
    Product = "Android Debloater"
    Version = "1.0.0"
    Verbose = $true
    # Windows aplikasi (tanpa console)
    NoConsole = $true
}

# Coba ps2exe dengan parameter
try {
    ps2exe @params -ErrorAction Stop
    if ($?) {
        Write-Host "SUKSES! EXE dibuat di: $outputPath" -ForegroundColor Green
        Write-Host "Ukuran: $((Get-Item $outputPath).Length / 1KB) KB" -ForegroundColor Gray
    }
} catch {
    Write-Host "Gagal: $_" -ForegroundColor Red
    Write-Host "Coba metode alternatif..." -ForegroundColor Yellow
    
    # Fallback: buat C# wrapper
    $csCode = @'
using System;
using System.Diagnostics;
using System.IO;
using System.Management.Automation;
using System.Windows.Forms;

class Program {
    static void Main() {
        string script = @"
'@ + (Get-Content $scriptPath -Raw) + @'
";
        using (PowerShell ps = PowerShell.Create()) {
            ps.AddScript(script);
            ps.Invoke();
        }
    }
}
'@
    Write-Host "Fallback belum diimplementasikan. Install ps2exe secara manual:" -ForegroundColor Yellow
    Write-Host "  Install-Module -Name ps2exe -Force -Scope CurrentUser" -ForegroundColor White
    Write-Host "  ps2exe -InputFile '$scriptPath' -OutputFile '$outputPath' -NoConsole" -ForegroundColor White
}
