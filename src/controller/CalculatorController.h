#ifndef CALCULATORCONTROLLER_H
#define CALCULATORCONTROLLER_H

class CalculatorEngine;
class CalculatorUI;

class CalculatorController
{
public:
    CalculatorController(CalculatorEngine &engine, CalculatorUI &ui);
    void initialize();

private:
    CalculatorEngine &engine_;
    CalculatorUI &ui_;
};

#endif // CALCULATORCONTROLLER_H
