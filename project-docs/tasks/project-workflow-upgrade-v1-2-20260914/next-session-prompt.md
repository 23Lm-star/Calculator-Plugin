# Next Session Prompt（下一会话提示）

- 项目根目录：`E:/qt/project1`
- 流程版本：`v1.2`
- 任务：`project-workflow-upgrade-v1-2-20260914`（项目流程升级到 Development OS v1.2）
- 当前状态：`BLOCKED`（本地集成候选完整回归未通过）
- 候选分支与基线：`codex/integration-candidate-workflow-upgrade-v1-2-20260914`，`03dc19823dac7c31a8791e893c41f4d8e039c0d6`
- Goal/Design（目标/设计）：本目录下的 `goal.md`、`design.md`、`plan.md`
- 最后验证证据：`集成回归报告.md`、`独立测试报告-候选提交.md`、`独立审计报告-候选提交.md`
- 允许路径：`docs/agent.md`、`project-docs/`
- 禁止路径：`src/`、`tests/`、`calculator.pro`、`docs/ai-workflow/`、远程仓库
- 未解决发现：Release 构建缺少 `resources/runtime/win-x64`；人工 GUI 证据已通过 F-001 和 F-003，仍缺 F-002 退格及 F-004 主题/本地图片路径。
- 后续动作：新建独立修复任务并取得对发布运行时资产和测试环境的精确批准；完成后从当前候选基线重跑完整回归。
- 仍需批准：业务资源/发布资产变更、测试环境配置、最终合并到 `integration`；任何远程、`main`、发布或部署动作另需精确批准。
- 停止条件：未解决构建或 GUI 回归阻塞时，不得合并到 `integration`。

交接指令：`$development-os 开发 修复发布运行时资产和桌面回归环境（需新任务卡与精确批准）`
