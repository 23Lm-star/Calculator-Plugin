# 下一会话：独立审计

- 项目根目录：`E:/qt/project1-crt-worktree`
- 工作流版本：`v1.2`
- 任务：`calculator-crt-runtime-v1-2-20260914`（王晨扬的计算器：纳入 MSVC x64 CRT 并复测发布包）
- 当前状态：`TESTING`（独立测试条件通过，待审计）
- 分支/冻结提交：`codex/calculator-crt-runtime-v1-2-20260914` / `8ffe17c`
- Goal/Design：`goal.md`、`design.md`、`plan.md`
- 最后验证证据：`evidence/independent-test.md`
- 允许路径：`.gitignore`、`calculator.pro`、`resources/runtime/win-x64/`、`scripts/release/Package-Release.ps1`、`release/Payload.zip`、迁移记录、本任务记录和 `project-docs/ai-workflow/`
- 禁止路径：`src/`、`tests/`、`remote`
- 未解决风险：未执行真实系统级 VC Redist；宿主机极简 PATH 缺少 UCRT API-set。
- 必需动作：读取测试证据，复核差异、架构/依赖边界、哈希和门禁，完成独立审计和人工确认。
- 仍需批准：独立审计结论及后续集成候选验证。
- 停止条件：发现未授权修改、冻结提交变化或阻塞审计发现。

交接指令：执行独立审计
