# Findings

## Requirements

- The only recommended user action is a complete clone/download followed by `scripts/release/Install-Calculator.cmd`.
- The equivalent PowerShell entry point is a fallback.
- `Payload.zip` must contain the application, Qt runtime, `platforms/qwindows.dll`, MSVC CRT files, `vc_redist.x64.exe`, the shortcut script, and README.
- No application source, build process, dependency, Git-history, push, deployment, or independent-test transition is authorized.

## Research Findings

- The prior installer script expected `Payload.zip` beside itself only after extracting `*-Installer.zip`; it intentionally rejected source-tree execution.
- `build/v1.1-app/release` currently contains the required EXE, Qt DLLs, CRT DLLs, `platforms/qwindows.dll`, and `vc_redist.x64.exe`.
- The existing package script already has archive path safety helpers and an explicit runtime list; it will be repointed to the repository payload output.

## Technical Decisions

| Decision | Rationale |
|---|---|
| Payload path is `../../release/Payload.zip` relative to `scripts/release` | It works after checkout/copy without a machine-specific path. |
| Use an explicit archive-entry whitelist | Prevents a Release folder from silently shipping extra files. |
| Build a temporary ZIP before replacement | A failed validation cannot leave an unchecked tracked payload behind. |
