#include "CalculatorUI.h"

#include <QLabel>
#include <QVBoxLayout>
#include <QWidget>

CalculatorUI::CalculatorUI(QWidget *parent)
    : QMainWindow(parent), statusLabel_(new QLabel(this))
{
    setWindowTitle(QStringLiteral("王晨扬的计算器"));
    resize(360, 420);

    QWidget *centralWidget = new QWidget(this);
    QVBoxLayout *layout = new QVBoxLayout(centralWidget);
    statusLabel_->setAlignment(Qt::AlignCenter);
    layout->addWidget(statusLabel_);
    setCentralWidget(centralWidget);
}

void CalculatorUI::setStatusText(const QString &text)
{
    statusLabel_->setText(text);
}
