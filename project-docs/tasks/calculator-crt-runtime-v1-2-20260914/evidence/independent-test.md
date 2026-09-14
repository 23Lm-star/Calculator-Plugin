# 独立测试复测证据

- 测试会话：`session-20260914-calculator-crt-runtime-independent-test`
- 工作树：`E:/qt/project1-crt-worktree`
- 基线提交：`0192c57ed9626259e317b9f064a14f023cad026f`
- 测试时间：2026-09-14 15:45（+08:00）

## 质量门禁

| 门禁 | 结果 | 命令/证据 |
| --- | --- | --- |
| Build（构建） | PASS（通过） | `vcvars64.bat`、`qmake ..\\..\\calculator.pro -spec win32-msvc CONFIG+=release`、`nmake /f Makefile.Release`；输出 `WangChenyangCalculator.exe` 并复制四个运行库 DLL |
| Full test（全量测试） | PASS（通过） | Engine Release 构建与 `release\\engine_tests.exe`；输出 `All CalculatorEngine tests passed.` |
| Task test（任务测试） | PASS（通过） | 三枚 CRT 路径可跟踪，SHA-256：`MSVCP140.dll=0F885B509A685D2BBFA652FED26B5FB31D88FBDAB0A978C641D1C7B8AA460AA9`、`VCRUNTIME140.dll=1F2D41C4AA5DB0BC33EBF7B66D72943A817D7CE6CBE880502A9403823633093F`、`VCRUNTIME140_1.dll=D5E4D9A3E835FA679450145D6A7D94E36573A509317111904D9B3712C30D9066` |
| Failure scenario（失败场景） | PASS（通过） | `Package-Release.ps1 -Version 1.2.0` 生成载荷；ZIP 20 个成员，包含三枚 CRT、`zlib.dll`、Qt DLL、平台插件和 `vc_redist.x64.exe`；载荷 SHA-256：`4CE1C5F626C791B6C70861ED0C3DB7D2B03768C1F61847C718348F8571FFD203` |
| Isolated launch（隔离启动） | CONDITIONAL（条件通过） | 使用受控 PATH（含 Qt 分发运行库目录）时应用持续运行 3 秒后受控终止；仅 Windows 系统 PATH 时宿主机缺少 UCRT API-set，退出 `-1073741515`（`0xC0000135`），记录为环境限制。 |
| Typecheck（类型检查） | NOT_APPLICABLE（不适用） | 质量配置为 `DISABLED`（禁用）；批准人：王晨扬。 |
| Browser（浏览器） | NOT_APPLICABLE（不适用） | Qt Widgets 桌面应用；质量配置为 `DISABLED`（禁用）。 |

## 迁移哈希

从基线 `68ab54439f8e859779844ef4e6723f24e3545d25` 读取 `docs/agent.md` 原始字节，SHA-256 为 `028b00bddde12c5e1c612747d78939a7dcf52e30c3b07f3a12844f8cc9c1dd4b`，与迁移记录修正值一致。

## Git 边界

开发前后仅允许路径发生变化：`.gitignore`、`calculator.pro`、`resources/runtime/win-x64/`、`scripts/release/Package-Release.ps1`、`release/Payload.zip`、迁移记录和本任务记录。主工作树未被修改。

## 结论

CRT 文件已纳入版本控制并进入 Release 输出和载荷；构建、Engine、任务和失败场景门禁通过。隔离启动在受控 PATH 通过，在宿主机缺少 UCRT API-set 的极简 PATH 下按条件通过记录；未执行真实系统级 VC Redist 安装。
