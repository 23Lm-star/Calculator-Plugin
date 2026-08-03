QT += widgets

CONFIG += c++11
QMAKE_CXXFLAGS += /utf-8
TEMPLATE = app
TARGET = WangChenyangCalculator

INCLUDEPATH += $$PWD/src

SOURCES += \
    src/main.cpp \
    src/model/CalculatorEngine.cpp \
    src/view/CalculatorUI.cpp \
    src/controller/CalculatorController.cpp

HEADERS += \
    src/model/CalculatorEngine.h \
    src/view/CalculatorUI.h \
    src/controller/CalculatorController.h
