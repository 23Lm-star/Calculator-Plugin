#include "CalculatorController.h"

#include "model/CalculatorEngine.h"
#include "view/CalculatorUI.h"

CalculatorController::CalculatorController(CalculatorEngine &engine, CalculatorUI &ui)
    : engine_(engine), ui_(ui), lastResult_(0.0), hasResult_(false)
{
    connect(&ui_, &CalculatorUI::tokenRequested, this, &CalculatorController::appendToken);
    connect(&ui_, &CalculatorUI::clearRequested, this, &CalculatorController::clear);
    connect(&ui_, &CalculatorUI::backspaceRequested, this, &CalculatorController::backspace);
    connect(&ui_, &CalculatorUI::evaluateRequested, this, &CalculatorController::evaluate);
    connect(&ui_, &CalculatorUI::invalidInputRequested, this, &CalculatorController::rejectInput);
}

void CalculatorController::initialize()
{
    clear();
}

void CalculatorController::appendToken(const QString &token)
{
    if (token.size() != 1 || !QStringLiteral("0123456789.+-*/()").contains(token)) {
        rejectInput(token);
        return;
    }

    if (hasResult_) {
        if (isOperator(token)) {
            expression_ = formatNumber(lastResult_) + token;
        } else {
            expression_.clear();
            ui_.setResult(QStringLiteral("0"));
            expression_ += token;
        }
        hasResult_ = false;
    } else {
        expression_ += token;
    }
    refreshExpression();
}

void CalculatorController::clear()
{
    expression_.clear();
    lastResult_ = 0.0;
    hasResult_ = false;
    ui_.setExpression(QString());
    ui_.setResult(QStringLiteral("0"));
}

void CalculatorController::backspace()
{
    if (hasResult_) {
        hasResult_ = false;
    }
    if (!expression_.isEmpty()) {
        expression_.chop(1);
    }
    refreshExpression();
}

void CalculatorController::evaluate()
{
    const CalculatorResult result = engine_.evaluate(expression_.toStdString());
    if (!result.success) {
        hasResult_ = false;
        ui_.showError(QString::fromUtf8(result.message.c_str()));
        return;
    }

    lastResult_ = result.value;
    hasResult_ = true;
    ui_.setResult(formatNumber(result.value));
}

void CalculatorController::rejectInput(const QString &input)
{
    Q_UNUSED(input)
    ui_.showError(QStringLiteral("仅支持数字、小数点、四则运算符和括号"));
}

bool CalculatorController::isOperator(const QString &token) const
{
    return token == QStringLiteral("+") || token == QStringLiteral("-")
        || token == QStringLiteral("*") || token == QStringLiteral("/");
}

QString CalculatorController::formatNumber(double value) const
{
    if (value == 0.0) {
        value = 0.0;
    }
    return QString::number(value, 'g', 15);
}

void CalculatorController::refreshExpression()
{
    ui_.setExpression(expression_);
}
