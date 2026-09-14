# Goal Decision Record（目标决策记录）

- Goal version（目标版本）：1
- Status（状态）：`LOCKED`（已锁定）
- Outcome（结果）：项目流程入口、记录和验证资产全部切换到 Development OS v1.2，旧 v1.0/v1.1 记录仍可追溯，源码和测试无变更。
- Verification surface（验证面）：`evidence/upgrade-validation.md`、迁移清单、Git 路径差异和 SHA-256 哈希。
- Scope（范围）：仅 `docs/agent.md` 与 `project-docs/`；保留 `docs/ai-workflow/`。
- Constraints（约束）：不修改 `src/`、`tests/`、`calculator.pro`、运行时配置、远程仓库和用户既有未提交文件。
- Stop condition（停止条件）：发现允许路径外变更、旧记录被覆盖、版本字段冲突或无法建立回滚证据时立即停止。
- Open questions（开放问题）：无
- User decision（用户决定）：批准按上述范围升级到 v1.2（2026-09-14）。
- Decision event（决策事件）：`goal-approval-20260914`
