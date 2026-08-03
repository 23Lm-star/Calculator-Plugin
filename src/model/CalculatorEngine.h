#ifndef CALCULATORENGINE_H
#define CALCULATORENGINE_H

#include <string>

enum class CalculatorError {
    None,
    EmptyExpression,
    InvalidCharacter,
    InvalidNumber,
    UnexpectedToken,
    MismatchedParenthesis,
    DivideByZero
};

struct CalculatorResult
{
    bool success;
    double value;
    CalculatorError error;
    std::string message;
};

class CalculatorEngine
{
public:
    CalculatorResult evaluate(const std::string &expression) const;
};

#endif // CALCULATORENGINE_H
