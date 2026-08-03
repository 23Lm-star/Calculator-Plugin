#include "CalculatorController.h"

#include "model/CalculatorEngine.h"
#include "view/CalculatorUI.h"

CalculatorController::CalculatorController(CalculatorEngine &engine, CalculatorUI &ui)
    : engine_(engine), ui_(ui)
{
}

void CalculatorController::initialize()
{
    ui_.setStatusText(QStringLiteral("计算器骨架已初始化"));
}
