TEMPLATE = app
TARGET = engine_tests

CONFIG += console c++11
CONFIG -= app_bundle qt
QT -= core gui widgets
QMAKE_CXXFLAGS += /utf-8

INCLUDEPATH += $$PWD/../../src

SOURCES += \
    main.cpp \
    ../../src/model/CalculatorEngine.cpp

HEADERS += ../../src/model/CalculatorEngine.h
