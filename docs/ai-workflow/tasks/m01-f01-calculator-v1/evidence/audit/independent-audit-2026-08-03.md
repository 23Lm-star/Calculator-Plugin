# Independent Audit Evidence

## Git snapshot before and after

Both snapshots contained the same paths:

```text
 M .gitignore
 M calculator.pro
 M docs/ai-workflow/tasks/m01-f01-calculator-v1/manifest.md
 M docs/ai-workflow/tasks/m01-f01-calculator-v1/独立测试报告.md
 M docs/ai-workflow/任务总览.md
 M docs/ai-workflow/项目时间流.md
?? docs/ai-workflow/tasks/m01-f01-calculator-v1/evidence/independent-testing.md
```

The audit session added only this evidence file and the audit report. It did not alter source, configuration, tests, branches, commits, or existing task records. The user subsequently confirmed that `.gitignore` and `calculator.pro` are necessary project configuration changes for this task, so they are not treated as unrelated scope violations.

## Commands

| Command | Exit code | Result |
| --- | --- | --- |
| `tests\\engine\\release\\engine_tests.exe` | 0 | `All CalculatorEngine tests passed.` |
| `rg -n '#include <Q|QString|QObject|Q[A-Z]' src\\model tests\\engine` | 0 | No Qt reference under `src/model`; matches are only in the test qmake file disabling Qt modules. |
| `git diff --check e2ce7e6..HEAD` | 0 | No whitespace errors. |
| `dumpbin /dependents tests\\engine\\release\\engine_tests.exe` | N/A | `dumpbin.exe` was not available in this audit shell; development evidence records the dependency check. |

## UI evidence limitation

The independent-test record contains user attestation of the critical UI path. Application-control authorization previously timed out, so no automated screenshot or window-control trace exists.
