# 任务清单

```yaml
internal_id: m01-f02-calculator-desktop-v1-1
human_name: 计算器桌面化增强与个性化配置 v1.1
workflow_version: v1.1
status: completed
stage: local_integration_completed
branch: integration
base_commit: 4856482
local_commits:
  - fbf0b6a
integration_commit: 37c94aa
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
  independent_test: 独立测试报告.md
  integration: 集成报告.md
evidence:
  development: evidence/development/development-evidence.md
  independent_test: evidence/independent-test/
  integration: evidence/integration/
approval_decisions:
  - 2026-08-05: Direct-run Release delivery confirmed; Microsoft x64 CRT redistributable DLLs are bundled under resources/runtime/win-x64 and copied by calculator.pro. vc_redist.x64.exe remains an installer prerequisite.
known_limitations:
  - 预设主题关闭重启后回退 Ocean；用户决定暂不处理，不修改源码，不阻断本地集成。
next_session_prompt: |
  $development-os 发布准备 计算器桌面化增强与个性化配置 v1.1 docs/ai-workflow/tasks/m01-f02-calculator-desktop-v1-1/
```
