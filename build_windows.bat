@echo off
REM Build script for creating Windows 64-bit executable

echo ====================================
echo Trae Agent Windows Build Script
echo ====================================
echo.

REM Check if Python is installed
python --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.12+ from https://www.python.org/
    exit /b 1
)

echo Step 1: Installing/Upgrading pip...
python -m pip install --upgrade pip

echo.
echo Step 2: Installing dependencies...
pip install -e .

echo.
echo Step 3: Building Windows executable...
pyinstaller trae-agent.spec --clean --noconfirm

if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    exit /b 1
)

echo.
echo ====================================
echo Build completed successfully!
echo ====================================
echo.
echo Executable location: dist\trae-cli.exe
echo.
echo You can now distribute the trae-cli.exe file.
echo Make sure to include your configuration file (trae_config.yaml)
echo when distributing to end users.
echo.
pause
