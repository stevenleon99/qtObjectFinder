#pragma once

#ifndef Q_MOC_RUN
#include <drive/itf/usermanager/IUserManager.h>
#endif
#include <drive/com/propertysource/UserModelPropertySource.h>

#include <QObject>
#include <QColor>

class ActiveUserViewModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString uuid READ uuid NOTIFY uuidChanged)
    Q_PROPERTY(QString name READ name NOTIFY nameChanged)
    Q_PROPERTY(QString initials READ initials NOTIFY initialsChanged)
    Q_PROPERTY(QColor iconColor READ iconColor NOTIFY iconColorChanged)
    Q_PROPERTY(QString email READ email NOTIFY emailChanged)
    Q_PROPERTY(bool pinAccess READ pinAccess NOTIFY pinAccessChanged)
    Q_PROPERTY(bool pinPreferred READ pinPreferred NOTIFY pinPreferredChanged)
    Q_PROPERTY(bool isServiceUser READ isServiceUser NOTIFY isServiceUserChanged)
    Q_PROPERTY(
        bool isMirrorEnabled READ isMirrorEnabled NOTIFY isMirrorEnabledChanged)

public:
    explicit ActiveUserViewModel(QObject* parent = nullptr);

    void setUserData(const drive::itf::usermanager::UserData& userData);

    // Q_PROPERTY READ
    QString uuid() const;
    QString name() const;
    QString initials() const;
    QColor iconColor() const;
    QString email() const;
    bool pinAccess() const;
    bool pinPreferred() const;
    bool isServiceUser() const;
    bool isMirrorEnabled() const;

signals:
    // Q_PROPERTY NOTIFY
    void uuidChanged(const QString& uuid);
    void nameChanged(const QString& name);
    void initialsChanged(const QString& initials);
    void iconColorChanged(const QColor& iconColor);
    void emailChanged(const QString& email);
    void pinAccessChanged(bool pinAccess);
    void pinPreferredChanged(bool pinPreferred);
    void isServiceUserChanged(bool isServiceUser);
    void isMirrorEnabledChanged(bool isMirrorEnabled);

private:
    // Q_PROPERTY MEMBER
    drive::itf::usermanager::UserData m_userData = drive::itf::usermanager::UserData();
};
