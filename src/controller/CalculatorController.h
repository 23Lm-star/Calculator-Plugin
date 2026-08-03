#ifndef CALCULATORCONTROLLER_H
#define CALCULATORCONTROLLER_H

#include <QObject>
#include <QString>

class CalculatorEngine;
class CalculatorUI;

class CalculatorController : public QObject
{
    Q_OBJECT

public:
    CalculatorController(CalculatorEngine &engine, CalculatorUI &ui);
    void initialize();

private slots:
    void appendToken(const QString &token);
    void clear();
    void backspace();
    void evaluate();
    void rejectInput(const QString &input);

private:
    bool isOperator(const QString &token) const;
    QString formatNumber(double value) const;
    void refreshExpression();

    CalculatorEngine &engine_;
    CalculatorUI &ui_;
    QString expression_;
    double lastResult_;
    bool hasResult_;
};

#endif // CALCULATORCONTROLLER_H
