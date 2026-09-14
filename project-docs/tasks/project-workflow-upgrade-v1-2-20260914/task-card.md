# 项目流程升级到 Development OS v1.2

- Internal ID（内部 ID）：`project-workflow-upgrade-v1-2-20260914`
- Workflow version（流程版本）：`v1.2`
- Status（状态）：`ACTIVE`（开发中）
- Business objective（业务目标）：使本项目具备 v1.2 规范入口、项目清单、质量门禁、完整回归清单和可回滚迁移记录。
- Users or affected actors（用户/受影响角色）：项目维护者、开发者、测试者和审计者。
- Priority（优先级）：高
- In scope（范围内）：创建 `project-docs/` v1.2 流程记录；更新 `docs/agent.md` 入口；保留旧 `docs/ai-workflow/`。
- Explicitly out of scope（范围外）：业务源码、运行时配置、既有测试、远程仓库、发布部署。
- Acceptance criteria（验收标准）：v1.2 清单字段完整；入口指向 `project-docs/`；旧记录可读且未删除；升级证据通过路径、版本和哈希校验；独立测试和独立审计完成后才可结项。
- Dependencies（依赖）：现有 Qt 项目文档与三项历史任务记录。
- Non-negotiable constraints（不可妥协约束）：不覆盖用户未提交改动；不改变业务行为；迁移可追溯、可回滚。
- Allowed paths（允许路径）：`docs/agent.md`、`project-docs/`
- Test requirements（测试要求）：迁移验证、旧记录完整性、版本一致性、路径边界检查。
- Risk level（风险级别）：medium（中）
- Approval-needed actions（需批准动作）：已获用户精确批准，见 `approval-events.ndjson`。
- Open questions（开放问题）：无
