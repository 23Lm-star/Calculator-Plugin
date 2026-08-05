# Development Evidence | 2026-08-05

## 采集条件

- 工作区：`E:\qt\project1`
- 分支：`codex/calculator-desktop-v1.1`
- 基线提交：`4856482`
- 本记录只整理已存在的源码、构建目录和配置产物；未重跑构建、Engine 测试、`windeployqt` 或 GUI 验收。

## 实现静态证据

| 目标 | 位置 | 观察结果 |
| --- | --- | --- |
| EXE/窗口/任务栏图标 | `calculator.pro`、`resources/resources.qrc`、`src/main.cpp`、`src/view/CalculatorUI.cpp` | 同一 `:/icons/calculator.ico` 由 RC 资源和 Qt 资源引用，并设置为应用与窗口图标。 |
| 固定窗口 | `src/view/CalculatorUI.cpp` | `setFixedSize(600, 800)`。 |
| QSettings 配置 | `src/config/ConfigManager.*` | 应用目录 `calculator.ini`，保存用户名、主题和背景图路径。 |
| 配置编排 | `src/controller/CalculatorController.*` | Controller 负责读取、保存和应用；View 发出主题/背景信号并渲染。 |
| 计算逻辑未改 | `git diff --name-only` | `src/model/` 与 `tests/engine/` 未出现在当前功能 diff。 |

## 构建与 Engine 产物证据

| 检查 | 现有产物 | 时间/状态 | 结论 |
| --- | --- | --- | --- |
| Qt Release 构建 | `build/v1.1-app/release/WangChenyangCalculator.exe`，113,152 bytes | 2026-08-05 16:00:15 | 可执行文件存在；未保留本次命令输出和退出码，独立测试须重建。 |
| Engine 独立构建 | `build/v1.1-engine/release/engine_tests.exe`，25,088 bytes | 2026-08-05 15:49:28 | 测试可执行文件存在；本次未执行，不将结果标记为通过。 |
| 既有测试覆盖 | `tests/engine/main.cpp` | 5 个正常表达式、6 个错误场景 | 用例源码存在且未变更；独立测试须运行并记录 `All CalculatorEngine tests passed.` 与退出码。 |

## windeployqt 部署状态证据

`build/v1.1-app/release/` 中已有 `Qt5Core.dll`、`Qt5Gui.dll`、`Qt5Widgets.dll` 等 11 个顶层 DLL，`platforms/qwindows.dll`，1 个 `iconengines` 插件和 9 个 `imageformats` 插件。该目录结构符合 `windeployqt` 后的 Qt Widgets 运行时布局。

未保留 v1.1 的 `windeployqt` 命令行、参数和退出码；独立测试须在隔离输出目录重新执行部署并核验应用脱离开发环境后可启动。

## 运行时配置验收状态

- `build/v1.1-app/release/calculator.ini.ui-test-backup` 保存了 `userName=CodexTestUser`、`themeId=custom` 和本地背景图路径，修改时间为 15:55:40。
- 当前 `build/v1.1-app/release/calculator.ini` 保存了 `userName=wcy`、`themeId=custom` 和本地背景图路径，修改时间为 16:03:00。
- 该前后配置状态证明至少发生过用户名和自定义背景的持久化写入；不证明完整 GUI 验收通过，因为没有对应启动日志、截图或自动化轨迹。

## 独立测试必收集的补充证据

1. qmake/nmake Release 构建命令、退出码和完整尾部日志。
2. `engine_tests.exe` 输出与退出码。
3. `windeployqt` 命令、退出码和隔离发布目录清单。
4. GUI 截图或窗口自动化轨迹：首次用户名、重启恢复、Ocean/Forest/Sunset、自定义背景、600x800 固定尺寸和统一图标。
5. 测试前后 Git status/diff，确认测试阶段未修改源码或现有测试。
