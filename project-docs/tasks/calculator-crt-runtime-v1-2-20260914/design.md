# Design（设计）：calculator-crt-runtime-v1-2-20260914

## Context and constraints（上下文与约束）

现有 `calculator.pro` 已在 Release 链接后复制 CRT，但 `.gitignore` 排除了 DLL，导致独立工作树和干净克隆没有这些运行库；当前 Qt 分发的 `windeployqt` 也未复制 Qt5Core 依赖的 `zlib.dll`。迁移记录还保存了不匹配的 `docs/agent.md` 冻结哈希。

## Alternatives considered（备选方案）

- 要求用户先安装 VC Redist：不能满足解压即运行的发布约定，放弃。
- 将 DLL 仅放入生成目录：不可追踪、干净克隆无法复现，放弃。
- 跟踪三枚 CRT DLL、补充 zlib 发布白名单并保留现有 qmake 复制逻辑：改动最小、可复现，选用。

## Selected approach and trade-offs（选定方案与权衡）

为运行时 DLL 增加 `.gitignore` 例外并纳入仓库；使用独立工作树执行 Release 构建和载荷重打包。二进制文件会增加仓库体积，但发布可从源码树复现。

## Components and ownership（组件与职责）

`.gitignore` 控制跟踪；`resources/runtime/win-x64/` 保存 Microsoft CRT 与 zlib；`calculator.pro` 的既有 `QMAKE_POST_LINK` 负责复制 CRT；`Package-Release.ps1` 白名单负责打包；迁移 YAML 保存基线哈希。

## Interfaces and data flow（接口与数据流）

CRT 文件 -> qmake Release 输出目录 -> `Package-Release.ps1` -> `release/Payload.zip` -> 隔离目录启动检查。

## Error handling and recovery（错误处理与恢复）

构建、打包或启动失败时保留日志并将任务标记为 `BLOCKED`/`FAIL`；不回写主工作树。可删除任务分支提交并恢复迁移记录到修正前哈希。

## Security and authorization impact（安全与授权影响）

仅纳入微软可再分发运行库，不引入权限或网络行为；不执行安装器，不修改系统组件。

## Testing strategy（测试策略）

独立工作树记录 before/after Git 快照；执行 Release 构建、Engine 测试、载荷哈希/成员检查和最小 PATH 启动。缺少 MSVC 工具链按质量门禁记录为 `BLOCKED`。

## Rollback strategy（回滚策略）

恢复 `.gitignore` 例外、删除三枚新增跟踪文件、恢复迁移哈希并保留测试证据；不触碰主工作树。

## User confirmation（用户确认）

- Status（状态）：`CONFIRMED`（已确认）
- Decision event（决策事件）：`goal-approval-calculator-crt-runtime-20260914`
