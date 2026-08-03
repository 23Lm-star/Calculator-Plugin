#include <QApplication>

#include "controller/CalculatorController.h"
#include "model/CalculatorEngine.h"
#include "view/CalculatorUI.h"

int main(int argc, char *argv[])
{
    QApplication application(argc, argv);
    CalculatorEngine engine;
    CalculatorUI ui;
    CalculatorController controller(engine, ui);

    controller.initialize();
    ui.show();
    return application.exec();
}
