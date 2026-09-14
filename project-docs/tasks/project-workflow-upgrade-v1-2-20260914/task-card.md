# 项目流程升级到 Development OS v1.2

- Internal ID（内部 ID）：`project-workflow-upgrade-v1-2-20260914`
- Workflow version（流程版本）：`v1.2`
- Status（状态）：`ACTIVE`（F-005 独立复测通过，待独立审计）
- Business objective（业务目标）：使本项目具备 v1.2 规范入口、项目清单、质量门禁、完整回归清单和可回滚迁移记录，并验证 Windows Release（发布版）运行库载荷。
- Users or affected actors（用户/受影响角色）：项目维护者、开发者、测试者和审计者。
- Priority（优先级）：高
- In scope（范围内）：创建 `project-docs/` v1.2 流程记录；更新 `docs/agent.md` 入口；保留旧 `docs/ai-workflow/`；从本地 Release（发布版）载荷复制 MSVC CRT（微软 C 运行时）DLL 到 `resources/runtime/win-x64/`；重跑 Release 构建和完整回归。
- Explicitly out of scope（范围外）：业务源码、既有测试、工程配置、远程仓库、发布部署、推送和合并 `main`。
- Acceptance criteria（验收标准）：v1.2 清单字段完整；入口指向 `project-docs/`；旧记录可读且未删除；升级证据通过路径、版本和哈希校验；三项 CRT DLL 的来源与目标 SHA-256（安全散列）一致；Release 构建和完整回归通过；不推送且不合并 `main`。
- Dependencies（依赖）：现有 Qt 项目文档与三项历史任务记录。
- Non-negotiable constraints（不可妥协约束）：不覆盖用户未提交改动；不改变业务行为；迁移可追溯、可回滚；仅本地候选，不推送、不合并 `main`。
- Allowed paths（允许路径）：`.gitignore`、`docs/agent.md`、`project-docs/`、`resources/runtime/win-x64/`、既有忽略的 `build/` 和 `artifacts/` 输出。
- Test requirements（测试要求）：迁移验证、旧记录完整性、版本一致性、路径边界检查、Release 构建、Engine（计算引擎）全量测试、发布载荷与隔离安装回归。
- Risk level（风险级别）：medium（中）
- Approval-needed actions（需批准动作）：已获用户精确批准，见 `approval-events.ndjson`。
- Open questions（开放问题）：无
