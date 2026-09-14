# 项目工程说明

## 项目目标

交付“王晨扬的计算器”，以 Qt Widgets 展示 MVC 分层：UI 呈现、控制流和计算逻辑相互隔离。

## 目录职责

- `src/model`：不依赖 Qt 的计算逻辑与表达式解析。
- `src/config`：基于 QSettings 的本地用户与外观配置，不参与计算逻辑。
- `src/view`：Qt Widgets 页面、布局和显示状态。
- `src/controller`：View 与 Model 的输入编排、校验和错误反馈。
- `tests/engine`：不链接 Qt 的 Model 独立编译与单元测试。
- `project-docs/`：Development OS v1.2（开发流程）规范目录；旧版 `docs/ai-workflow/`（历史流程记录）只读保留。

## 技术基线

- Qt 5.9.5 Widgets，qmake，Visual Studio 2022 C++ 工具链。
- C++11；不使用第三方库。
- 工程入口：`calculator.pro`。
- v1.1 通过同源 `.ico` 资源统一 EXE、任务栏和窗口图标；窗口固定为 600x800。
- v1.1 用户名与主题配置存储在应用目录的 `calculator.ini`；默认主题为 Ocean、Forest、Sunset，也可选择本地图片。

## 开发规范

- Model 禁止包含 Qt 头文件或使用 Qt 类型。
- 配置持久化限定在 `src/config/ConfigManager`，Controller 负责调用，View 仅负责输入与渲染。
- 所有业务功能变更同步更新本文件及对应任务记录。
- 先完成开发报告，再进入独立测试；测试、审计阶段只写各自报告和证据。

## 流程版本

- 当前项目流程版本：`v1.2`（Development OS v1.2，受控开发流程）。
- v1.2 规范入口：`project-docs/agent.md`（项目流程规则）。
- 项目清单：`project-docs/project-manifest.yaml`；质量门禁：`project-docs/quality-profile.yaml`。
- 旧流程记录：`docs/ai-workflow/`，作为迁移前历史证据保留，不再作为新任务写入入口。
