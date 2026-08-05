# 任务清单

```yaml
internal_id: m01-f02-calculator-desktop-v1-1
human_name: 计算器桌面化增强与个性化配置 v1.1
workflow_version: v1.1
status: repair_in_progress
stage: repair_in_progress
branch: codex/calculator-desktop-v1.1
base_commit: 4856482
local_commits: []
goal_source: 任务卡.md#confirmed-goal
allowed_paths:
  - calculator.pro
  - resources/
  - src/config/
  - src/main.cpp
  - src/controller/CalculatorController.cpp
  - src/controller/CalculatorController.h
  - src/view/CalculatorUI.cpp
  - src/view/CalculatorUI.h
  - docs/agent.md
  - docs/business-context.md
  - docs/ai-workflow/
changed_implementation_paths:
  - calculator.pro
  - resources/calculator.ico
  - resources/resources.qrc
  - resources/runtime/win-x64/MSVCP140.dll
  - resources/runtime/win-x64/VCRUNTIME140.dll
  - resources/runtime/win-x64/VCRUNTIME140_1.dll
  - src/config/ConfigManager.cpp
  - src/config/ConfigManager.h
  - src/main.cpp
  - src/controller/CalculatorController.cpp
  - src/controller/CalculatorController.h
  - src/view/CalculatorUI.cpp
  - src/view/CalculatorUI.h
reports:
  task_card: 任务卡.md
  development: 开发报告.md
evidence:
  development: evidence/development/development-evidence.md
approval_decisions:
  - 2026-08-05: Direct-run Release delivery confirmed; Microsoft x64 CRT redistributable DLLs are bundled under resources/runtime/win-x64 and copied by calculator.pro. vc_redist.x64.exe remains an installer prerequisite.
next_session_prompt: |
  $development-os 独立测试 计算器桌面化增强与个性化配置 v1.1 docs/ai-workflow/tasks/m01-f02-calculator-desktop-v1-1/
```
