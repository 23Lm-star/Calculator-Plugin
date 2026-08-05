# Git Snapshot After Independent Test

## git status --short --branch
```text
warning: unable to access 'C:\Users\王晨扬/.config/git/ignore': Permission denied
warning: unable to access 'C:\Users\王晨扬/.config/git/ignore': Permission denied
## codex/calculator-desktop-v1.1
 M calculator.pro
 M docs/agent.md
 M "docs/ai-workflow/\344\273\273\345\212\241\346\200\273\350\247\210.md"
 M "docs/ai-workflow/\351\241\271\347\233\256\346\227\266\351\227\264\346\265\201.md"
 M docs/business-context.md
 M src/controller/CalculatorController.cpp
 M src/controller/CalculatorController.h
 M src/main.cpp
 M src/view/CalculatorUI.cpp
 M src/view/CalculatorUI.h
?? docs/ai-workflow/release-records.md
?? docs/ai-workflow/tasks/m01-f01-calculator-v1/evidence/release-preparation/
?? "docs/ai-workflow/tasks/m01-f01-calculator-v1/\345\217\221\345\270\203\345\200\231\351\200\211\346\212\245\345\221\212.md"
?? docs/ai-workflow/tasks/m01-f02-calculator-desktop-v1-1/
?? resources/
?? src/config/
?? "\347\216\213\346\231\250\346\211\254\347\232\204\350\256\241\347\256\227\345\231\250/"
?? "\351\205\215\347\275\256\346\226\207\344\273\266/"
```

## git diff --stat
```text
warning: in the working copy of 'calculator.pro', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/agent.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/ai-workflow/任务总览.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/ai-workflow/项目时间流.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/business-context.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/controller/CalculatorController.cpp', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/controller/CalculatorController.h', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/main.cpp', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/view/CalculatorUI.cpp', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/view/CalculatorUI.h', LF will be replaced by CRLF the next time Git touches it
 calculator.pro                                     |  6 ++
 docs/agent.md                                      |  4 +
 ...273\273\345\212\241\346\200\273\350\247\210.md" |  1 +
 ...233\256\346\227\266\351\227\264\346\265\201.md" |  4 +
 docs/business-context.md                           |  4 +-
 src/controller/CalculatorController.cpp            | 37 ++++++++-
 src/controller/CalculatorController.h              |  8 +-
 src/main.cpp                                       | 12 ++-
 src/view/CalculatorUI.cpp                          | 96 +++++++++++++++++++---
 src/view/CalculatorUI.h                            |  7 ++
 10 files changed, 157 insertions(+), 22 deletions(-)
```

## git diff --name-only
```text
warning: in the working copy of 'calculator.pro', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/agent.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/ai-workflow/任务总览.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/ai-workflow/项目时间流.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/business-context.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/controller/CalculatorController.cpp', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/controller/CalculatorController.h', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/main.cpp', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/view/CalculatorUI.cpp', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/view/CalculatorUI.h', LF will be replaced by CRLF the next time Git touches it
calculator.pro
docs/agent.md
"docs/ai-workflow/\344\273\273\345\212\241\346\200\273\350\247\210.md"
"docs/ai-workflow/\351\241\271\347\233\256\346\227\266\351\227\264\346\265\201.md"
docs/business-context.md
src/controller/CalculatorController.cpp
src/controller/CalculatorController.h
src/main.cpp
src/view/CalculatorUI.cpp
src/view/CalculatorUI.h
```

## git diff --check
```text
warning: in the working copy of 'calculator.pro', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/agent.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/ai-workflow/任务总览.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/ai-workflow/项目时间流.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/business-context.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/controller/CalculatorController.cpp', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/controller/CalculatorController.h', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/main.cpp', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/view/CalculatorUI.cpp', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/view/CalculatorUI.h', LF will be replaced by CRLF the next time Git touches it
```

