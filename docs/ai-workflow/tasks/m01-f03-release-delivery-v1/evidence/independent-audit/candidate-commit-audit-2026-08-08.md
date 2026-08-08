# Candidate Commit Audit | M01-F03 | 2026-08-08

## Decision

PASS for the approved local candidate commit `b591d6d`.

## Evidence

- A fresh `--no-local --no-hardlinks` clone contains the committed `release/Payload.zip` with the recorded 56,029,144-byte size and SHA-256 `87BE6060E0BB4BADBC0658FB162175F1310C48F388E71BF4641BDD0895A3E101`.
- The CMD entry is repository-relative and invokes `Install-Calculator.ps1`; the installer resolves the committed repository root `release\Payload.zip`, not an external Installer ZIP or a build directory.
- The controlled clone validation passed all 23 assertions, including PowerShell AST parsing, archive whitelist/path defense, required runtime files, an install without `build` or `artifacts/release`, shortcut invocation, VC arguments, and `-NoLaunch`.
- `vc_redist.x64.exe` was intercepted in-process; no real installer execution or system runtime mutation occurred.

## Residual Risk

The real VC runtime installer and GUI application launch remain intentionally unexecuted under the task constraint. This is not an acceptance gap because the executable, Qt runtime, CRT, and installer branches are covered by the controlled validation. No source, dependency, branch, merge, push, deployment, or Git history rewrite occurred.
