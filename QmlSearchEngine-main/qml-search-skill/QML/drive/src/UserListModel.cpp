/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "UserListModel.h"
#include <drive/common/DriveCommon.h>
#include <drive/licensing/features.h>
#include <drive/usermanager/UserManagerFactory.h>
#include <gm/util/functional/optional.h>
#include <sys/config/config.h>
#include <sys/licensing/client/KeyManagerFactory.h>
#include <sys/licensing/client/LicenseManagerFactory.h>
#include <sys/licensing/client/LicensedUserFactory.h>
#include <sys/licensing/common/feature_util.h>

#include <QDate>
#include <QDebug>
#include <sstream>

using namespace sys::licensing::client;
using namespace drive::licensing;

UserListModel::UserListModel(QObject* parent) :
    UserListModel(drive::usermanager::UserManagerFactory::createInstance(
                  sys::config::Config::instance()->config.usersPath().string()), parent)
{

}

UserListModel::UserListModel(std::shared_ptr<drive::itf::usermanager::IUserManager> userManager, QObject* parent) :
    QAbstractListModel(parent),
    m_userManager(userManager)
{
    updateUserList();
}

QHash<int, QByteArray> UserListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[UUid] = "role_uuid";
    roles[Name] = "role_name";
    roles[Initials] = "role_initials";
    roles[Color] = "role_color";
    roles[LastUsed] = "role_lastUsed";
    roles[Email] = "role_email";
    roles[Expiration] = "role_expiration";
    roles[ServiceAccess] = "role_serviceAccess";
    roles[Active] = "role_active";


    return roles;
}

int UserListModel::rowCount(const QModelIndex&) const
{
    return static_cast<int>(m_uuidlist.size());
}

QVariant UserListModel::data(const QModelIndex& index, int role) const
{
    int rowIndex = index.row();
    if (rowIndex < 0 || rowIndex >= rowCount(index))
        return QVariant();

    auto&& userData = m_userMap.at(m_uuidlist.at(rowIndex));
    switch(role)
    {
    case UUid:
        return QString::fromStdString(userData.uuid);
    case Name:
        return QString::fromStdString(userData.name);
    case Initials:
        return QString::fromStdString(userData.initials);
    case Color:
        return QString::fromStdString(userData.color);
    case LastUsed:
        return QString::fromStdString(userData.last_used);
    case Email:
        return QString::fromStdString(userData.email);
    case Expiration:
    {
        return std::visit(
            gm::util::functional::visitor{
                [=](const sys::licensing::common::duration::Unlimited&) -> QString {
                    return "Unlimited";
                },
                [=](const sys::licensing::common::duration::Timed& l) -> QString {
                    auto date = QDate::currentDate().addDays(l.remainingDays.count());
                    return date.toString(drive::common::DATE_FORMAT).toUpper();
                },
                [=](const sys::licensing::common::duration::Disabled&) -> QString {
                    return "Disabled";
                },
            },
            getDurationRemaining(userData.email, userData.key).asVariant());
    }
    case ServiceAccess:
    {
        auto license = getUserLicense(userData.email, userData.key);
        if (license)
            return license->isLicensed(encode(UserFeatures::ServiceAccess));

        return false;
    }
    case Active:
        return m_userMap.at(m_uuidlist.at(rowIndex)).active;
    default:
        return QVariant();
    }
}

std::optional<UserListModel::UserData> UserListModel::getUserData(const QString& uuuid) const
{
    if (uuuid.isEmpty() || (m_userMap.find(uuuid.toStdString()) == m_userMap.end()))
        return {};

    return m_userMap.at(uuuid.toStdString());
}

std::unique_ptr<const ILicense> UserListModel::getUserLicense(const std::string& email,
                                                              const std::string& key) const
{
    if (email.empty() || key.empty())
        return {};

    try
    {
        auto keyManager = KeyManagerFactory::createInstance();
        auto licenseManager =
            LicenseManagerFactory::createInstance(keyManager->publicKey());
        std::istringstream keyStream(key);
        licenseManager->deserialize(keyStream);

        auto licensedEntity = LicensedUserFactory::createInstance(email);
        return licenseManager->license(*licensedEntity);
    }
    catch (const std::exception& e)
    {
        qDebug() << "Unable to get the license for email "
                 << QString::fromStdString(email) << ". Exception " << e.what();
    }

    return {};
}

/**
 * Reads the user details and updates the view model
 */
void UserListModel::updateUserList()
{
    std::map<std::string, drive::itf::usermanager::UserData> userMap;
    userMap = m_userManager->getUsersMap();
    beginResetModel();
    m_uuidlist.clear();
    for (auto const& element : userMap)
    {
        m_uuidlist.push_back(element.first);
    }

    m_userMap = userMap;
    endResetModel();
}

sys::licensing::common::DurationType UserListModel::getDurationRemaining(const std::string& email,
                                                                         const std::string& key) const
{
    auto license = getUserLicense(email, key);
    if (license)
    {
        if (license->isLicensed(encode(UserFeatures::ServiceAccess)))
            return durationRemaining(
                license->limitType(encode(UserFeatures::ServiceAccess)));

        return durationRemaining(
            license->limitType(encode(UserFeatures::ClinicalAccess)));
    }

    return {};
}
