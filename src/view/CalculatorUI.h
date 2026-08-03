#ifndef CALCULATORUI_H
#define CALCULATORUI_H

#include <QMainWindow>

class QKeyEvent;
class QLineEdit;

class CalculatorUI : public QMainWindow
{
    Q_OBJECT

public:
    explicit CalculatorUI(QWidget *parent = nullptr);
    void setExpression(const QString &expression);
    void setResult(const QString &result);
    void showError(const QString &message);

signals:
    void tokenRequested(const QString &token);
    void clearRequested();
    void backspaceRequested();
    void evaluateRequested();
    void invalidInputRequested(const QString &input);

protected:
    void keyPressEvent(QKeyEvent *event) override;

private:
    QLineEdit *expressionDisplay_;
    QLineEdit *resultDisplay_;
};

#endif // CALCULATORUI_H
