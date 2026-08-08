# Repair Isolated Validation | M01-F03 | 2026-08-08

## Scope

- Baseline: `integration@1ce0e9a46700fb80e0389457c2dc0452864d0003`.
- Existing candidate: `b591d6db69cac68e94f7989e113012fc631a15c1`.
- Repair files: `scripts/release/Package-Release.ps1` and `evidence/independent-test/run-independent-validation.ps1`.
- Isolated worktree: `C:\tmp\m01-f03-isolated-20260808-contract` (detached); no commit was created.
- Real `vc_redist.x64.exe` execution: prohibited and not performed.

## Git Snapshots

Before merge, the isolated worktree was detached at `1ce0e9a`. `git merge --no-commit --no-ff b591d6d` returned `0`, was conflict-free, and stopped before commit. After validation, `HEAD` remained `1ce0e9a` and `MERGE_HEAD` was `b591d6d`.

The source worktree was already at `b591d6d` with pre-existing task-document changes and unrelated untracked paths; they were preserved. The only repair code/test changes are the two files listed above.

## Commands And Results

| Command | Exit code | Result |
| --- | ---: | --- |
| `git merge --no-commit --no-ff b591d6d` | 0 | Conflict-free isolated candidate merge; no commit. |
| `git diff --check` | 0 | No unstaged whitespace errors. |
| `git diff --cached --check` | 0 | No staged whitespace errors. |
| `build/v1.1-engine/release/engine_tests.exe` | 0 | `All CalculatorEngine tests passed.` |
| `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .../run-independent-validation.ps1` | 0 | 48 assertions passed; log ends `RESULT PASS`. |

`Get-CimInstance Win32_LogicalDisk` and `fsutil volume diskfree` were attempted for `C:` and `E:`. Both were denied by managed sandbox permissions, so no capacity value is asserted.

## Build Artifact Provenance

The untracked `build/v1.1-engine` and `build/v1.1-app` directories were copied from the source worktree solely to execute required gates. Hashes matched before and after copying:

- `engine_tests.exe`: `A64C1FD5775E5019751E38062736076401EEF534526F5FE539C457AF9D7015B1`
- `WangChenyangCalculator.exe`: `B1D0576D18B7B07109FF49368EC8BB32CB62DED5924A6AF93CB3597523D0C413`

## Full Release Validation

- All three release PowerShell scripts parsed with zero errors.
- `Package-Release.ps1 -OutputDirectory <dir>` produced `<dir>\Payload.zip` and preserved the no-argument default target.
- ZIP entries passed whitelist and path safety checks; unapproved plugin/translation files were excluded; drive-letter, UNC, and traversal text was rejected.
- A controlled repository copy omitted `build` and `artifacts/release`, resolved the repository-relative payload, copied the application/runtime, and observed shortcut creation.
- An in-process `Start-Process` substitute observed `vc_redist.x64.exe /install /quiet /norestart` with wait/pass-through. Exit codes `0` and `3010` succeeded, `1603` failed with the installed manual path, and `-NoLaunch` suppressed application launch.
