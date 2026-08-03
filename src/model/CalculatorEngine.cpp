#include "CalculatorEngine.h"

#include <cctype>
#include <stdexcept>

namespace {

class ParseFailure : public std::runtime_error
{
public:
    ParseFailure(CalculatorError error, const char *message)
        : std::runtime_error(message), error_(error)
    {
    }

    CalculatorError error() const { return error_; }

private:
    CalculatorError error_;
};

class ExpressionParser
{
public:
    explicit ExpressionParser(const std::string &input) : input_(input), position_(0) {}

    double parse()
    {
        skipSpaces();
        if (atEnd()) {
            fail(CalculatorError::EmptyExpression, "表达式不能为空");
        }

        const double value = parseExpression();
        skipSpaces();
        if (!atEnd()) {
            if (current() == ')') {
                fail(CalculatorError::MismatchedParenthesis, "括号不匹配");
            }
            if (!isSupported(current())) {
                fail(CalculatorError::InvalidCharacter, "表达式包含非法字符");
            }
            fail(CalculatorError::UnexpectedToken, "运算符或数字位置不正确");
        }
        return value;
    }

private:
    double parseExpression()
    {
        double value = parseTerm();
        while (true) {
            skipSpaces();
            if (consume('+')) {
                value += parseTerm();
            } else if (consume('-')) {
                value -= parseTerm();
            } else {
                return value;
            }
        }
    }

    double parseTerm()
    {
        double value = parseUnary();
        while (true) {
            skipSpaces();
            if (consume('*')) {
                value *= parseUnary();
            } else if (consume('/')) {
                const double divisor = parseUnary();
                if (divisor == 0.0) {
                    fail(CalculatorError::DivideByZero, "除数不能为零");
                }
                value /= divisor;
            } else {
                return value;
            }
        }
    }

    double parseUnary()
    {
        skipSpaces();
        if (consume('+')) {
            return parseUnary();
        }
        if (consume('-')) {
            return -parseUnary();
        }
        return parsePrimary();
    }

    double parsePrimary()
    {
        skipSpaces();
        if (consume('(')) {
            const double value = parseExpression();
            skipSpaces();
            if (!consume(')')) {
                fail(CalculatorError::MismatchedParenthesis, "括号不匹配");
            }
            return value;
        }
        if (atEnd()) {
            fail(CalculatorError::UnexpectedToken, "缺少数字或右括号");
        }
        if (current() == ')') {
            fail(CalculatorError::MismatchedParenthesis, "括号不匹配");
        }
        if (!isDigit(current()) && current() != '.') {
            if (!isSupported(current())) {
                fail(CalculatorError::InvalidCharacter, "表达式包含非法字符");
            }
            fail(CalculatorError::UnexpectedToken, "运算符或数字位置不正确");
        }
        return parseNumber();
    }

    double parseNumber()
    {
        const std::size_t start = position_;
        bool hasDigits = false;
        bool hasDecimalPoint = false;
        while (!atEnd()) {
            if (isDigit(current())) {
                hasDigits = true;
                ++position_;
            } else if (current() == '.') {
                if (hasDecimalPoint) {
                    fail(CalculatorError::InvalidNumber, "小数格式不正确");
                }
                hasDecimalPoint = true;
                ++position_;
            } else {
                break;
            }
        }
        if (!hasDigits) {
            fail(CalculatorError::InvalidNumber, "小数点前后必须包含数字");
        }

        double value = 0.0;
        bool afterDecimalPoint = false;
        double factor = 0.1;
        for (std::size_t index = start; index < position_; ++index) {
            const char character = input_[index];
            if (character == '.') {
                afterDecimalPoint = true;
            } else if (afterDecimalPoint) {
                value += (character - '0') * factor;
                factor *= 0.1;
            } else {
                value = value * 10.0 + (character - '0');
            }
        }
        return value;
    }

    bool consume(char expected)
    {
        if (!atEnd() && current() == expected) {
            ++position_;
            return true;
        }
        return false;
    }

    void skipSpaces()
    {
        while (!atEnd() && std::isspace(static_cast<unsigned char>(current()))) {
            ++position_;
        }
    }

    bool atEnd() const { return position_ >= input_.size(); }
    char current() const { return input_[position_]; }
    static bool isDigit(char value) { return value >= '0' && value <= '9'; }
    static bool isSupported(char value)
    {
        return isDigit(value) || value == '.' || value == '+' || value == '-' || value == '*'
            || value == '/' || value == '(' || value == ')';
    }
    static void fail(CalculatorError error, const char *message) { throw ParseFailure(error, message); }

    const std::string &input_;
    std::size_t position_;
};

} // namespace

CalculatorResult CalculatorEngine::evaluate(const std::string &expression) const
{
    try {
        return {true, ExpressionParser(expression).parse(), CalculatorError::None, std::string()};
    } catch (const ParseFailure &failure) {
        return {false, 0.0, failure.error(), failure.what()};
    }
}
