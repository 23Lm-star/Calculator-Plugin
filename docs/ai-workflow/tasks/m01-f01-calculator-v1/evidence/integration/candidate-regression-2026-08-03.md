# 本地集成候选回归证据

- 日期：2026-08-03
- 候选来源：`codex/m01-f01-calculator-v1`，候选提交 `fafe1ce5de4ad2116ad2e4971f70aeddc5e72b30`。
- 集成基线：`integration`，合并前提交 `e2ce7e60459f80f54475b9379d9dcc31555f6afa`。
- 候选方式：在 `C:\tmp\m01-f01-calculator-v1-integration-candidate` 从 `integration` 创建隔离工作树，执行 `git merge --no-commit --no-ff codex/m01-f01-calculator-v1`；无冲突，退出码 `0`。

| 检查 | 完整命令 | 退出码 | 结果 |
| --- | --- | --- | --- |
| Qt 版本 | `C:\ProgramData\Anaconda31\Library\bin\qmake.exe -query QT_VERSION` | 0 | `5.9.5` |
| 应用 Release 构建 | `call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" && cd /d "C:\tmp\m01-f01-calculator-v1-integration-candidate\build\app" && "C:\ProgramData\Anaconda31\Library\bin\qmake.exe" ..\..\calculator.pro && nmake /nologo /f Makefile.Release` | 0 | 通过；日志见 `app-regression-2026-08-03.log` |
| Engine 构建与测试 | `call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat" && cd /d "C:\tmp\m01-f01-calculator-v1-integration-candidate\tests\engine" && "C:\ProgramData\Anaconda31\Library\bin\qmake.exe" engine_tests.pro && nmake /nologo /f Makefile.Release && release\engine_tests.exe` | 0 | 通过；输出 `All CalculatorEngine tests passed.`；日志见 `engine-regression-2026-08-03.log` |
| 候选差异检查 | `git -C "C:\tmp\m01-f01-calculator-v1-integration-candidate" diff --check` | 0 | 通过 |

## UI 自动化补强

已用 Windows 应用自动化启动候选可执行文件 `build\app\release\WangChenyangCalculator.exe`。候选进程未稳定保留可绑定窗口，且桌面已有同标题的用户调试实例；为防止把用户实例误计为候选构建证据，未保存截图，也未将该检查报告为通过。该证据缺口不影响编译和 Engine 回归结论，保留为本地交付后的残余风险。
