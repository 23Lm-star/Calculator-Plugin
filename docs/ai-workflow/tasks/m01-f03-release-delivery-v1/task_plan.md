# Task Plan: Repository source installer delivery

## Goal
Deliver a Git-tracked `release/Payload.zip` so a complete project checkout installs Wang Chenyang Calculator through `scripts/release/Install-Calculator.cmd` without Qt, Visual Studio, package generation, or an external Installer ZIP.

## Current Phase
Phase 5 - repair, independent validation, audit, and isolated integration candidate verification

## Phases

### Phase 1: Requirements and discovery
- [x] Read project workflow records and release scripts.
- [x] Confirm the previous delivery depended on an external Installer ZIP.
- **Status:** complete

### Phase 2: Repository payload implementation
- [x] Make the installer locate the tracked payload relative to the repository.
- [x] Make the package script rebuild the tracked payload from a Release directory whitelist.
- [x] Update the user instructions and workflow records.
- **Status:** complete

### Phase 3: Controlled validation
- [x] Parse all release PowerShell scripts.
- [x] Validate the payload whitelist and path safety.
- [x] Validate installation in a copy with no build or artifacts directory, without executing VC Redist.
- **Status:** complete

### Phase 4: Development handoff
- [x] Record hashes, sizes, commands, exit codes, risks, and the independent-test prompt.
- **Status:** complete

### Phase 5: Release validation contract repair
- [x] Restore the documented `-OutputDirectory` compatibility for `Package-Release.ps1` without changing the tracked-payload delivery contract.
- [x] Align the stale independent validation harness with the single `Payload.zip` output and repository-relative installer flow.
- [x] Run independent test and audit gates, then candidate-merge the repaired candidate into a new isolated integration worktree without committing.
- **Status:** complete

## Decisions Made

| Decision | Rationale |
|---|---|
| Track `release/Payload.zip` | A full checkout then contains everything needed by the installer. |
| Retain `Package-Release.ps1` as payload builder | Maintains a repeatable, source-relative way to refresh the tracked binary payload. |
| Do not execute `vc_redist.x64.exe` in validation | Installing a system runtime is outside safe development validation. |

## Errors Encountered

| Error | Attempt | Resolution |
|---|---|---|
| PowerShell validation one-liner had an empty pipeline | 1 | Split script parsing into a foreach loop before formatting. |
| Disk-free inspection is denied by the managed sandbox | 1 | Proceed with the required payload build and record its actual exit code. |
| Payload archive root included a temporary GUID | 1 | Use a stable package root and validate a temporary ZIP before replacing `release/Payload.zip`. |
| Validation script used `$PSScriptRoot` in a parameter default | 1 | Resolve the default project root after the parameter block. |
| ZIP root directory had a bare entry without a separator | 1 | Derive the root from a nested entry and exclude the bare root before trimming. |
| VC process substitute recorded in the wrong scope | 1 | Store and assert the test-only invocation record in global scope, then remove it in cleanup. |
| Full release validation passed `-OutputDirectory` to `Package-Release.ps1`, but the candidate omitted that parameter | 1 | Restore compatibility in the package script; the harness must verify the current single tracked-payload contract rather than obsolete external ZIP outputs. |
