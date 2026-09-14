# Next Session Prompt（下一会话提示）

- 项目根目录：`E:/qt/project1`
- 流程版本：`v1.2`
- 任务：`project-workflow-upgrade-v1-2-20260914`（项目流程升级到 Development OS v1.2）
- 当前状态：`ACTIVE`（开发完成，待独立测试）
- 分支与基线：`codex/chore/project-workflow-upgrade-v1-2-20260914`，实现提交 `d68030f53ddb171c7a879ba677ee4604e61ea970`，基线 `68ab54439f8e859779844ef4e6723f24e3545d25`
- Goal/Design（目标/设计）：本目录下的 `goal.md`、`design.md`、`plan.md`
- 最后验证证据：`evidence/upgrade-validation.md`（开发验证，非独立测试）
- 允许路径：`docs/agent.md`、`project-docs/`
- 禁止路径：`src/`、`tests/`、`calculator.pro`、`docs/ai-workflow/`、远程仓库
- 未解决发现：无
- 后续动作：在冻结实现提交 `d68030f53ddb171c7a879ba677ee4604e61ea970` 上执行独立测试。
- 仍需批准：任何源码、架构、依赖、发布、远程或流程规则变更。
- 停止条件：发现路径越界、版本冲突、历史记录被覆盖、冻结提交发生变化或批准范围变化。

交接指令：`$development-os-v1-2 独立测试 项目流程升级到 Development OS v1.2 project-docs/tasks/project-workflow-upgrade-v1-2-20260914/`
