# 项目工程说明

## 项目目标

交付“王晨扬的计算器”，以 Qt Widgets 展示 MVC 分层：UI 呈现、控制流和计算逻辑相互隔离。

## 目录职责

- `src/model`：不依赖 Qt 的计算逻辑与表达式解析。
- `src/view`：Qt Widgets 页面、布局和显示状态。
- `src/controller`：View 与 Model 的输入编排、校验和错误反馈。
- `tests/engine`：不链接 Qt 的 Model 独立编译与单元测试。
- `docs/ai-workflow`：Development OS 的任务和交付记录。

## 技术基线

- Qt 5.9.5 Widgets，qmake，Visual Studio 2022 C++ 工具链。
- C++11；不使用第三方库。
- 工程入口：`calculator.pro`。

## 开发规范

- Model 禁止包含 Qt 头文件或使用 Qt 类型。
- 所有业务功能变更同步更新本文件及对应任务记录。
- 先完成开发报告，再进入独立测试；测试、审计阶段只写各自报告和证据。
