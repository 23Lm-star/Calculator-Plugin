#include "ConfigManager.h"

#include <QCoreApplication>
#include <QDir>
#include <QSettings>

ConfigManager::ConfigManager()
    : settings_(new QSettings(QDir(QCoreApplication::applicationDirPath()).filePath(QStringLiteral("calculator.ini")),
                              QSettings::IniFormat))
{
    const QString activeBackground = themeId();
    if (activeBackground == QStringLiteral("custom")) {
        if (!settings_->contains(QStringLiteral("appearance/customBackgroundImage"))) {
            settings_->setValue(QStringLiteral("appearance/customBackgroundImage"), backgroundImage());
        }
    } else {
        settings_->setValue(QStringLiteral("appearance/backgroundImage"),
                            QStringLiteral("preset:") + activeBackground);
    }
    settings_->sync();
}

ConfigManager::~ConfigManager()
{
    delete settings_;
}

QString ConfigManager::userName() const
{
    return settings_->value(QStringLiteral("profile/userName")).toString().trimmed();
}

void ConfigManager::setUserName(const QString &userName)
{
    settings_->setValue(QStringLiteral("profile/userName"), userName.trimmed());
    settings_->sync();
}

QString ConfigManager::themeId() const
{
    return settings_->value(QStringLiteral("appearance/activeBackground"),
                            settings_->value(QStringLiteral("appearance/themeId"), QStringLiteral("ocean"))).toString();
}

void ConfigManager::setThemeId(const QString &themeId)
{
    settings_->setValue(QStringLiteral("appearance/activeBackground"), themeId);
    settings_->setValue(QStringLiteral("appearance/themeId"), themeId);
    settings_->sync();
}

QString ConfigManager::backgroundImage() const
{
    return settings_->value(QStringLiteral("appearance/backgroundImage")).toString();
}

void ConfigManager::setBackgroundImage(const QString &path)
{
    settings_->setValue(QStringLiteral("appearance/backgroundImage"), path);
    settings_->sync();
}

QString ConfigManager::customBackgroundImage() const
{
    return settings_->value(QStringLiteral("appearance/customBackgroundImage"),
                            settings_->value(QStringLiteral("appearance/backgroundImage"))).toString();
}

void ConfigManager::setCustomBackgroundImage(const QString &path)
{
    settings_->setValue(QStringLiteral("appearance/customBackgroundImage"), path);
    settings_->sync();
}
