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
echo Checking Python version (requires 3.12.x, NOT 3.13)...
python -c "import sys; v=sys.version_info; exit(0 if v.major==3 and v.minor==12 else 1)" 2>&1
if errorlevel 1 (
    python -c "import sys; v=sys.version_info; print(f'[FAIL] Python {v.major}.{v.minor} detected. Need Python 3.12.x specifically')"
    echo.
    echo Python 3.13 is NOT supported yet due to dependency compatibility.
    echo Please install Python 3.12.x from https://www.python.org/downloads/
    echo.
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