## full tracked diff
```diff
warning: in the working copy of 'calculator.pro', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/agent.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/ai-workflow/任务总览.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/ai-workflow/项目时间流.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'docs/business-context.md', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/controller/CalculatorController.cpp', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/controller/CalculatorController.h', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/main.cpp', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/view/CalculatorUI.cpp', LF will be replaced by CRLF the next time Git touches it
warning: in the working copy of 'src/view/CalculatorUI.h', LF will be replaced by CRLF the next time Git touches it
diff --git a/calculator.pro b/calculator.pro
index 442d306..52eb2f1 100644
--- a/calculator.pro
+++ b/calculator.pro
@@ -9,11 +9,17 @@ INCLUDEPATH += $$PWD/src
 
 SOURCES += \
     src/main.cpp \
+    src/config/ConfigManager.cpp \
     src/model/CalculatorEngine.cpp \
     src/view/CalculatorUI.cpp \
     src/controller/CalculatorController.cpp
 
 HEADERS += \
+    src/config/ConfigManager.h \
     src/model/CalculatorEngine.h \
     src/view/CalculatorUI.h \
     src/controller/CalculatorController.h
+
+RC_ICONS = resources/calculator.ico
+
+RESOURCES += resources/resources.qrc
diff --git a/docs/agent.md b/docs/agent.md
index 3fc8229..503576d 100644
--- a/docs/agent.md
+++ b/docs/agent.md
@@ -7,6 +7,7 @@
 ## 目录职责
 
 - `src/model`：不依赖 Qt 的计算逻辑与表达式解析。
+- `src/config`：基于 QSettings 的本地用户与外观配置，不参与计算逻辑。
 - `src/view`：Qt Widgets 页面、布局和显示状态。
 - `src/controller`：View 与 Model 的输入编排、校验和错误反馈。
 - `tests/engine`：不链接 Qt 的 Model 独立编译与单元测试。
@@ -17,9 +18,12 @@
 - Qt 5.9.5 Widgets，qmake，Visual Studio 2022 C++ 工具链。
 - C++11；不使用第三方库。
 - 工程入口：`calculator.pro`。
+- v1.1 通过同源 `.ico` 资源统一 EXE、任务栏和窗口图标；窗口固定为 600x800。
+- v1.1 用户名与主题配置存储在应用目录的 `calculator.ini`；默认主题为 Ocean、Forest、Sunset，也可选择本地图片。
 
 ## 开发规范
 
 - Model 禁止包含 Qt 头文件或使用 Qt 类型。
+- 配置持久化限定在 `src/config/ConfigManager`，Controller 负责调用，View 仅负责输入与渲染。
 - 所有业务功能变更同步更新本文件及对应任务记录。
 - 先完成开发报告，再进入独立测试；测试、审计阶段只写各自报告和证据。
diff --git "a/docs/ai-workflow/\344\273\273\345\212\241\346\200\273\350\247\210.md" "b/docs/ai-workflow/\344\273\273\345\212\241\346\200\273\350\247\210.md"
index 9083d94..060860a 100644
--- "a/docs/ai-workflow/\344\273\273\345\212\241\346\200\273\350\247\210.md"
+++ "b/docs/ai-workflow/\344\273\273\345\212\241\346\200\273\350\247\210.md"
@@ -3,6 +3,7 @@
 | 内部 ID | 任务名称 | 工作流版本 | 状态 | 当前阶段 | 任务卡 |
 | --- | --- | --- | --- | --- | --- |
 | M01-F01 | 应届机试题-计算器业务需求包 v1.0 | v1.0 | 已完成 | 本地集成交付完成 | `tasks/m01-f01-calculator-v1/任务卡.md` |
+| M01-F02 | 计算器桌面化增强与个性化配置 v1.1 | v1.1 | 开发完成，待独立测试 | 开发交接 | `tasks/m01-f02-calculator-desktop-v1-1/任务卡.md` |
 
 ## 需求映射
 
diff --git "a/docs/ai-workflow/\351\241\271\347\233\256\346\227\266\351\227\264\346\265\201.md" "b/docs/ai-workflow/\351\241\271\347\233\256\346\227\266\351\227\264\346\265\201.md"
index 7998e38..0c49795 100644
--- "a/docs/ai-workflow/\351\241\271\347\233\256\346\227\266\351\227\264\346\265\201.md"
+++ "b/docs/ai-workflow/\351\241\271\347\233\256\346\227\266\351\227\264\346\265\201.md"
@@ -10,8 +10,12 @@ gantt
     独立测试 :done, test, after dev, 1d
     独立审计 :done, audit, after test, 1d
     集成交付 :done, delivery, after audit, 1d
+    section M01-F02
+    开发收尾 :active, v11dev, 2026-08-05, 1d
+    独立测试 : v11test, after v11dev, 1d
 ```
 
 | 任务 | 内部 ID | 开始时间 | 最近更新 | 状态 | 当前阶段 | 集成时间 | 完成时间 | 快照标签 | 报告路径 |
 | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
 | 应届机试题-计算器业务需求包 v1.0 | M01-F01 | 2026-08-03 | 2026-08-03 | 已完成 | 本地集成交付完成 | 2026-08-03 | 2026-08-03 | 无（未创建标签） | `tasks/m01-f01-calculator-v1/` |
