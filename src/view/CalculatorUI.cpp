#include "CalculatorUI.h"

#include <QFileDialog>
#include <QGridLayout>
#include <QIcon>
#include <QInputDialog>
#include <QKeyEvent>
#include <QLabel>
#include <QLineEdit>
#include <QMenu>
#include <QPixmap>
#include <QPushButton>
#include <QStringList>
#include <QToolButton>
#include <QWidget>

CalculatorUI::CalculatorUI(QWidget *parent)
    : QMainWindow(parent), expressionDisplay_(new QLineEdit(this)), resultDisplay_(new QLineEdit(this)), centralWidget_(new QWidget(this)), backgroundLabel_(new QLabel(centralWidget_))
{
    setFixedSize(600, 800);
    setWindowIcon(QIcon(QStringLiteral(":/icons/calculator.ico")));

    centralWidget_->setObjectName(QStringLiteral("centralWidget"));
    backgroundLabel_->setScaledContents(true);
    backgroundLabel_->hide();
    QGridLayout *layout = new QGridLayout(centralWidget_);
    layout->setContentsMargins(36, 36, 36, 36);
    layout->setSpacing(12);

    QToolButton *themeButton = new QToolButton(centralWidget_);
    themeButton->setText(QStringLiteral("Theme"));
    themeButton->setPopupMode(QToolButton::InstantPopup);
    QMenu *themeMenu = new QMenu(themeButton);
    const QList<QPair<QString, QString> > themes = {
        qMakePair(QStringLiteral("ocean"), QStringLiteral("Ocean")),
        qMakePair(QStringLiteral("forest"), QStringLiteral("Forest")),
        qMakePair(QStringLiteral("sunset"), QStringLiteral("Sunset")),
        qMakePair(QStringLiteral("custom"), QStringLiteral("Custom"))
    };
    for (const QPair<QString, QString> &theme : themes) {
        QAction *action = themeMenu->addAction(theme.second);
        connect(action, &QAction::triggered, this, [this, theme]() { emit themeRequested(theme.first); });
    }
    themeButton->setMenu(themeMenu);
    QToolButton *backgroundButton = new QToolButton(centralWidget_);
    backgroundButton->setText(QStringLiteral("+"));
    backgroundButton->setToolTip(QString::fromUtf8("选择本地背景图片"));
    backgroundButton->setFixedSize(34, 34);
    connect(backgroundButton, &QToolButton::clicked, this, [this]() {
        const QString path = QFileDialog::getOpenFileName(this, QString::fromUtf8("选择背景图片"), QString(),
                                                          QStringLiteral("Images (*.png *.jpg *.jpeg *.bmp)"));
        if (!path.isEmpty()) {
            emit backgroundImageRequested(path);
        }
    });
    layout->addWidget(themeButton, 0, 0, 1, 3);
    layout->addWidget(backgroundButton, 0, 3);

    expressionDisplay_->setObjectName(QStringLiteral("expressionDisplay"));
    expressionDisplay_->setReadOnly(true);
    expressionDisplay_->setAlignment(Qt::AlignRight);
    expressionDisplay_->setPlaceholderText(QString::fromUtf8("输入表达式"));
    resultDisplay_->setObjectName(QStringLiteral("resultDisplay"));
    resultDisplay_->setReadOnly(true);
    resultDisplay_->setAlignment(Qt::AlignRight);
    resultDisplay_->setText(QStringLiteral("0"));
    layout->addWidget(expressionDisplay_, 1, 0, 1, 4);
    layout->addWidget(resultDisplay_, 2, 0, 1, 4);

    const QStringList buttonTexts = {
        QStringLiteral("CE"), QStringLiteral("<-"), QStringLiteral("("), QStringLiteral(")"),
        QStringLiteral("7"), QStringLiteral("8"), QStringLiteral("9"), QStringLiteral("/"),
        QStringLiteral("4"), QStringLiteral("5"), QStringLiteral("6"), QStringLiteral("*"),
        QStringLiteral("1"), QStringLiteral("2"), QStringLiteral("3"), QStringLiteral("-"),
        QStringLiteral("0"), QStringLiteral("."), QStringLiteral("="), QStringLiteral("+")
    };

    for (int index = 0; index < buttonTexts.size(); ++index) {
        const QString text = buttonTexts.at(index);
        QPushButton *button = new QPushButton(text, centralWidget_);
        button->setObjectName(QStringLiteral("button_") + text);
        layout->addWidget(button, 3 + index / 4, index % 4);
        connect(button, &QPushButton::clicked, this, [this, text]() {
            if (text == QStringLiteral("CE")) {
                emit clearRequested();
            } else if (text == QStringLiteral("<-")) {
                emit backspaceRequested();
            } else if (text == QStringLiteral("=")) {
                emit evaluateRequested();
            } else {
                emit tokenRequested(text);
            }
        });
    }
    setCentralWidget(centralWidget_);
    setTheme(QStringLiteral("ocean"), QString());
}

