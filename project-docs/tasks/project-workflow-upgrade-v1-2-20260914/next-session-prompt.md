# Next Session Prompt（下一会话提示）

- 项目根目录：`E:/qt/project1`
- 流程版本：`v1.2`
- 任务：`project-workflow-upgrade-v1-2-20260914`（项目流程升级到 Development OS v1.2）
- 当前状态：`ACTIVE`（F-005 清理修复已冻结到 `80bdb57`，待独立测试复测）
- 分支与基线：`codex/project-workflow-upgrade-v1-2-freeze-20260914`，`68ab54439f8e859779844ef4e6723f24e3545d25`；冻结提交：`80bdb5750cfb869a13a91339dc10eb69520dcd8f`
- Goal/Design（目标/设计）：本目录下的 `goal.md`、`design.md`、`plan.md`
- 最后验证证据：`修复报告-20260914.md`、`evidence/test/package-release-archive-path-20260914.log`、`evidence/test/release-build-f005-20260914.log`、`evidence/test/qt-deploy-f005-20260914.log`、`evidence/test/f005-release-package-20260914.log`
- 允许路径：`docs/agent.md`、`project-docs/`、`resources/runtime/win-x64/`、`scripts/release/Package-Release.ps1`、两份 `project-tools/test-scripts/` 测试脚本与既有忽略的构建/产物输出。
- 禁止路径：`src/`、`tests/`、`calculator.pro`、`docs/ai-workflow/`、远程仓库和 `main`。
- 未解决发现：发布包 ZIP 路径分隔符发现已修复；F-001 至 F-004 已由用户人工复验并有历史本地集成证据。
- 后续动作：在新鲜隔离工作树中针对冻结提交 `80bdb57` 执行独立测试；仅写入 `evidence/test/`，不得改源码、配置、既有测试或 Git 历史。
- 人工审计检查项：确认进程终止后等待 `WaitForExit(10000)`（最多等待 10 秒）；确认 `finally`（最终清理块）会兜底终止、等待并释放进程对象；确认临时目录删除有 10 次重试且失败会报错；确认 F-005、ZIP 路径回归、Engine 全量测试和临时目录零残留证据；确认未触碰 `src/`、`tests/`、`calculator.pro`、`docs/ai-workflow/`。
- 人工审计确认格式（通过）：`人工审计确认：通过｜范围=F-005 进程退出等待与临时目录清理｜证据已核阅｜接受当前修复｜仍需冻结快照后再进入集成`
- 人工审计确认格式（阻塞）：`人工审计确认：阻塞｜原因=<具体原因>｜不接受进入集成`
- 仍需批准：任何源码、架构、依赖、集成、发布、远程或 `main` 变更；人工审计通过本身不等于这些动作获批。
- 停止条件：发现路径越界、版本冲突、历史记录被覆盖、用户改动混入提交或批准范围变化。

交接指令：`$development-os-v1-2 独立测试 项目流程升级到 Development OS v1.2 project-docs/tasks/project-workflow-upgrade-v1-2-20260914/`
