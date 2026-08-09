---
name: windows-release-delivery-validation
description: Validate this Qt calculator project's Windows release delivery package, installer scripts, Payload.zip, and isolated integration candidate without running real installers. Use for M01-F03 release delivery, source-repo installation delivery, Package-Release.ps1 / Install-Calculator.ps1 contract fixes, Payload.zip whitelist/hash checks, and NoLaunch installer validation.
---

# Windows Release Delivery Validation

Use this project skill inside `E:\qt\project1` when the user asks to build, fix, test, audit, integrate, or publish the calculator Windows release delivery artifacts.

## Triggers

- 发布交付物 / release delivery artifacts.
- Windows 安装包验证 / installer validation.
- `Payload.zip`, `Package-Release.ps1`, `Install-Calculator.ps1`, `run-independent-validation.ps1`.
- 候选合入验证 / integration candidate validation.
- `-NoLaunch`, VC redist, shortcut, ZIP whitelist, hash, script parameter contract.

## Inputs

- Task directory, usually `docs/ai-workflow/tasks/m01-f03-release-delivery-v1/`.
- Candidate branch or commit and baseline branch or commit.
- Release artifact paths under `release/`.
- Required constraints: no remote push unless explicitly approved, no real `vc_redist.x64.exe` execution, no tag or deployment unless requested.

## Outputs

- Clear pass/fail report with command names, exit codes, and key evidence.
- Updated task evidence files when the phase permits writes.
- Minimal script fixes when validation exposes a parameter or packaging contract mismatch.
- Handoff prompt for the next `development-os` phase when approval is still required.

## Workflow

1. Read `docs/agent.md`, `docs/business-context.md`, the task card, manifest, and existing development/test/audit/integration reports before changing files.
2. Record Git state: current branch, candidate commit, baseline commit, dirty files, existing worktrees, and whether the operation is read-only or write-enabled.
3. Use an isolated git worktree for candidate merge or package validation. Do not mix release validation with the main working tree.
4. For `Payload.zip`, verify existence, SHA-256 when a target hash is known, ZIP entries, path safety, no absolute paths, no UNC paths, and no `..` traversal.
5. Parse PowerShell scripts with AST checks before execution. Confirm parameter contracts among packaging and validation scripts, especially `-OutputDirectory` and `-NoLaunch`.
6. Run validation scripts with `-NoLaunch` or equivalent safe mode. Never execute the real VC redistributable or launch the installed app unless the user explicitly authorizes it.
7. Run the calculator engine regression when build outputs are available. If disk capacity or missing build artifacts block full validation, report the exact blocker and residual risk.
8. Update task reports and evidence with commands, exit codes, Git snapshots, artifact hashes, and known residual risks.
9. If integration is requested, perform candidate merge first in an isolated worktree with `git merge --no-commit --no-ff`, run regression, then request or execute final branch merge only when explicitly authorized.

## Validation

- `git diff --check` passes in the relevant worktree.
- Engine tests pass or the reason they could not run is explicit.
- Release validation exits `0` under safe/no-launch mode.
- ZIP whitelist and path safety checks pass.
- Evidence files name exact commands and exit codes.
- Final response states what was not done: remote push, tags, deployment, real installer execution, or main/master merge.
