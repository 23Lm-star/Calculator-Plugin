# Plan（计划）：项目流程升级到 v1.2

- Goal ref（目标引用）：`project-docs/tasks/project-workflow-upgrade-v1-2-20260914/goal.md`
- Design ref（设计引用）：`project-docs/tasks/project-workflow-upgrade-v1-2-20260914/design.md`
- Branch（分支）：`codex/release-delivery-v1.0`

## Behavior unit BU-01（行为单元）: 建立 v1.2 项目引导

- Input（输入）：旧 `docs/agent.md` 与旧流程目录。
- Expected behavior（预期行为）：生成 `project-docs/` 规范入口和项目清单。
- Files allowed to change（允许修改）：`docs/agent.md`、`project-docs/`
- Files forbidden to change（禁止修改）：`src/`、`tests/`、`calculator.pro`、`docs/ai-workflow/`
- Verification（验证）：必需文件存在且 `workflow_version` 一致。
- Completion condition（完成条件）：v1.2 引导校验通过。

## Behavior unit BU-02（行为单元）: 保留历史并建立回滚证据

- Input（输入）：旧任务清单、当前 Git 快照和用户批准。
- Expected behavior（预期行为）：历史目录不删除，迁移记录包含哈希、路径、批准和回滚引用。
- Files allowed to change（允许修改）：`project-docs/`
- Files forbidden to change（禁止修改）：旧 `docs/ai-workflow/` 内容及业务源码。
- Verification（验证）：历史哈希一致、允许路径差异检查通过。
- Completion condition（完成条件）：迁移验证报告为 PASS（通过）。

## Behavior unit BU-03（行为单元）: 验证本地 Windows Release 载荷

- Input（输入）：本地 `artifacts/release/WangChenyangCalculator-1.1.0/` 的三项 MSVC CRT DLL。
- Expected behavior（预期行为）：将 DLL 复制至 `resources/runtime/win-x64/`，Release 构建将其复制到输出目录，完整回归通过。
- Files allowed to change（允许修改）：`resources/runtime/win-x64/`、`project-docs/` 和既有忽略的构建/产物输出。
- Files forbidden to change（禁止修改）：`src/`、`tests/`、`calculator.pro`、`docs/ai-workflow/`、远程仓库。
- Verification（验证）：源/目标 SHA-256 一致；Release 构建、Engine 测试、发布载荷及隔离安装校验均通过。
- Completion condition（完成条件）：回归报告为 PASS（通过），无推送和无 `main` 合并。
