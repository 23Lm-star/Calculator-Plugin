# Integration Report | M01-F03

## Outcome

Local integration is **complete**. Candidate `68ab544` was verified against current `integration@0b18a4e`, documentation conflicts were resolved in the isolated verification worktree, and the approved no-fast-forward merge completed as `dff723b`.

`engine_tests.exe` passed with `All CalculatorEngine tests passed.` The complete release validation command could not finish because the local filesystem reported no available free space. It failed while copying the portable ZIP into the installer package with `Copy-Item : There is not enough space on the disk.`

## Evidence

- Candidate input: `codex/release-delivery-v1.0@d454114`
- Candidate target: `integration@1ce0e9a`
- Candidate merge: `git merge --no-commit --no-ff codex/release-delivery-v1.0` (success)
- Source check: `git diff --check` (pass)
- Engine regression: `build/v1.1-engine/release/engine_tests.exe` (exit 0)
- Release regression: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File docs/ai-workflow/tasks/m01-f03-release-delivery-v1/evidence/independent-test/run-independent-validation.ps1` (exit 1, insufficient disk space)

## Decision

No local merge was made to `integration`. `main` was not merged, no tag was created, no remote was contacted, and no deployment occurred. The earlier capacity failure is historical; the repaired isolated regression has passed and its capacity query restriction is recorded below.

## Pre-Merge Re-run | 2026-08-08

Candidate `b591d6d` passed a new fresh-clone installer verification: tracked payload present with the required SHA-256, 19-entry safe ZIP whitelist, CMD-to-sibling-PowerShell repository payload resolution, zero PowerShell AST errors, and the 23-assertion isolated `-NoLaunch` installation. The VC process was intercepted and verified with `/install /quiet /norestart`; no real VC runtime installer ran.

The actual candidate merge into `integration` completed as `dff723b`. The prior full-regression result was superseded by the successful repaired isolated validation recorded below.

Evidence: `evidence/integration/candidate-premerge-rerun-2026-08-08.md`.

## Repair Candidate Verification | 2026-08-08

The prior failure was an interface mismatch: the package script did not accept the harness's existing `-OutputDirectory` argument. The repaired candidate is committed as `68ab54439f8e859779844ef4e6723f24e3545d25` and contains `scripts/release/Package-Release.ps1` plus the task-scoped independent validation harness.

| Gate | Exit code | Result |
| --- | ---: | --- |
| `git merge --no-commit --no-ff b591d6d` | 0 | Conflict-free; stopped before commit. |
| `git diff --check` | 0 | No unstaged whitespace errors. |
| `git diff --cached --check` | 0 | No staged whitespace errors. |
| `build/v1.1-engine/release/engine_tests.exe` | 0 | `All CalculatorEngine tests passed.` |
| `run-independent-validation.ps1` | 0 | 48 assertions passed; VC process calls intercepted in-process. |

The isolated worktree copied untracked build outputs only after matching Engine SHA-256 `A64C1FD5775E5019751E38062736076401EEF534526F5FE539C457AF9D7015B1` and application EXE SHA-256 `B1D0576D18B7B07109FF49368EC8BB32CB62DED5924A6AF93CB3597523D0C413`. Disk-capacity queries were denied by the managed sandbox, so capacity is unavailable rather than inferred. The isolated verification merge remained uncommitted. The approved actual `integration` merge completed as `dff723b`; no remote, tag, deployment, or main merge occurred.

## NEXT_SESSION_PROMPT

```text
$development-os 集成 发布交付物生成与部署脚本化 docs/ai-workflow/tasks/m01-f03-release-delivery-v1/

Resolve the local disk-capacity blocker, then recreate the no-commit candidate merge from integration@1ce0e9a to d454114. Run engine_tests.exe and the independent release validation script. Only if both pass may the work be locally merged to integration. Do not merge main, push, tag, or deploy.
```
