# Candidate Commit Clean-Clone Validation | M01-F03 | 2026-08-08

## Scope

- Candidate commit: `b591d6db69cac68e94f7989e113012fc631a15c1`
- Controlled clone: `C:\tmp\m01-f03-candidate-clone-b591d6d`
- No real `vc_redist.x64.exe` execution was permitted.

## Commands and Results

| Check | Exit code | Result |
| --- | ---: | --- |
| `git clone --no-local --no-hardlinks E:\qt\project1 C:\tmp\m01-f03-candidate-clone-b591d6d` | 0 | New clone resolves to the candidate commit. |
| Payload presence and SHA-256 | 0 | `release/Payload.zip` exists; 56,029,144 bytes; `87BE6060E0BB4BADBC0658FB162175F1310C48F388E71BF4641BDD0895A3E101`. |
| CMD entrypoint inspection | 0 | `Install-Calculator.cmd` invokes its sibling `Install-Calculator.ps1`; that script resolves the repository `release\Payload.zip`. |
| `validate-repository-payload.ps1 -ProjectRoot <clone>` | 0 | 23 assertions passed: all release scripts parse, archive whitelist/path checks pass, required files exist, and an isolated `-NoLaunch` install finds the committed payload, copies the app, calls the shortcut script, and simulates VC installation with `/install /quiet /norestart`. |

The clone was clean before validation. Validation created only its local `candidate-install-validation.json` evidence artifact in the temporary clone. Its process-local `Start-Process` replacement prevented a system VC runtime installation.
