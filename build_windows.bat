@echo off
REM Build script for creating Windows 64-bit executable

echo ====================================
echo Trae Agent Windows Build Script
echo ====================================
echo.

REM Check if Python is installed
echo Checking Python installation...
python --version 2>&1
if errorlevel 1 (
    echo.
    echo ERROR: Python is not installed or not in PATH
    echo Please install Python 3.12+ from https://www.python.org/
    echo.
    pause
    exit /b 1
)

echo.
echo Step 1: Installing/Upgrading pip...
python -m pip install --upgrade pip
if errorlevel 1 (
    echo.
    echo ERROR: Failed to upgrade pip
    echo.
    pause
    exit /b 1
)

echo.
echo Step 2: Installing dependencies...
echo This may take several minutes...
pip install -e .
if errorlevel 1 (
    echo.
    echo ERROR: Failed to install dependencies
    echo.
    pause
    exit /b 1
)

echo.
echo Step 3: Building Windows executable...
echo This will take a few minutes...
pyinstaller trae-agent.spec --clean --noconfirm
if errorlevel 1 (
    echo.
    echo ERROR: Build failed!
    echo Check the error messages above for details.
    echo.
    echo Common issues:
    echo - Missing dependencies: Try running 'pip install pyinstaller' manually
    echo - Path issues: Make sure you're running from the project root directory
    echo - Antivirus: Temporarily disable antivirus and try again
    echo.
    pause
    exit /b 1
)

echo.
echo ====================================
echo Build completed successfully!
echo ====================================
echo.
echo Executable location: dist\trae-cli.exe
echo File size:
dir dist\trae-cli.exe | find "trae-cli.exe"
echo.
echo You can now distribute the trae-cli.exe file.
echo Make sure to include your configuration file (trae_config.yaml)
echo when distributing to end users.
echo.
pause