+| 计算器桌面化增强与个性化配置 v1.1 | M01-F02 | 2026-08-05 | 2026-08-05 | 开发完成，待独立测试 | 开发交接 | - | - | - | `tasks/m01-f02-calculator-desktop-v1-1/` |
diff --git a/docs/business-context.md b/docs/business-context.md
index 0578894..822e423 100644
--- a/docs/business-context.md
+++ b/docs/business-context.md
@@ -13,10 +13,10 @@
 
 ## 非范围
 
-不含历史记录、科学计算、持久化、网络功能或第三方依赖。
+不含历史记录、科学计算、网络功能或第三方依赖。v1.1 仅增加本地用户名与外观配置持久化，不涉及账户或网络验证。
 
 ## 关键风险
 
 - View 直接计算会破坏 MVC：Controller 只能调用 Model 公共接口。
 - 非法表达式可能崩溃：解析器必须返回结构化错误，不向 UI 抛出未处理异常。
-- 命名要求不可遗漏：窗口标题与交付名称固定为“王晨扬的计算器”。
+- 命名要求不可遗漏：注册后窗口标题显示“XXX的计算器”，交付名称保持“王晨扬的计算器”。
diff --git a/src/controller/CalculatorController.cpp b/src/controller/CalculatorController.cpp
index 1212177..d1f8ccd 100644
--- a/src/controller/CalculatorController.cpp
+++ b/src/controller/CalculatorController.cpp
@@ -1,21 +1,52 @@
 #include "CalculatorController.h"
 
+#include "config/ConfigManager.h"
 #include "model/CalculatorEngine.h"
 #include "view/CalculatorUI.h"
 
-CalculatorController::CalculatorController(CalculatorEngine &engine, CalculatorUI &ui)
-    : engine_(engine), ui_(ui), lastResult_(0.0), hasResult_(false)
+CalculatorController::CalculatorController(CalculatorEngine &engine, ConfigManager &config, CalculatorUI &ui)
+    : engine_(engine), config_(config), ui_(ui), lastResult_(0.0), hasResult_(false)
 {
     connect(&ui_, &CalculatorUI::tokenRequested, this, &CalculatorController::appendToken);
     connect(&ui_, &CalculatorUI::clearRequested, this, &CalculatorController::clear);
     connect(&ui_, &CalculatorUI::backspaceRequested, this, &CalculatorController::backspace);
     connect(&ui_, &CalculatorUI::evaluateRequested, this, &CalculatorController::evaluate);
     connect(&ui_, &CalculatorUI::invalidInputRequested, this, &CalculatorController::rejectInput);
+    connect(&ui_, &CalculatorUI::themeRequested, this, &CalculatorController::selectTheme);
+    connect(&ui_, &CalculatorUI::backgroundImageRequested, this, &CalculatorController::selectBackgroundImage);
 }
 
