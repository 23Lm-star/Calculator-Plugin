#include <QApplication>
#include <QIcon>

#include "config/ConfigManager.h"
#include "controller/CalculatorController.h"
#include "model/CalculatorEngine.h"
#include "view/CalculatorUI.h"

int main(int argc, char *argv[])
{
    QApplication application(argc, argv);
    application.setApplicationName(QStringLiteral("WangChenyangCalculator"));
    application.setOrganizationName(QStringLiteral("WangChenyang"));
    application.setWindowIcon(QIcon(QStringLiteral(":/icons/calculator.ico")));
    CalculatorEngine engine;
    ConfigManager config;
    CalculatorUI ui;
    CalculatorController controller(engine, config, ui);

    if (!controller.initialize()) {
        return 0;
    }
    ui.show();
    return application.exec();
}
