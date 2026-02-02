#include "ActiveUserViewModel.h"
#include <drive/licensing/features.h>
#include <sys/licensing/client/KeyManagerFactory.h>
#include <sys/licensing/client/LicenseManagerFactory.h>
#include <sys/licensing/client/LicensedUserFactory.h>
#include <sys/licensing/common/feature_util.h>

#include <QColor>
#include <QDebug>
#include <sstream>

ActiveUserViewModel::ActiveUserViewModel(QObject* parent)
    : QObject(parent)
{

}

void ActiveUserViewModel::setUserData(const drive::itf::usermanager::UserData &userData)
{
    m_userData = userData;

    Q_EMIT uuidChanged(uuid());
    Q_EMIT nameChanged(name());
    Q_EMIT initialsChanged(initials());
    Q_EMIT iconColorChanged(iconColor());
    Q_EMIT pinAccessChanged(pinAccess());
    Q_EMIT pinPreferredChanged(pinPreferred());
    Q_EMIT isServiceUserChanged(isServiceUser());
    Q_EMIT isMirrorEnabledChanged(isMirrorEnabled());
}

QString ActiveUserViewModel::uuid() const
{
    return QString::fromStdString(m_userData.uuid);
}

QString ActiveUserViewModel::name() const
{
    return QString::fromStdString(m_userData.name);
}

QString ActiveUserViewModel::initials() const
{
    return QString::fromStdString(m_userData.initials);
}

QColor ActiveUserViewModel::iconColor() const
{
    return QColor(QString::fromStdString(m_userData.color));
}

QString ActiveUserViewModel::email() const
{
    return QString::fromStdString(m_userData.email);
}

bool ActiveUserViewModel::pinAccess() const
{
    return m_userData.pinAccess;
}

bool ActiveUserViewModel::pinPreferred() const
{
    return m_userData.pinPreferred;
}

bool ActiveUserViewModel::isMirrorEnabled() const
{
    return m_userData.mirrorEnabled;
}

bool ActiveUserViewModel::isServiceUser() const
{
    using namespace sys::licensing::client;
    using namespace drive::licensing;

    bool serviceAccess = false;
    if (!m_userData.key.empty())
    {
        auto keyManager = KeyManagerFactory::createInstance();
        auto licenseManager = LicenseManagerFactory::createInstance(keyManager->publicKey());
        std::istringstream keyStream(m_userData.key);
        licenseManager->deserialize(keyStream);

        auto licensedEntity = LicensedUserFactory::createInstance(m_userData.email);
        auto license = licenseManager->license(*licensedEntity);
        serviceAccess = license->isLicensed(encode(UserFeatures::ServiceAccess));
    }
    return serviceAccess;
}
