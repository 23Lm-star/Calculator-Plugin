# Independent Testing Evidence

## 2026-08-03

| Command | Exit code | Observation |
| --- | --- | --- |
| `E:\\qt\\project1\\tests\\engine\\release\\engine_tests.exe` | 0 | `All CalculatorEngine tests passed.` |
| `C:\\ProgramData\\Anaconda31\\Library\\bin\\qmake.exe -query QT_VERSION` | 0 | `5.9.5` |
| `call vcvars64.bat && nmake /nologo /f Makefile.Release` in `E:\\qt\\project1\\build\\app` | 0 | Existing Release target built successfully. |

## Manual UI Evidence

On 2026-08-03, the user manually ran and confirmed the full UI acceptance flow: title and initial state, button input, keyboard input, `CE`, backspace, evaluation, result continuation, divide-by-zero handling, invalid-character handling, malformed-expression handling, and no crash on invalid input.

The prior automated launch request timed out while waiting for local app-control approval. No screenshots were supplied; the UI evidence is a user attestation, and this limitation is carried forward as an audit risk.

## Git Snapshot

Before and after the test commands, Git showed the same pre-existing changes: modified `calculator.pro` and untracked `calculator.pro.user`. The independent testing session did not alter them.
