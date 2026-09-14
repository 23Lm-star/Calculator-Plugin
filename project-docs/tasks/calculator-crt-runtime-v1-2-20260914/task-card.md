# 王晨扬的计算器：纳入 MSVC x64 CRT 并复测发布包

- Internal ID（内部 ID）：`calculator-crt-runtime-v1-2-20260914`
- Workflow version（流程版本）：`v1.2`
- Status（状态）：`CONFIRMED`（已确认）
- Business objective（业务目标）：使解压后的 Release 计算器在未安装 Visual Studio 的 Windows x64 环境中可直接启动，并修正 v1.2 迁移冻结快照哈希。
- Users or affected actors（用户/受影响角色）：计算器最终用户、发布维护者、独立测试者。
- Priority（优先级）：高
- In scope（范围内）：纳入 `resources/runtime/win-x64/` 的 MSVC x64 CRT DLL；补齐 Qt5Core 所需 `zlib.dll` 发布白名单；更新 `.gitignore` 例外；修正迁移记录中的冻结快照哈希；在独立工作树重建 Release 应用和发布载荷；执行独立测试复测并记录证据。
- Explicitly out of scope（范围外）：计算逻辑、UI、配置协议、权限模型、远程仓库、系统级 VC Redist 安装。
- Acceptance criteria（验收标准）：三枚 DLL 被 Git 跟踪；Release 输出含三枚 DLL；载荷包含三枚 DLL；无开发工具链环境启动检查不再因 CRT 缺失失败；迁移冻结哈希与基线内容一致；独立测试必需门禁均有结果。
- Dependencies（依赖）：v1.2 迁移任务 `project-workflow-upgrade-v1-2-20260914`；Qt 5.9.5 与 MSVC x64 构建工具；现有发布脚本。
- Non-negotiable constraints（不可妥协约束）：独立工作树构建；不覆盖主工作树用户未提交改动；不修改远程；不执行真实系统级 VC Redist 安装。
- Allowed paths（允许路径）：`.gitignore`、`calculator.pro`、`resources/runtime/win-x64/`、`scripts/release/Package-Release.ps1`、`release/Payload.zip`、`project-docs/migrations/v1-1-to-v1-2-20260914.yaml`、`project-docs/ai-workflow/`、`project-docs/tasks/calculator-crt-runtime-v1-2-20260914/`。
- Test requirements（测试要求）：Release qmake/nmake 构建、Engine 全量测试、载荷成员/哈希检查、最小 PATH 启动检查、Git 路径边界检查。
- Risk level（风险级别）：medium（中）
- Approval-needed actions（需批准动作）：依赖二进制纳入、迁移哈希修正、独立工作树 Release 重建和复测，已获王晨扬批准。
- Open questions（开放问题）：无
