# 独立测试复测：CRT 运行时冻结交接

- 测试会话：`session-20260914-independent-test-f005-03`
- 来源会话：`session-20260914-crt-tracking-repair`
- 测试对象：`43a17e84682e03949c3472903a13ea5aa18f1738`
- `handoff_commit`（交接提交）：`76537ad041e0723554d34150e28f1a546f8c8a81`
- `handoff_timestamp`（交接时间）：`2026-09-14T21:05:37+08:00`
- `handoff_manifest_hash`（交接清单安全散列）：`sha256:243988fa76df8723554a6a991fe12eaa942b2cac505bb773bf1ec7612dd90855`
- 测试运行时根：`C:\t\s3`（隔离工作树）、`C:\t\b3`（构建目录）和 `C:\t\r3`（运行时目录）
- 结论：`BLOCKED`（阻塞）

## 已通过校验

| 校验项 | 结果 | 证据 |
| --- | --- | --- |
| 新鲜会话与隔离工作树 | `PASS`（通过） | 测试会话与修复会话不同；检出后 `git status --short`、`git diff --name-only` 均无输出。 |
| 新冻结交接 | `PASS`（通过） | `76537ad` 是测试对象祖先，任务清单 SHA-256 与交接记录一致。 |
| CRT 载荷纳入 | `PASS`（通过） | Git 树包含三项 DLL；SHA-256 与 F-005 已记录值一致。 |
| build（构建） | `PASS`（通过） | Release qmake/nmake 退出码 `0`，并复制三项 CRT DLL。 |
| full_test（完整测试） | `PASS`（通过） | `tests/engine` 输出 `All CalculatorEngine tests passed.`，退出码 `0`。 |
| typecheck（类型检查） | `NOT_APPLICABLE`（不适用） | 质量配置为 `DISABLED`（禁用）。 |
| browser（浏览器） | `NOT_APPLICABLE`（不适用） | Qt Widgets 桌面应用，质量配置为 `DISABLED`（禁用）。 |
| static_analysis（静态分析） | `SKIPPED`（跳过） | 质量配置为 `OPTIONAL`（可选）。 |
| performance（性能） | `SKIPPED`（跳过） | 质量配置为 `OPTIONAL`（可选）。 |
| task_test（任务测试） | `BLOCKED`（阻塞） | 功能标记均通过，但 `Test-F005ReleasePackage.ps1` 在清理临时目录时稳定报 `qwindows.dll` 访问被拒绝，未能无错误结束。 |
| failure_scenario（失败场景） | `PASS`（通过） | 不复制 `VCRUNTIME140.dll` 的隔离 Release 目录被打包脚本以明确错误拒绝。 |
| full_regression（完整回归） | `BLOCKED`（阻塞） | F-001 至 F-004 采用用户已确认的人工回归证据；F-005 功能检查通过，但必需任务测试门禁未能无错误结束。 |

## 安装器来源与使用

- 来源：`C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Redist\MSVC\v143\vc_redist.x64.exe`，Microsoft 签名有效，版本 `14.44.35211.0`，SHA-256 为 `CC0FF0EB1DC3F5188AE6300FAEF32BF5BEEBA4BDD6E8E445A9184072096B713B`。
- 生成：Release 构建只复制三项 CRT DLL；`windeployqt --release --compiler-runtime` 从 Visual Studio Redist 复制安装器至 Release 目录。
- 打包：`Package-Release.ps1` 将该文件作为白名单与必需文件写入 Payload ZIP。
- 安装：`Install-Calculator.ps1` 解压后以 `/install /quiet /norestart` 运行安装器，退出码 `0` 和 `3010` 视为成功，其他退出码报错。

## 测试脚本阻塞与边界

首次部署命令遗漏 `--compiler-runtime`，因而错误地报告安装器缺失；该命令错误不属于冻结提交或产品缺陷。使用正确参数重跑后，安装器复制、ZIP 路径回归、隔离启动和缺失 DLL 失败路径均通过。

`Test-F005ReleasePackage.ps1` 在 `Stop-Process` 后立刻递归删除临时目录，稳定遇到 `platforms/qwindows.dll` 文件仍被占用。功能断言已输出 `F005_RELEASE_PACKAGE_REGRESSION: PASS`，但清理异常使脚本不能作为通过的必需门禁。测试节点未修改源码、配置、既有测试、Git 历史或任务状态。

临时工作树和构建目录保留在会话专属目录，清理状态为 `PENDING`（待处理），由后续控制器在投影证据后清理。
