# Building Trae Agent for Windows (64-bit)

This guide explains how to create a standalone Windows executable for Trae Agent.

## Prerequisites

- Windows 10/11 (64-bit)
- **Python 3.12.x (64-bit version)** - IMPORTANT: Python 3.13 is NOT supported yet
  - Download from: https://www.python.org/downloads/
  - Make sure to select version 3.12.x (e.g., 3.12.0, 3.12.1, etc.)
  - During installation, check "Add Python to PATH"
- Internet connection for downloading dependencies

## Quick Build

### Option 1: Using Batch Script (Command Prompt)

1. Open Command Prompt in the project directory
2. Run the build script:
   ```cmd
   build_windows.bat
   ```

### Option 2: Using PowerShell Script

1. Open PowerShell in the project directory
2. If needed, allow script execution:
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
   ```
3. Run the build script:
   ```powershell
   .\build_windows.ps1
   ```

### Option 3: Manual Build

If you prefer to build manually:

```cmd
# Install dependencies
pip install -e .

# Build the executable
pyinstaller trae-agent.spec --clean --noconfirm
```

## Output

After successful build, you will find:
- `dist/trae-cli.exe` - The standalone executable (approximately 100-200 MB)

## Testing the Executable

```cmd
# Test the built executable
cd dist
trae-cli.exe --help

# Run with a simple task
trae-cli.exe run "Create a hello world Python script"
```

## Distribution

To distribute Trae Agent:

1. Copy `trae-cli.exe` from the `dist` folder
2. Create a `trae_config.yaml` file with API configurations (or instruct users to create one)
3. Optionally, create a `.env` file for environment variables

### Example Distribution Package Structure

```
trae-agent-windows/
├── trae-cli.exe
├── trae_config.yaml.example
├── README.txt (with usage instructions)
└── .env.example
```

## Configuration for End Users

Users will need to:

1. Create `trae_config.yaml` based on the example:
   ```yaml
   agents:
     trae_agent:
       enable_lakeview: true
       model: trae_agent_model
       max_steps: 200
       tools:
         - bash
         - str_replace_based_edit_tool
         - sequentialthinking
         - task_done

   model_providers:
     zai:
       api_key: YOUR_API_KEY_HERE
       provider: zai
       base_url: https://api.z.ai/api/paas/v4

   models:
     trae_agent_model:
       model_provider: zai
       model: glm-4.6
       max_tokens: 4096
       temperature: 0.5
   ```

2. Place `trae_config.yaml` in the same directory as `trae-cli.exe`

## Troubleshooting

### Script Closes Immediately / Can't See Errors

If the build script closes immediately without showing errors:

1. **Run the diagnostic script first:**
   ```cmd
   check_build_requirements.bat
   ```
   This will check all requirements and stay open to show results.

2. **Run from Command Prompt manually:**
   - Open Command Prompt (cmd.exe)
   - Navigate to the project folder: `cd C:\path\to\trae-agent`
   - Run: `build_windows.bat`
   - The window will stay open and show all errors

3. **Check step-by-step manually:**
   ```cmd
   python --version
   pip --version
   pyinstaller --version
   ```

### Build Errors

**"Python is not installed or not in PATH"**
- Install Python 3.12+ from https://www.python.org/
- During installation, check "Add Python to PATH"
- Restart your computer after installation
- Verify: open Command Prompt and type `python --version`

**"pyinstaller: command not found" or "pyinstaller is not recognized"**
- Run: `pip install pyinstaller`
- Or run: `python -m pip install pyinstaller`
- Close and reopen Command Prompt after installation

**"Module not found" errors during build**
- Ensure all dependencies are installed: `pip install -e .`
- Try updating pip: `python -m pip install --upgrade pip`
- If specific module fails, install individually: `pip install [module-name]`

**"error: Microsoft Visual C++ 14.0 or greater is required"**
- Install Visual C++ Build Tools from https://visualstudio.microsoft.com/downloads/
- Or install "Desktop development with C++" workload in Visual Studio

**"Permission denied" errors**
- Run Command Prompt as Administrator (right-click > Run as administrator)
- Check if antivirus is blocking the build
- Ensure you have write permissions in the project directory

**Large executable size**
- This is normal. PyInstaller bundles Python runtime and all dependencies
- Typical size: 100-200 MB

### Runtime Errors

**"Failed to execute script" error**
- Ensure `trae_config.yaml` exists in the same directory
- Check that API keys are properly configured
- Run with `--help` flag to verify the executable works: `trae-cli.exe --help`

**Antivirus blocking the executable**
- Some antivirus software may flag PyInstaller executables
- Add an exception for `trae-cli.exe`
- Alternatively, build on the target machine

## Advanced: Customizing the Build

### Modifying the Spec File

Edit `trae-agent.spec` to customize:

- **Icon**: Add `icon='path/to/icon.ico'` in the EXE section
- **Version info**: Add version resource for Windows properties
- **Additional data files**: Add to the `datas` list
- **Exclude modules**: Add to the `excludes` list to reduce size

### Adding an Icon

1. Create or obtain a `.ico` file
2. Edit `trae-agent.spec`:
   ```python
   exe = EXE(
       ...
       icon='trae-icon.ico',
       ...
   )
   ```
3. Rebuild using the build script

### UPX Compression

The spec file includes UPX compression (`upx=True`) to reduce executable size. If you encounter issues:

1. Download UPX from https://upx.github.io/
2. Extract to a folder in your PATH
3. Rebuild

Or disable UPX by setting `upx=False` in `trae-agent.spec`

## Notes

- The executable is self-contained and includes all Python dependencies
- Users do NOT need to install Python to run the executable
- The executable is portable and can run from any location
- First run may be slower as Windows Defender scans the file
- Configuration files must be in the same directory as the executable

## System Requirements for Running the Executable

- Windows 10/11 (64-bit)
- Minimum 4 GB RAM
- Internet connection for API calls
- ~500 MB free disk space
