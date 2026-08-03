#include <cmath>
#include <iostream>
#include <string>

#include "model/CalculatorEngine.h"

namespace {

int failures = 0;

void expectValue(CalculatorEngine &engine, const std::string &expression, double expected)
{
    const CalculatorResult result = engine.evaluate(expression);
    if (!result.success || std::fabs(result.value - expected) > 1e-12) {
        std::cerr << "FAIL value: " << expression << '\n';
        ++failures;
    }
}

void expectError(CalculatorEngine &engine, const std::string &expression, CalculatorError expected)
{
    const CalculatorResult result = engine.evaluate(expression);
    if (result.success || result.error != expected) {
        std::cerr << "FAIL error: " << expression << '\n';
        ++failures;
    }
}

} // namespace

int main()
{
    CalculatorEngine engine;

    expectValue(engine, "2+3*4", 14.0);
    expectValue(engine, "(2+3)*(4-1)", 15.0);
    expectValue(engine, "-2.5+.5", -2.0);
    expectValue(engine, "--3", 3.0);
    expectValue(engine, " 1.5 + 2.25 ", 3.75);
    expectError(engine, "10/0", CalculatorError::DivideByZero);
    expectError(engine, "2&3", CalculatorError::InvalidCharacter);
    expectError(engine, "(1+2", CalculatorError::MismatchedParenthesis);
    expectError(engine, "1..2", CalculatorError::InvalidNumber);
    expectError(engine, "2+", CalculatorError::UnexpectedToken);
    expectError(engine, "", CalculatorError::EmptyExpression);

    if (failures == 0) {
        std::cout << "All CalculatorEngine tests passed.\n";
    }
    return failures == 0 ? 0 : 1;
}
