# Next Session Prompt（下一会话提示）

- 项目根目录：`E:/qt/project1`
- 流程版本：`v1.2`
- 任务：`project-workflow-upgrade-v1-2-20260914`（项目流程升级到 Development OS v1.2）
- 当前状态：`ACTIVE`（CRT 运行时已纳入冻结提交，待独立测试复测）
- 分支与基线：`codex/release-delivery-v1.0`，`68ab54439f8e859779844ef4e6723f24e3545d25`；冻结提交：`76537ad041e0723554d34150e28f1a546f8c8a81`
- Goal/Design（目标/设计）：本目录下的 `goal.md`、`design.md`、`plan.md`
- 最后验证证据：`修复报告-20260914.md`、`evidence/test/package-release-archive-path-20260914.log`、`evidence/test/release-build-f005-20260914.log`、`evidence/test/qt-deploy-f005-20260914.log`、`evidence/test/f005-release-package-20260914.log`
- 允许路径：`docs/agent.md`、`project-docs/`、`resources/runtime/win-x64/`、`scripts/release/Package-Release.ps1`、两份 `project-tools/test-scripts/` 测试脚本与既有忽略的构建/产物输出。
- 禁止路径：`src/`、`tests/`、`calculator.pro`、`docs/ai-workflow/`、远程仓库和 `main`。
- 未解决发现：发布包 ZIP 路径分隔符发现已修复；F-001 至 F-004 已由用户人工复验并有历史本地集成证据。
- 后续动作：在隔离工作树中针对冻结提交执行独立测试；仅写入 `evidence/test/`，不得改源码、配置、既有测试或 Git 历史。
- 仍需批准：任何源码、架构、依赖、集成、发布、远程或 `main` 变更。
- 停止条件：发现路径越界、版本冲突、历史记录被覆盖、用户改动混入提交或批准范围变化。

交接指令：`$development-os-v1-2 独立测试 项目流程升级到 Development OS v1.2 project-docs/tasks/project-workflow-upgrade-v1-2-20260914/`
