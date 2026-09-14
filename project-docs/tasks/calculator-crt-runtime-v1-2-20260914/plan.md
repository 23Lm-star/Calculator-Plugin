# Plan（计划）：calculator-crt-runtime-v1-2-20260914

- Goal ref（目标引用）：`project-docs/tasks/calculator-crt-runtime-v1-2-20260914/goal.md`
- Design ref（设计引用）：`project-docs/tasks/calculator-crt-runtime-v1-2-20260914/design.md`
- Branch（分支）：`codex/calculator-crt-runtime-v1-2-20260914`

## Behavior unit BU-01（行为单元）: CRT 文件可追踪

- Input（输入）：三个现有 MSVC x64 CRT DLL。
- Expected behavior（预期行为）：Git 状态显示三个 DLL 为允许路径新增文件。
- Files allowed to change（允许修改）：`.gitignore`、`resources/runtime/win-x64/`、`scripts/release/Package-Release.ps1`。
- Verification（验证）：`git check-ignore`、`git ls-files`、SHA-256。
- Expected failing result（预期失败结果）：未加例外时 DLL 被忽略。
- Expected passing result（预期通过结果）：例外生效且文件可加入索引。
- Completion condition（完成条件）：三枚 DLL 路径和哈希记录齐全。

## Behavior unit BU-02（行为单元）: Release 载荷可启动

- Input（输入）：独立工作树 Release 构建输出。
- Expected behavior（预期行为）：输出目录和 ZIP 含 CRT，最小 PATH 启动不再因 CRT 缺失失败。
- Files allowed to change（允许修改）：`release/Payload.zip`、本任务证据目录。
- Verification（验证）：qmake/nmake、Engine 测试、Package-Release、ZIP 清单和启动检查。
- Expected failing result（预期失败结果）：无 CRT 时启动返回 `0xC0000135`。
- Expected passing result（预期通过结果）：CRT 文件存在且启动检查通过，或环境阻塞被如实记录。
- Completion condition（完成条件）：所有适用必需门禁有 PASS/FAIL/BLOCKED 证据。

## Behavior unit BU-03（行为单元）: 迁移冻结哈希一致

- Input（输入）：基线提交中的 `docs/agent.md` 内容。
- Expected behavior（预期行为）：迁移 YAML 的冻结哈希等于基线内容 SHA-256。
- Files allowed to change（允许修改）：`project-docs/migrations/v1-1-to-v1-2-20260914.yaml`。
- Verification（验证）：从 Git 基线读取 blob 并计算 SHA-256。
- Expected failing result（预期失败结果）：旧值 `41c7...` 与基线不一致。
- Expected passing result（预期通过结果）：值为基线原始字节哈希 `028b00...`。
- Completion condition（完成条件）：哈希校验和迁移证据同步更新。
