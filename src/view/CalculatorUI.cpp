#include "CalculatorUI.h"

#include <QGridLayout>
#include <QKeyEvent>
#include <QLineEdit>
#include <QPushButton>
#include <QStringList>
#include <QWidget>

CalculatorUI::CalculatorUI(QWidget *parent)
    : QMainWindow(parent), expressionDisplay_(new QLineEdit(this)), resultDisplay_(new QLineEdit(this))
{
    setWindowTitle(QStringLiteral("王晨扬的计算器"));
    setMinimumSize(340, 460);

    QWidget *centralWidget = new QWidget(this);
    QGridLayout *layout = new QGridLayout(centralWidget);

    expressionDisplay_->setObjectName(QStringLiteral("expressionDisplay"));
    expressionDisplay_->setReadOnly(true);
    expressionDisplay_->setAlignment(Qt::AlignRight);
    expressionDisplay_->setPlaceholderText(QStringLiteral("输入表达式"));
    resultDisplay_->setObjectName(QStringLiteral("resultDisplay"));
    resultDisplay_->setReadOnly(true);
    resultDisplay_->setAlignment(Qt::AlignRight);
    resultDisplay_->setText(QStringLiteral("0"));
    layout->addWidget(expressionDisplay_, 0, 0, 1, 4);
    layout->addWidget(resultDisplay_, 1, 0, 1, 4);

    const QStringList buttonTexts = {
        QStringLiteral("CE"), QStringLiteral("<-"), QStringLiteral("("), QStringLiteral(")"),
        QStringLiteral("7"), QStringLiteral("8"), QStringLiteral("9"), QStringLiteral("/"),
        QStringLiteral("4"), QStringLiteral("5"), QStringLiteral("6"), QStringLiteral("*"),
        QStringLiteral("1"), QStringLiteral("2"), QStringLiteral("3"), QStringLiteral("-"),
        QStringLiteral("0"), QStringLiteral("."), QStringLiteral("="), QStringLiteral("+")
    };

    for (int index = 0; index < buttonTexts.size(); ++index) {
        const QString text = buttonTexts.at(index);
        QPushButton *button = new QPushButton(text, centralWidget);
        button->setObjectName(QStringLiteral("button_") + text);
        button->setMinimumHeight(48);
        layout->addWidget(button, 2 + index / 4, index % 4);
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
    setCentralWidget(centralWidget);
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
    resultDisplay_->setText(QStringLiteral("错误：") + message);
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