-void CalculatorController::initialize()
+bool CalculatorController::initialize()
 {
+    QString userName = config_.userName();
+    if (userName.isEmpty()) {
+        userName = ui_.requestUserName();
+    }
+    if (userName.isEmpty()) {
+        return false;
+    }
+    config_.setUserName(userName);
+    ui_.setUserName(userName);
+    ui_.setTheme(config_.themeId(), config_.backgroundImage());
     clear();
+    return true;
+}
+
+void CalculatorController::selectTheme(const QString &themeId)
+{
+    config_.setThemeId(themeId);
+    config_.setBackgroundImage(QString());
+    ui_.setTheme(themeId, QString());
+}
+
+void CalculatorController::selectBackgroundImage(const QString &path)
+{
+    if (path.isEmpty()) {
+        return;
+    }
+    config_.setThemeId(QStringLiteral("custom"));
+    config_.setBackgroundImage(path);
+    ui_.setTheme(QStringLiteral("custom"), path);
 }
 
 void CalculatorController::appendToken(const QString &token)
diff --git a/src/controller/CalculatorController.h b/src/controller/CalculatorController.h
index af2cd44..f8c78de 100644
--- a/src/controller/CalculatorController.h
+++ b/src/controller/CalculatorController.h
@@ -6,14 +6,15 @@
 
 class CalculatorEngine;
 class CalculatorUI;
