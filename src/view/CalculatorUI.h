#ifndef CALCULATORUI_H
#define CALCULATORUI_H

#include <QMainWindow>

class QLabel;

class CalculatorUI : public QMainWindow
{
public:
    explicit CalculatorUI(QWidget *parent = nullptr);
    void setStatusText(const QString &text);

private:
    QLabel *statusLabel_;
};

#endif // CALCULATORUI_H
