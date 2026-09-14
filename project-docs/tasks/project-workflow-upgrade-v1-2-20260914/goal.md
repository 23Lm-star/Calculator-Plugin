# Goal Decision Record（目标决策记录）

- Goal version（目标版本）：2
- Status（状态）：`LOCKED`（已锁定）
- Outcome（结果）：项目流程入口、记录和验证资产全部切换到 Development OS v1.2，旧 v1.0/v1.1 记录仍可追溯；Windows Release 载荷含三项 MSVC CRT DLL，且 Release 构建和完整回归通过。
- Verification surface（验证面）：`evidence/upgrade-validation.md`、迁移清单、Git 路径差异、DLL SHA-256 哈希、Release 构建日志和完整回归报告。
- Scope（范围）：`docs/agent.md`、`project-docs/`、`resources/runtime/win-x64/` 与既有忽略的构建/产物输出；保留 `docs/ai-workflow/`。
- Constraints（约束）：不修改 `src/`、`tests/`、`calculator.pro`、远程仓库和用户既有未提交文件；仅本地候选，不推送、不合并 `main`。
- Stop condition（停止条件）：发现允许路径外变更、旧记录被覆盖、版本字段冲突、DLL 哈希不一致、构建/回归失败，或需要远程操作时立即停止。
- Open questions（开放问题）：无
- User decision（用户决定）：批准按上述范围升级到 v1.2，并批准复制 CRT DLL、重跑 Release 构建和完整回归（2026-09-14）。
- Decision event（决策事件）：`goal-approval-20260914-runtime-regression`
