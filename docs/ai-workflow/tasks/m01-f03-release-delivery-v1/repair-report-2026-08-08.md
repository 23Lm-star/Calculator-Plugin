# Repair Report | M01-F03 | 2026-08-08

## Finding

Running `scripts/release/Install-Calculator.ps1` from an extracted source tree fails because `Payload.zip` exists only inside the generated installer archive.

## Change

- Added source-tree recovery guidance to `Install-Calculator.ps1`.
- Clarified in `release/README.md` that the script is a packaging input and must be run only after extracting `WangChenyangCalculator-<version>-Installer.zip`.
- Rebuilt `artifacts/release/WangChenyangCalculator-1.1.0.zip` and `artifacts/release/WangChenyangCalculator-1.1.0-Installer.zip`.

## Verification

- PowerShell AST parsing passed for the installer and packaging scripts.
- The generated installer contains exactly `Payload.zip`, `Install-Calculator.ps1`, and `Install-Calculator.cmd`.
- Executing the source-tree installer now exits with the expected recovery guidance.
- No real Visual C++ runtime installation was executed.

## Remaining Risk

The existing integration-candidate regression remains blocked by its recorded disk-capacity issue. This repair did not merge, push, deploy, or run the real VC runtime installer.
