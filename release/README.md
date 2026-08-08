# Wang Chenyang Calculator for Windows

## Install

The only recommended installation step is:

1. Clone the complete project repository, or download and extract the complete project archive.
2. Open `scripts\release` and run `Install-Calculator.cmd`.

PowerShell is an equivalent fallback: run `Install-Calculator.ps1` from the same `scripts\release` directory with `-ExecutionPolicy Bypass`.

The installer reads the repository-tracked `release\Payload.zip`, installs to the current user's local application directory, creates the desktop shortcut, and then runs the bundled `vc_redist.x64.exe` with `/install /quiet /norestart`. Qt and Microsoft Visual C++ runtime files required by the application are already in the payload. Windows 10 or Windows 11 x64 is required.

After a successful installation the calculator starts automatically. To remove it, delete the installed application directory and the `WangChenyangCalculator` desktop shortcut.

## Maintainers

`Package-Release.ps1` rebuilds the tracked `release\Payload.zip` from a Release directory. It is a maintainer packaging operation, not an end-user installation step.
