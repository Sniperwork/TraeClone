# PowerShell Build script for creating Windows 64-bit executable

Write-Host "====================================" -ForegroundColor Cyan
Write-Host "Trae Agent Windows Build Script" -ForegroundColor Cyan
Write-Host "====================================" -ForegroundColor Cyan
Write-Host ""

# Check if Python is installed
try {
    $pythonVersion = python --version 2>&1
    Write-Host "Found: $pythonVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Python is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Python 3.12+ from https://www.python.org/" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Step 1: Installing/Upgrading pip..." -ForegroundColor Yellow
python -m pip install --upgrade pip

Write-Host ""
Write-Host "Step 2: Installing dependencies..." -ForegroundColor Yellow
pip install -e .

Write-Host ""
Write-Host "Step 3: Building Windows executable..." -ForegroundColor Yellow
pyinstaller trae-agent.spec --clean --noconfirm

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "ERROR: Build failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "====================================" -ForegroundColor Green
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""
Write-Host "Executable location: dist\trae-cli.exe" -ForegroundColor Cyan
Write-Host ""
Write-Host "You can now distribute the trae-cli.exe file." -ForegroundColor White
Write-Host "Make sure to include your configuration file (trae_config.yaml)" -ForegroundColor White
Write-Host "when distributing to end users." -ForegroundColor White
Write-Host ""
