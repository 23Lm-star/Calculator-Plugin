# Next Session Prompt（下一会话提示）

- 项目根目录：`E:/qt/project1`
- 流程版本：`v1.2`
- 任务：`project-workflow-upgrade-v1-2-20260914`（项目流程升级到 Development OS v1.2）
- 当前状态：`ACTIVE`（开发完成，待独立测试）
- 分支与基线：`codex/release-delivery-v1.0`，`68ab54439f8e859779844ef4e6723f24e3545d25`
- Goal/Design（目标/设计）：本目录下的 `goal.md`、`design.md`、`plan.md`
- 最后验证证据：`evidence/upgrade-validation.md`（开发验证，非独立测试）
- 允许路径：`docs/agent.md`、`project-docs/`
- 禁止路径：`src/`、`tests/`、`calculator.pro`、`docs/ai-workflow/`、远程仓库
- 未解决发现：无
- 后续动作：创建专用任务分支或授权仅暂存本任务允许路径后生成冻结提交，再进入独立测试。
- 仍需批准：专用分支创建或冻结提交；任何源码、架构、依赖、发布、远程或流程规则变更。
- 停止条件：发现路径越界、版本冲突、历史记录被覆盖、用户改动混入提交或批准范围变化。

交接指令：`$development-os-v1-2 独立测试 项目流程升级到 Development OS v1.2 project-docs/tasks/project-workflow-upgrade-v1-2-20260914/`
