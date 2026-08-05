#ifndef CALCULATORCONTROLLER_H
#define CALCULATORCONTROLLER_H

#include <QObject>
#include <QString>

class CalculatorEngine;
class CalculatorUI;
class ConfigManager;

class CalculatorController : public QObject
{
    Q_OBJECT

public:
    CalculatorController(CalculatorEngine &engine, ConfigManager &config, CalculatorUI &ui);
    bool initialize();

private slots:
    void appendToken(const QString &token);
    void clear();
    void backspace();
    void evaluate();
    void rejectInput(const QString &input);
    void selectTheme(const QString &themeId);
    void selectBackgroundImage(const QString &path);

private:
    bool isOperator(const QString &token) const;
    QString formatNumber(double value) const;
    void refreshExpression();

    CalculatorEngine &engine_;
    ConfigManager &config_;
    CalculatorUI &ui_;
    QString expression_;
    double lastResult_;
    bool hasResult_;
};

#endif // CALCULATORCONTROLLER_H
