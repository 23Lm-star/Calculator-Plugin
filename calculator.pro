QT += widgets

CONFIG += c++11
msvc: QMAKE_CXXFLAGS += /utf-8
TEMPLATE = app
TARGET = WangChenyangCalculator

INCLUDEPATH += $$PWD/src

SOURCES += \
    src/main.cpp \
    src/config/ConfigManager.cpp \
    src/model/CalculatorEngine.cpp \
    src/view/CalculatorUI.cpp \
    src/controller/CalculatorController.cpp

HEADERS += \
    src/config/ConfigManager.h \
    src/model/CalculatorEngine.h \
    src/view/CalculatorUI.h \
    src/controller/CalculatorController.h

RC_ICONS = resources/calculator.ico

RESOURCES += resources/resources.qrc

# Keep the MSVC redistributable runtime beside a Release build so the deployed
# directory starts on a machine without Visual Studio or a globally installed CRT.
msvc:release {
    CRT_DEPLOY_DIR = $$replace(OUT_PWD, /, \\)\\release
    CRT_SOURCE_DIR = $$replace(PWD, /, \\)\\resources\\runtime\\win-x64
    exists($$CRT_SOURCE_DIR/MSVCP140.dll) {
        QMAKE_POST_LINK += $$quote(copy /Y "$$CRT_SOURCE_DIR\\MSVCP140.dll" "$$CRT_DEPLOY_DIR\\MSVCP140.dll") && \
                            $$quote(copy /Y "$$CRT_SOURCE_DIR\\VCRUNTIME140.dll" "$$CRT_DEPLOY_DIR\\VCRUNTIME140.dll") && \
                            $$quote(copy /Y "$$CRT_SOURCE_DIR\\VCRUNTIME140_1.dll" "$$CRT_DEPLOY_DIR\\VCRUNTIME140_1.dll")
    } else {
        error(MSVC CRT runtime files are missing from resources/runtime/win-x64)
    }
}
