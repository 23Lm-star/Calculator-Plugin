#ifndef CONFIGMANAGER_H
#define CONFIGMANAGER_H

#include <QString>

class QSettings;

class ConfigManager
{
public:
    ConfigManager();
    ~ConfigManager();

    QString userName() const;
    void setUserName(const QString &userName);
    QString themeId() const;
    void setThemeId(const QString &themeId);
    QString backgroundImage() const;
    void setBackgroundImage(const QString &path);
    QString customBackgroundImage() const;
    void setCustomBackgroundImage(const QString &path);

private:
    QSettings *settings_;
};

#endif // CONFIGMANAGER_H
