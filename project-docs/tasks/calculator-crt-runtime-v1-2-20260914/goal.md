# Goal Decision Record（目标决策记录）：calculator-crt-runtime-v1-2-20260914

- Goal version（目标版本）：1
- Status（状态）：`LOCKED`（已锁定）
- Outcome（结果）：Release 计算器发布目录和载荷显式携带 MSVC x64 CRT DLL 及 Qt5Core 所需 zlib.dll，v1.2 迁移记录的冻结快照哈希修正为基线内容哈希，并以独立工作树构建和独立测试复测证明交付可启动。
- Verification surface（验证面）：独立工作树 Git 差异、Release qmake/nmake 日志、Engine 测试日志、发布载荷清单/哈希、最小 PATH 启动结果和迁移记录哈希校验。
- Scope（范围）：`.gitignore`、`calculator.pro`、`resources/runtime/win-x64/`、`scripts/release/Package-Release.ps1`、`release/Payload.zip`、迁移记录及本任务记录；不改业务源码行为。
- Constraints（约束）：主工作树保持不变；不修改远程；不运行真实系统级 VC Redist 安装；若工具链不可用则记录 `BLOCKED`，不得伪报通过。
- Stop condition（停止条件）：发现工作树混入主工作树改动、允许路径外文件变化、CRT 文件无法核验、构建工具缺失或启动仍为缺失依赖时停止并记录阻塞。
- Open questions（开放问题）：无
- User decision（用户决定）：批准“王晨扬的计算器｜在 resources/runtime/win-x64 纳入 MSVC x64 CRT DLL 文件，修正 v1.2 迁移记录的冻结快照哈希，并在独立工作树重建 Release 应用后执行独立测试复测”（2026-09-14）。
- Decision event（决策事件）：`goal-approval-calculator-crt-runtime-20260914`
