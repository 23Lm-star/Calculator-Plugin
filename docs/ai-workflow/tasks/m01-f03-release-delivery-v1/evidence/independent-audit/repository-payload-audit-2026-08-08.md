# Repository Payload Audit Evidence | 2026-08-08

## Start snapshot

- `git status --short` already contained task and release delivery changes; notably `?? release/Payload.zip`.
- `git diff --stat` contained changes to task records, `release/README.md`, `scripts/release/Install-Calculator.ps1`, and `scripts/release/Package-Release.ps1`.

## Read-only checks

| Check | Result |
| --- | --- |
| `git ls-files -- release/Payload.zip` | No output; payload is not Git-indexed. |
| `git diff --check` | Exit 0. |
| AST parse | `Create-DesktopShortcut.ps1`, `Install-Calculator.ps1`, `Package-Release.ps1`: 0 errors. |
| Payload SHA-256 | `87BE6060E0BB4BADBC0658FB162175F1310C48F388E71BF4641BDD0895A3E101` (56,029,144 bytes). |
| ZIP inventory | 19 entries, exact explicit whitelist; 0 absolute/UNC/`..` entries; 0 matching text-path leaks. |
| Independent-test evidence | JSON records no `build` or `artifacts/release`, process-local VC substitute only, copy/extract/shortcut, VC `0`/`3010`/`1603`, and `-NoLaunch`. |

## End snapshot

- Branch: `codex/release-delivery-v1.0`; HEAD: `0fd9edeeadf87a5738a170dc9ae1a0c1286387d2` (`docs(workflow): record blocked release candidate`).
- Pre-existing modified/untracked delivery paths remain. This audit additionally modified `独立审计报告.md` and added this evidence file only.
- `git diff --check` remained exit 0.
