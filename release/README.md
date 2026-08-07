# Wang Chenyang Calculator for Windows

## ZIP package

1. Extract the ZIP file to a writable local folder. Do not run the application from inside the ZIP viewer.
2. Open the extracted folder and run `Create-DesktopShortcut.ps1` with PowerShell.
3. Start the application from the `WangChenyangCalculator` desktop shortcut, or run `WangChenyangCalculator.exe` directly.

The Qt runtime is included with the application; users do not need a Qt development toolchain. The package also includes `vc_redist.x64.exe`, the Microsoft Visual C++ x64 runtime installer. For the portable ZIP, run `vc_redist.x64.exe` manually if the runtime is not already installed. Windows 10 or Windows 11 x64 is required. If Windows reports a missing DLL, keep the package folder intact and contact the distributor with the missing file name.

## Installer package

1. Extract `WangChenyangCalculator-<version>-Installer.zip` to a writable local folder.
2. Run `Install-Calculator.cmd`, or run `Install-Calculator.ps1` from PowerShell with `-ExecutionPolicy Bypass`.

The installer copies the application into the current user's local application folder, creates a desktop shortcut, then automatically runs the deployed `vc_redist.x64.exe` with `/install /quiet /norestart`. No Qt development toolchain is required. If the Visual C++ runtime installation fails, the installer prints the deployed `vc_redist.x64.exe` path so it can be run manually. No administrator permission is required.

The installer starts the application after a successful installation. To remove it, delete the installed application folder and the `WangChenyangCalculator` desktop shortcut.