void CalculatorUI::setExpression(const QString &expression)
{
    expressionDisplay_->setText(expression);
}

void CalculatorUI::setResult(const QString &result)
{
    resultDisplay_->setStyleSheet(QString());
    resultDisplay_->setText(result);
}

void CalculatorUI::showError(const QString &message)
{
    resultDisplay_->setStyleSheet(QStringLiteral("color: #b00020;"));
    resultDisplay_->setText(QString::fromUtf8("错误：") + message);
}

QString CalculatorUI::requestUserName()
{
    bool accepted = false;
    return QInputDialog::getText(this, QString::fromUtf8("欢迎使用"), QString::fromUtf8("请输入用户名："),
                                 QLineEdit::Normal, QString(), &accepted).trimmed();
}

void CalculatorUI::setUserName(const QString &userName)
{
    setWindowTitle(userName + QString::fromUtf8("的计算器"));
}

void CalculatorUI::setTheme(const QString &themeId, const QString &backgroundImage)
{
    QString background = QStringLiteral("#164f73");
    if (themeId == QStringLiteral("forest")) {
        background = QStringLiteral("#174d3d");
    } else if (themeId == QStringLiteral("sunset")) {
        background = QStringLiteral("#783c37");
    } else if (themeId == QStringLiteral("custom") && !backgroundImage.isEmpty()) {
        const QPixmap image(backgroundImage);
        if (!image.isNull()) {
            backgroundLabel_->setPixmap(image);
            backgroundLabel_->setGeometry(centralWidget_->rect());
            backgroundLabel_->show();
            backgroundLabel_->lower();
        } else {
            backgroundLabel_->hide();
        }
    }
    if (themeId != QStringLiteral("custom") || backgroundLabel_->isHidden()) {
        backgroundLabel_->hide();
    }
    centralWidget_->setStyleSheet(QStringLiteral(
        "QWidget#centralWidget { background-color: %1; }"
        "QLineEdit { background: rgba(255,255,255,220); color: #18212b; border: 1px solid rgba(255,255,255,150); border-radius: 4px; padding: 10px; font-size: 22px; }"
        "QPushButton, QToolButton { background: rgba(18,25,34,185); color: white; border: 1px solid rgba(255,255,255,90); border-radius: 4px; font-size: 18px; min-height: 52px; }"
        "QPushButton:hover, QToolButton:hover { background: rgba(255,255,255,75); }"
        "QMenu { background: #ffffff; color: #18212b; }"
    ).arg(background));
}

void CalculatorUI::keyPressEvent(QKeyEvent *event)
{
    if (event->key() == Qt::Key_Return || event->key() == Qt::Key_Enter || event->key() == Qt::Key_Equal) {
        emit evaluateRequested();
    } else if (event->key() == Qt::Key_Backspace) {
        emit backspaceRequested();
    } else if (event->key() == Qt::Key_Escape || event->key() == Qt::Key_Delete) {
        emit clearRequested();
    } else {
        const QString input = event->text();
        if (input.size() == 1 && QStringLiteral("0123456789.+-*/()").contains(input)) {
            emit tokenRequested(input);
        } else if (!input.isEmpty()) {
            emit invalidInputRequested(input);
        } else {
            QMainWindow::keyPressEvent(event);
            return;
        }
    }
    event->accept();
}

void CalculatorUI::resizeEvent(QResizeEvent *event)
{
    QMainWindow::resizeEvent(event);
    backgroundLabel_->setGeometry(centralWidget_->rect());
}
