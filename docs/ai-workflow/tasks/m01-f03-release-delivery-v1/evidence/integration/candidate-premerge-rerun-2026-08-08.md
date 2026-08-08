# Candidate Pre-Merge Rerun | M01-F03 | 2026-08-08

## Scope

- Candidate: `b591d6db69cac68e94f7989e113012fc631a15c1`
- Validation clone: `C:\tmp\m01-f03-integration-rerun-b591d6d`
- Target branch: `integration` (not checked out, merged, or modified)
- Real `vc_redist.x64.exe` execution: prohibited and not performed

## Results

| Check | Result |
| --- | --- |
| Fresh `git clone --no-local --no-hardlinks` | Exit 0; clone HEAD equals `b591d6d` and worktree is clean. |
| Repository payload | Present at `release/Payload.zip`; 56,029,144 bytes; SHA-256 `87BE6060E0BB4BADBC0658FB162175F1310C48F388E71BF4641BDD0895A3E101`. |
| ZIP safety | 19 file entries; whitelist pass; no absolute path, UNC, or `..` entry. |
| Entrypoint resolution | CMD invokes sibling `%~dp0Install-Calculator.ps1`; PS resolves repository-root `release\Payload.zip`. |
| PowerShell AST | `Create-DesktopShortcut.ps1`, `Install-Calculator.ps1`, and `Package-Release.ps1`: zero parse errors. |
| Controlled `-NoLaunch` install | 23 assertions passed without `build` or `artifacts/release`; executable and `platforms\qwindows.dll` copied; shortcut invocation observed. |
| VC runtime boundary | Process-local `Start-Process` substitute observed `vc_redist.x64.exe /install /quiet /norestart` with `-Wait -PassThru`; no real runtime installer ran. |

The validation shortcut did not remain after the test. After recording this evidence, the session-owned temporary clone was removed to release disk space; no repository worktree or pre-existing untracked path was removed.

## Integration Gate

Candidate pre-merge verification passes. Full regression and the no-commit candidate merge are not run because the task requires a new explicit approval before either action.
