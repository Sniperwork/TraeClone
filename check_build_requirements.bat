@echo off
REM Diagnostic script to check build requirements

echo ====================================
echo Build Requirements Check
echo ====================================
echo.

echo Checking Python...
python --version 2>&1
if errorlevel 1 (
    echo [FAIL] Python not found
    goto :end
) else (
    echo [OK] Python is installed
)

echo.
echo Checking pip...
pip --version 2>&1
if errorlevel 1 (
    echo [FAIL] pip not found
    goto :end
) else (
    echo [OK] pip is installed
)

echo.
echo Checking PyInstaller...
pyinstaller --version 2>&1
if errorlevel 1 (
    echo [FAIL] PyInstaller not installed
    echo Installing PyInstaller...
    pip install pyinstaller
) else (
    echo [OK] PyInstaller is installed
)

echo.
echo Checking project structure...
if exist "trae_agent\cli.py" (
    echo [OK] Found trae_agent\cli.py
) else (
    echo [FAIL] trae_agent\cli.py not found
    echo Make sure you're running this from the project root directory
    goto :end
)

if exist "trae-agent.spec" (
    echo [OK] Found trae-agent.spec
) else (
    echo [FAIL] trae-agent.spec not found
    goto :end
)

echo.
echo Checking Python version (requires 3.12+)...
python -c "import sys; exit(0 if sys.version_info >= (3, 12) else 1)" 2>&1
if errorlevel 1 (
    echo [FAIL] Python version is too old. Need 3.12+
    goto :end
) else (
    echo [OK] Python version is compatible
)

echo.
echo ====================================
echo All checks passed!
echo ====================================
echo.
echo You can now run build_windows.bat to build the executable.
echo.
goto :end

:end
pause