+class ConfigManager;
 
 class CalculatorController : public QObject
 {
     Q_OBJECT
 
 public:
-    CalculatorController(CalculatorEngine &engine, CalculatorUI &ui);
-    void initialize();
+    CalculatorController(CalculatorEngine &engine, ConfigManager &config, CalculatorUI &ui);
+    bool initialize();
 
 private slots:
     void appendToken(const QString &token);
@@ -21,6 +22,8 @@ private slots:
     void backspace();
     void evaluate();
     void rejectInput(const QString &input);
+    void selectTheme(const QString &themeId);
+    void selectBackgroundImage(const QString &path);
 
 private:
     bool isOperator(const QString &token) const;
@@ -28,6 +31,7 @@ private:
     void refreshExpression();
 
     CalculatorEngine &engine_;
+    ConfigManager &config_;
     CalculatorUI &ui_;
     QString expression_;
     double lastResult_;
diff --git a/src/main.cpp b/src/main.cpp
index 4d5639b..0484ddd 100644
--- a/src/main.cpp
+++ b/src/main.cpp
@@ -1,5 +1,7 @@
 #include <QApplication>
+#include <QIcon>
 
+#include "config/ConfigManager.h"
 #include "controller/CalculatorController.h"
 #include "model/CalculatorEngine.h"
 #include "view/CalculatorUI.h"
@@ -7,11 +9,17 @@
 int main(int argc, char *argv[])
 {
     QApplication application(argc, argv);
+    application.setApplicationName(QStringLiteral("WangChenyangCalculator"));
+    application.setOrganizationName(QStringLiteral("WangChenyang"));
+    application.setWindowIcon(QIcon(QStringLiteral(":/icons/calculator.ico")));
     CalculatorEngine engine;
+    ConfigManager config;
     CalculatorUI ui;
-    CalculatorController controller(engine, ui);
+    CalculatorController controller(engine, config, ui);
 
-    controller.initialize();
+    if (!controller.initialize()) {
+        return 0;
+    }
     ui.show();
     return application.exec();
 }
diff --git a/src/view/CalculatorUI.cpp b/src/view/CalculatorUI.cpp
index 4c7959e..06d3a0c 100644
--- a/src/view/CalculatorUI.cpp
+++ b/src/view/CalculatorUI.cpp
@@ -1,31 +1,67 @@
 #include "CalculatorUI.h"
 
+#include <QFileDialog>
 #include <QGridLayout>
+#include <QIcon>
+#include <QInputDialog>
 #include <QKeyEvent>
 #include <QLineEdit>
+#include <QMenu>
 #include <QPushButton>
 #include <QStringList>
+#include <QToolButton>
+#include <QUrl>
 #include <QWidget>
 
 CalculatorUI::CalculatorUI(QWidget *parent)
-    : QMainWindow(parent), expressionDisplay_(new QLineEdit(this)), resultDisplay_(new QLineEdit(this))
+    : QMainWindow(parent), expressionDisplay_(new QLineEdit(this)), resultDisplay_(new QLineEdit(this)), centralWidget_(new QWidget(this))
 {
-    setWindowTitle(QStringLiteral("王晨扬的计算器"));
-    setMinimumSize(340, 460);
+    setFixedSize(600, 800);
+    setWindowIcon(QIcon(QStringLiteral(":/icons/calculator.ico")));
 
-    QWidget *centralWidget = new QWidget(this);
-    QGridLayout *layout = new QGridLayout(centralWidget);
+    centralWidget_->setObjectName(QStringLiteral("centralWidget"));
+    QGridLayout *layout = new QGridLayout(centralWidget_);
+    layout->setContentsMargins(36, 36, 36, 36);
+    layout->setSpacing(12);
+
+    QToolButton *themeButton = new QToolButton(centralWidget_);
+    themeButton->setText(QStringLiteral("Theme"));
+    themeButton->setPopupMode(QToolButton::InstantPopup);
+    QMenu *themeMenu = new QMenu(themeButton);
+    const QList<QPair<QString, QString> > themes = {
+        qMakePair(QStringLiteral("ocean"), QStringLiteral("Ocean")),
+        qMakePair(QStringLiteral("forest"), QStringLiteral("Forest")),
+        qMakePair(QStringLiteral("sunset"), QStringLiteral("Sunset"))
+    };
+    for (const QPair<QString, QString> &theme : themes) {
+        QAction *action = themeMenu->addAction(theme.second);
+        connect(action, &QAction::triggered, this, [this, theme]() { emit themeRequested(theme.first); });
+    }
+    themeButton->setMenu(themeMenu);
+    QToolButton *backgroundButton = new QToolButton(centralWidget_);
+    backgroundButton->setText(QStringLiteral("+"));
+    backgroundButton->setToolTip(QString::fromUtf8("选择本地背景图片"));
+    backgroundButton->setFixedSize(34, 34);
+    connect(backgroundButton, &QToolButton::clicked, this, [this]() {
+        const QString path = QFileDialog::getOpenFileName(this, QString::fromUtf8("选择背景图片"), QString(),
+                                                          QStringLiteral("Images (*.png *.jpg *.jpeg *.bmp)"));
+        if (!path.isEmpty()) {
+            emit backgroundImageRequested(path);
+        }
+    });
+    layout->addWidget(themeButton, 0, 0, 1, 3);
+    layout->addWidget(backgroundButton, 0, 3);
 
     expressionDisplay_->setObjectName(QStringLiteral("expressionDisplay"));
     expressionDisplay_->setReadOnly(true);
     expressionDisplay_->setAlignment(Qt::AlignRight);
-    expressionDisplay_->setPlaceholderText(QStringLiteral("输入表达式"));
+    expressionDisplay_->setPlaceholderText(QString::fromUtf8("输入表达式"));
     resultDisplay_->setObjectName(QStringLiteral("resultDisplay"));
     resultDisplay_->setReadOnly(true);
     resultDisplay_->setAlignment(Qt::AlignRight);
     resultDisplay_->setText(QStringLiteral("0"));
-    layout->addWidget(expressionDisplay_, 0, 0, 1, 4);
-    layout->addWidget(resultDisplay_, 1, 0, 1, 4);
+    layout->addWidget(expressionDisplay_, 1, 0, 1, 4);
+    layout->addWidget(resultDisplay_, 2, 0, 1, 4);
 
     const QStringList buttonTexts = {
         QStringLiteral("CE"), QStringLiteral("<-"), QStringLiteral("("), QStringLiteral(")"),
@@ -37,10 +73,9 @@ CalculatorUI::CalculatorUI(QWidget *parent)
 
     for (int index = 0; index < buttonTexts.size(); ++index) {
         const QString text = buttonTexts.at(index);
-        QPushButton *button = new QPushButton(text, centralWidget);
+        QPushButton *button = new QPushButton(text, centralWidget_);
         button->setObjectName(QStringLiteral("button_") + text);
-        button->setMinimumHeight(48);
-        layout->addWidget(button, 2 + index / 4, index % 4);
+        layout->addWidget(button, 3 + index / 4, index % 4);
         connect(button, &QPushButton::clicked, this, [this, text]() {
             if (text == QStringLiteral("CE")) {
                 emit clearRequested();
@@ -53,7 +88,8 @@ CalculatorUI::CalculatorUI(QWidget *parent)
             }
         });
     }
-    setCentralWidget(centralWidget);
+    setCentralWidget(centralWidget_);
+    setTheme(QStringLiteral("ocean"), QString());
 }
 
 void CalculatorUI::setExpression(const QString &expression)
@@ -70,7 +106,41 @@ void CalculatorUI::setResult(const QString &result)
 void CalculatorUI::showError(const QString &message)
 {
     resultDisplay_->setStyleSheet(QStringLiteral("color: #b00020;"));
-    resultDisplay_->setText(QStringLiteral("错误：") + message);
+    resultDisplay_->setText(QString::fromUtf8("错误：") + message);
+}
+
+QString CalculatorUI::requestUserName()
+{
+    bool accepted = false;
+    return QInputDialog::getText(this, QString::fromUtf8("欢迎使用"), QString::fromUtf8("请输入用户名："),
+                                 QLineEdit::Normal, QString(), &accepted).trimmed();
+}
+
+void CalculatorUI::setUserName(const QString &userName)
+{
+    setWindowTitle(userName + QString::fromUtf8("的计算器"));
+}
+
+void CalculatorUI::setTheme(const QString &themeId, const QString &backgroundImage)
+{
+    QString background;
+    if (themeId == QStringLiteral("forest")) {
+        background = QStringLiteral("#174d3d");
+    } else if (themeId == QStringLiteral("sunset")) {
+        background = QStringLiteral("#783c37");
+    } else if (themeId == QStringLiteral("custom") && !backgroundImage.isEmpty()) {
+        background = QStringLiteral("url(\"") + QUrl::fromLocalFile(backgroundImage).toString(QUrl::FullyEncoded) + QStringLiteral("\")");
+    } else {
+        background = QStringLiteral("#164f73");
+    }
+    const QString property = themeId == QStringLiteral("custom") ? QStringLiteral("border-image") : QStringLiteral("background-color");
+    centralWidget_->setStyleSheet(QStringLiteral(
+        "QWidget#centralWidget { %1: %2; }"
+        "QLineEdit { background: rgba(255,255,255,220); color: #18212b; border: 1px solid rgba(255,255,255,150); border-radius: 4px; padding: 10px; font-size: 22px; }"
+        "QPushButton, QToolButton { background: rgba(18,25,34,185); color: white; border: 1px solid rgba(255,255,255,90); border-radius: 4px; font-size: 18px; min-height: 52px; }"
+        "QPushButton:hover, QToolButton:hover { background: rgba(255,255,255,75); }"
+        "QMenu { background: #ffffff; color: #18212b; }"
+    ).arg(property, background));
 }
 
 void CalculatorUI::keyPressEvent(QKeyEvent *event)
diff --git a/src/view/CalculatorUI.h b/src/view/CalculatorUI.h
index 8cb927f..3816845 100644
--- a/src/view/CalculatorUI.h
+++ b/src/view/CalculatorUI.h
@@ -5,6 +5,7 @@
 
 class QKeyEvent;
 class QLineEdit;
+class QWidget;
 
 class CalculatorUI : public QMainWindow
 {
@@ -15,6 +16,9 @@ public:
     void setExpression(const QString &expression);
     void setResult(const QString &result);
     void showError(const QString &message);
+    QString requestUserName();
+    void setUserName(const QString &userName);
+    void setTheme(const QString &themeId, const QString &backgroundImage);
 
 signals:
     void tokenRequested(const QString &token);
@@ -22,6 +26,8 @@ signals:
     void backspaceRequested();
     void evaluateRequested();
     void invalidInputRequested(const QString &input);
+    void themeRequested(const QString &themeId);
+    void backgroundImageRequested(const QString &path);
 
 protected:
     void keyPressEvent(QKeyEvent *event) override;
@@ -29,6 +35,7 @@ protected:
 private:
     QLineEdit *expressionDisplay_;
     QLineEdit *resultDisplay_;
+    QWidget *centralWidget_;
 };
 
 #endif // CALCULATORUI_H
```
