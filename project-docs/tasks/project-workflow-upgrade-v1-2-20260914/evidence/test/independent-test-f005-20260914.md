# 独立测试：F-005 冻结交接

- 测试会话：`session-20260914-independent-test-f005-01`
- 来源会话：`session-20260914-package-whitelist-repair`
- 测试对象：`82ab1575d7dc33ba37714c828cd77413858be168`（交接元数据提交）
- `handoff_commit`（交接提交）：`7a1ef9d013189cac00189df9073147a3f490c45d`
- `handoff_timestamp`（交接时间）：`2026-09-14T20:52:06+08:00`
- `handoff_manifest_hash`（交接清单安全散列）：`sha256:93153e918e7d6bd7377a656ea91550141df6b1d7ab624d242091b33de3d4c9b2`
- 测试运行时根：`C:\t\development-os\wangchenyang-calculator\project-workflow-upgrade-v1-2-20260914\session-f005-01\`
- 结论：`BLOCKED`（阻塞）

## 前置与隔离校验

| 校验项 | 结果 | 证据 |
| --- | --- | --- |
| 新鲜会话 | `PASS`（通过） | 本测试会话 ID 与来源会话不同。 |
| 冻结提交关系 | `PASS`（通过） | `7a1ef9d` 是测试对象 `82ab157` 的祖先。 |
| 交接清单安全散列 | `PASS`（通过） | 从冻结提交读取的 `manifest.yaml` SHA-256 为登记值。 |
| 隔离工作树 | `PASS`（通过） | `git status --short` 与 `git diff --name-only` 均无输出。 |
| 允许路径 | `PASS`（通过） | 相对基线差异位于任务允许路径；未改变 `src/`、`tests/`、`calculator.pro` 或 `docs/ai-workflow/`。 |
| 主工作区隔离 | `PASS`（通过） | 既有未提交改动保持原状，测试只写入本证据文件。 |

## 质量门禁

| 门禁 | 结果 | 命令/场景 | 退出码 | 说明 |
| --- | --- | --- | --- | --- |
| build（构建） | `BLOCKED`（阻塞） | `qmake calculator.pro -spec win32-msvc "CONFIG+=release" && nmake -f Makefile.Release` | `3` | 冻结提交不含 `resources/runtime/win-x64/` 的 MSVC CRT DLL，qmake 报告运行时文件缺失。 |
| typecheck（类型检查） | `NOT_APPLICABLE`（不适用） | 质量配置 `DISABLED`（禁用） | `null` | C++/qmake 无独立类型检查工具；批准人见 `quality-profile.yaml`。 |
| static_analysis（静态分析） | `SKIPPED`（跳过） | 未执行 | `null` | 质量配置为 `OPTIONAL`（可选），本轮阻塞于可复现的冻结载荷缺失。 |
| full_test（完整测试） | `PASS`（通过） | `qmake tests/engine/engine_tests.pro -spec win32-msvc "CONFIG+=release" && nmake -f Makefile.Release && release/engine_tests.exe` | `0` | 输出 `All CalculatorEngine tests passed.` |
| task_test（任务测试） | `BLOCKED`（阻塞） | `Test-PackageReleaseArchivePath.ps1`、`Test-F005ReleasePackage.ps1` | `null` | 两份脚本均需要成功的 Release 载荷；构建门禁未满足。 |
| browser（浏览器） | `NOT_APPLICABLE`（不适用） | 质量配置 `DISABLED`（禁用） | `null` | Qt Widgets 桌面应用无浏览器路径。 |
| performance（性能） | `SKIPPED`（跳过） | 未执行 | `null` | 质量配置为 `OPTIONAL`（可选），本修复不改变性能路径。 |
| failure_scenario（失败场景） | `BLOCKED`（阻塞） | 缺失 DLL 发布包失败场景 | `null` | 无可执行的 Release 载荷，不能建立隔离发布包失败场景。 |
| full_regression（完整回归） | `BLOCKED`（阻塞） | `regression/功能回归清单.yaml` | `null` | F-005 依赖 F-001 至 F-004，且其 Release 包无法从冻结提交构建。 |

## 发现

- `F-006`（待控制器登记）：冻结提交未跟踪三项必需运行时文件 `MSVCP140.dll`、`VCRUNTIME140.dll` 与 `VCRUNTIME140_1.dll`。主工作区文件存在，但被 `.gitignore` 的 `*.dll` 规则忽略，`git ls-tree -r 7a1ef9d -- resources/runtime/win-x64` 无输出。
- 最小复现：在干净工作树检出 `82ab157`，在仓库外构建目录执行 Release qmake；qmake 以退出码 `3` 报告 `MSVC CRT runtime files are missing from resources/runtime/win-x64`。
- 影响：F-005 的发布包、隔离启动及失败路径均不能针对冻结对象复现；独立测试结论不可通过。

## 测试边界与后续动作

本测试未修改源码、运行时配置、既有测试、任务清单、流程状态或 Git 历史。临时工作树和构建目录保留在会话专属目录，清理状态为 `PENDING`（待处理），由后续控制器在投影证据后清理。恢复路径为：在开发/修复节点确认三项 CRT DLL 的可追溯来源和纳入策略，形成新的冻结提交后，从新交接重新执行独立测试。
