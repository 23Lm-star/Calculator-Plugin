#ifndef CALCULATORUI_H
#define CALCULATORUI_H

#include <QMainWindow>

class QKeyEvent;
class QLabel;
class QLineEdit;
class QResizeEvent;
class QWidget;

class CalculatorUI : public QMainWindow
{
    Q_OBJECT

public:
    explicit CalculatorUI(QWidget *parent = nullptr);
    void setExpression(const QString &expression);
    void setResult(const QString &result);
    void showError(const QString &message);
    QString requestUserName();
    void setUserName(const QString &userName);
    void setTheme(const QString &themeId, const QString &backgroundImage);

signals:
    void tokenRequested(const QString &token);
    void clearRequested();
    void backspaceRequested();
    void evaluateRequested();
    void invalidInputRequested(const QString &input);
    void themeRequested(const QString &themeId);
    void backgroundImageRequested(const QString &path);

protected:
    void keyPressEvent(QKeyEvent *event) override;
    void resizeEvent(QResizeEvent *event) override;

private:
    QLineEdit *expressionDisplay_;
    QLineEdit *resultDisplay_;
    QWidget *centralWidget_;
    QLabel *backgroundLabel_;
};

#endif // CALCULATORUI_H
