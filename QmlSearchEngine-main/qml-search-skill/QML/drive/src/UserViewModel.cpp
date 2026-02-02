/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "UserViewModel.h"
#include <drive/licensing/features.h>
#include <drive/usermanager/UserManagerFactory.h>
#include <gm/util/functional/optional.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <sys/alerts/Alert.h>
#include <sys/alerts/AlertManagerFactory.h>
#include <sys/config/config.h>
#include <sys/envvars/EnvVarsFactory.h>
#include <sys/licensing/client/LicenseManagerFactory.h>
#include <sys/licensing/client/LicensedUserFactory.h>
#include <sys/licensing/common/LicenseDetail.h>
#include <sys/licensing/common/LimitType.h>
#include <sys/licensing/common/feature_util.h>

#include <QDateTime>
#include <QDateTimeEdit>
#include <QDebug>
#include <chrono>
#include <sstream>
#include <boost/algorithm/string.hpp>
#include <fmt/format.h>

namespace drive::viewmodel {

using UserModelPropertySource = drive::com::propertysource::UserModelPropertySource;
using UserData = drive::itf::usermanager::UserData;
using namespace drive::alerts;
using namespace sys::licensing::client;

constexpr auto DEFAULT_PASSWORD = "password";
constexpr auto MAX_LOGIN_ATTEMPTS = 10;  // max login failures for user lockout
constexpr auto SERVICE_SESSION_TIMEOUT = 43200;  // 12 hours in seconds, to deactivate service user from system
constexpr auto MANUFACTURING_EMAIL = "INRMFG@globusmedical.com";

UserViewModel::UserViewModel(
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
    QObject* parent)
    : QObject(parent)
    , m_userManager(drive::usermanager::UserManagerFactory::createInstance(
          sys::config::Config::instance()->config.usersPath().string()))
    , m_userModelPropertySource(
          std::make_unique<
              drive::com::propertysource::UserModelPropertySource>())
    , m_keyManager(KeyManagerFactory::createInstance())
    , m_alertManager(sys::alerts::AlertManagerFactory::createInstance())
    , m_activeUser(new ActiveUserViewModel(this))
    , m_userList(new UserListModel(m_userManager, parent))
{
    getPlatformType();

    connect(m_userModelPropertySource.get(), &UserModelPropertySource::selectedUserChanged,
        this, &UserViewModel::updateSelectedUser);
    connect(m_userModelPropertySource.get(), &UserModelPropertySource::loggedInSurgeonNameChanged,
        this, &UserViewModel::loggedInUserNameChanged);
    connect(m_activeUser, &ActiveUserViewModel::pinAccessChanged,
        this, &UserViewModel::onPinAccessSettingChanged);
    connect(m_activeUser, &ActiveUserViewModel::pinPreferredChanged,
        this, &UserViewModel::onPinAccessSettingChanged);

    gm::util::qt::connect(m_alertManager->clearRequested, this, &UserViewModel::handleAlertResponse);
    connect(this, &UserViewModel::activeUserChanged, this, &UserViewModel::loginAttemptsRemainingChanged);

    alertViewRegistry->addAlertView(m_alertManager);

    checkUserExpiration();

    setPinAccessAllowed();
}

void UserViewModel::getPlatformType()
{
    using namespace sys::config;
    auto type = sys::config::Config::instance()->platform.systemType();
    switch (type)
    {
    case SystemType::Egps:
        m_platformType = PlatformType::Egps;
        break;
    case SystemType::E3d:
        m_platformType = PlatformType::E3d;
        break;
    case SystemType::Ehub:
        m_platformType = PlatformType::Ehub;
        break;
    case SystemType::Exr:
        m_platformType = PlatformType::Exr;
        break;
    case SystemType::Laptop:
        m_platformType = PlatformType::Laptop;
        break;
    default:
        m_platformType = PlatformType::None;
        break;
    }
}

void UserViewModel::setActiveUser(const QString &activeUserUuid)
{
    if (m_activeUser->uuid() == activeUserUuid)
        return;

    qDebug() << "Active user changed to user with uuid " << activeUserUuid;

    m_userModelPropertySource->setUser(activeUserUuid);
    setPinAccessAllowed();
    emit activeUserChanged();
}

bool UserViewModel::isPinAccessAllowed() const
{
    return m_isPinAccessAllowed;
}

void UserViewModel::onPinAccessSettingChanged([[maybe_unused]] bool access)
{
    m_isPinAccessAllowed =
        m_activeUser->pinAccess() && m_activeUser->pinPreferred();
    emit pinAccessAllowedChanged();
}

void UserViewModel::setPinAccessAllowed()
{
    if (m_activeUser->isServiceUser())
    {
        m_isPinAccessAllowed = true;
    }
    else if (m_platformType == PlatformType::Laptop)
    {
        m_isPinAccessAllowed = false;
    }
    else
    {
        m_isPinAccessAllowed = 
            m_activeUser->pinPreferred() && m_activeUser->pinAccess();
    }

    emit pinAccessAllowedChanged();
}

bool UserViewModel::createUser(const QString& emailStr,
                               const QString& activationKey,
                               const QString& name,
                               const QString& initials,
                               const QString& color,
                               const QString& pin,
                               const QString& password,
                               bool pinPreferred)
{
    auto email = emailStr.trimmed();
    auto licensedEntity =
        LicensedUserFactory::createInstance(email.toStdString());
    auto licenseManager = LicenseManagerFactory::createInstance(m_keyManager->publicKey());
    licenseManager->applyResponse(*licensedEntity.get(), { activationKey.toStdString() });

    std::ostringstream keyStream;
    licenseManager->serialize(keyStream);

    UserData userData;
    auto existingUserData = getUserData(email);
    if (existingUserData.has_value())
    {
        userData = existingUserData.value();
        if (userData.active)
        {
            qDebug() << "Active user account with user uuid " << QString::fromStdString(userData.uuid)
                     << " and user name " << QString::fromStdString(userData.name)
                     << " already exists for given email " << email;
            m_alertManager->createAlert(alertsMap.at(DriveAlerts::UserAlreadyExists));
            return false;
        }

        m_userManager->reactivateLocalUser(userData.uuid, keyStream.str(), password.toStdString(), pin.toStdString());
        qDebug() << "Successfully reactivated the user " << name << " with uuid "
                 << QString::fromStdString(userData.uuid) <<" for the email " << email;
    }
    else
    {
        userData = m_userManager->createLocalUser(name.toUtf8().toStdString(), email.toStdString(), keyStream.str(),
                                                  password.toStdString(), pin.toStdString());
        qDebug() << "Successfully created user " << name << " with uuid "
                 << QString::fromStdString(userData.uuid) <<" for the email " << email;
    }

    userData.name = name.toUtf8().toStdString();
    userData.initials = initials.toStdString();
    userData.color = color.toStdString();
    userData.pinAccess = true;
    userData.pinPreferred = pinPreferred;
    userData.mirrorEnabled = true;
    userData.tutorialViewed = false;
    setUserPreferences(userData);

    if (isServiceUserKey(email, activationKey))
    {
        emit serviceUserCountChanged();
    }

    return true;
}

bool UserViewModel::setUserPin(const QString &uuid, const QString &password, const QString &pin)
{
    if (m_userManager->setUserPin(uuid.toStdString(),
                                  password.toStdString(), pin.toStdString()))
    {
        qDebug() << "PIN changed successfully for user with uuid " << uuid;
        m_alertManager->createAlert(alertsMap.at(DriveAlerts::PinUpdated));
        return true;
    }

    qDebug() << "Failed to change PIN for user with uuid " << uuid;
    return false;
}

bool UserViewModel::setUserPassword(const QString &uuid, const QString &oldPassword, const QString &newPassword)
{
    if (m_userManager->setUserPassword(uuid.toStdString(),
                                       oldPassword.toStdString(), newPassword.toStdString()))
    {
        qDebug() << "Password changed successfully for user with uuid " << uuid;
        m_alertManager->createAlert(alertsMap.at(DriveAlerts::PasswordUpdated));
        return true;
    }

    qDebug() << "Failed to change password for user with uuid " << uuid;
    return false;
}

bool UserViewModel::setUserPreferences(const QString& uuid,
                                       const QString& name,
                                       const QString& initials,
                                       const QString& color)
{
    auto userData = m_userList->getUserData(uuid);
    if (!userData.has_value())
        return false;

    userData.value().name = name.toUtf8().toStdString();
    userData.value().initials = initials.toUtf8().toStdString();
    userData.value().color = color.toStdString();

    qDebug() << "Updating the preferences for the user with uuid " << uuid
             << " user name as " << name << " initial as " << initials
             << " color as " << color;


    return setUserPreferences(userData.value());
}

bool UserViewModel::deleteDirectoryContents(const std::filesystem::path& dir)
{
    std::error_code ec;
    auto dirIter = std::filesystem::directory_iterator(dir, ec);
    if (ec)
    {
        qWarning() << "Failed to iterate the directory \""
                   << dir.string().c_str() << "\": " << ec.message().c_str();
        return false;
    }
    for (const auto& entry : dirIter)
    {
        std::filesystem::remove_all(entry.path(), ec);
        if (ec)
        {
            qWarning() << "Failed to remove \"" << entry.path().string().c_str()
                       << "\": " << ec.message().c_str();
            return false;
        }
    }

    return true;
}

bool UserViewModel::login(const QString& code)
{
    bool authenticated = false;

    if (m_activeUser->uuid().isEmpty())
        return authenticated;

    if (m_isPinAccessAllowed)
    {
        authenticated = m_userManager->isPinAuthenticated(m_activeUser->uuid().toStdString(), code.toStdString());
    }
    else
    {
        authenticated = m_userManager->isPasswordAuthenticated(m_activeUser->uuid().toStdString(), code.toStdString());
    }

    if (authenticated)
    {
        qDebug() << "Logged in the user " << m_activeUser->name()
                 << " with uuid " << m_activeUser->uuid();
        m_userModelPropertySource->setLoggedInSurgeonId(m_activeUser->uuid());
        m_userModelPropertySource->setLoggedInSurgeonName(m_activeUser->name());
        updateLastUsedDate();
    }
    else
    {
        qDebug() << "Authentication failed for user " << m_activeUser->name()
                 << " with uuid " << m_activeUser->uuid();
        Q_EMIT loginAttemptsRemainingChanged();
    }

    return authenticated;
}

void UserViewModel::loginServiceUser(const QString& uuid, const QString& name)
{
    qDebug() << "Service user login success for user " << name << " with uuid " << uuid;
    m_userModelPropertySource->setLoggedInSurgeonId(uuid);
    m_userModelPropertySource->setLoggedInSurgeonName(name);
}

void UserViewModel::logOff()
{
    qDebug() << "Logging off the user " <<  m_userModelPropertySource->loggedInSurgeonName()
                          << " with uuid " << m_userModelPropertySource->loggedInSurgeonId();
    m_userModelPropertySource->clearLoggedInSurgeonId();
}

bool UserViewModel::validateActivationKey(const QString& emailStr,
                                          const QString& activationKey)
{
    auto email = emailStr.trimmed();
    auto licensedEntity = LicensedUserFactory::createInstance(email.toStdString());
    if (sys::licensing::common::LicenseDetail::isValidResponse({ activationKey.toStdString() },
                                                               *(licensedEntity.get()),
                                                               m_keyManager->publicKey()))
    {
        auto licenseManager = LicenseManagerFactory::createInstance(m_keyManager->publicKey());
        licenseManager->applyResponse(*licensedEntity.get(), { activationKey.toStdString() });
        auto license = licenseManager->license(*licensedEntity.get());

        if (license->isLicensed(encode(drive::licensing::UserFeatures::ServiceAccess)) ||
                license->isLicensed(encode(drive::licensing::UserFeatures::ClinicalAccess)))
        {
            qDebug() << "Validation success for email " << email;
            return true;
        }
    }

    qDebug() << "Validation failed for email " << email;
    m_alertManager->createAlert(alertsMap.at(DriveAlerts::ActivationFailed));
    return false;
}

/**
 * Verify the active user existence for given email address and
 * trigger alert if active user exists
 *
 * @param emailStr the email address of the user to verify
 * @return \c true if the user already exist, \c false otherwise
 */
bool UserViewModel::activeUserAvailable(const QString& emailStr) const
{
    auto email = emailStr.trimmed();
    auto userData = getUserData(email);
    if (userData.has_value() && userData.value().active)
    {
        qDebug() << "Active user account with user uuid " << QString::fromStdString(userData.value().uuid)
                 << " and user name " << QString::fromStdString(userData.value().name)
                 << " already exists for given email " << email;
        m_alertManager->createAlert(alertsMap.at(DriveAlerts::UserAlreadyExists));
        return true;
    }

    return false;
}

bool UserViewModel::isServiceUserKey(const QString& emailStr,
                                     const QString& activationKey)
{
    auto email = emailStr.trimmed();
    auto licensedEntity = LicensedUserFactory::createInstance(email.toStdString());
    auto licenseManager = LicenseManagerFactory::createInstance(m_keyManager->publicKey());
    licenseManager->applyResponse(*licensedEntity.get(), { activationKey.toStdString() });
    auto license = licenseManager->license(*licensedEntity.get());
    if (license->isLicensed(encode(drive::licensing::UserFeatures::ServiceAccess)))
        return true;

    return false;
}

bool UserViewModel::setEmailAndActivationKey(const QString& password,
                                             const QString& emailStr,
                                             const QString& activationKey)
{
    auto email = emailStr.trimmed();
    auto licensedEntity = LicensedUserFactory::createInstance(email.toStdString());
    auto licenseManager = LicenseManagerFactory::createInstance(m_keyManager->publicKey());
    licenseManager->applyResponse(*licensedEntity.get(), { activationKey.toStdString() });

    std::ostringstream keyStream;
    licenseManager->serialize(keyStream);

    auto loggedInUuid = m_userModelPropertySource->loggedInSurgeonId();

    qDebug() << "Updating the email " << email << " for user with uuid " << loggedInUuid;
    if (m_userManager->setActivationCodes(loggedInUuid.toStdString(), password.toStdString(), email.toStdString(),
                                          keyStream.str()))
    {
        qDebug() << "Email " << email << " updated successfully for user with uuid " << loggedInUuid;
        m_alertManager->createAlert(alertsMap.at(DriveAlerts::EmailUpdated));
        return true;
    }

    qDebug() << "Failed to update email " << email << " for user with uuid " << loggedInUuid;
    return false;
}

void UserViewModel::changePassword(const QString& uuid, const QString& password)
{
    m_userManager->resetPassword(uuid.toStdString());
    m_userManager->setUserPassword(uuid.toStdString(), DEFAULT_PASSWORD, password.toStdString());

    Q_EMIT loginAttemptsRemainingChanged();
}

void UserViewModel::setPinPreferred(const QString& uuid, bool pinPreferred)
{
    auto userData = m_userList->getUserData(uuid);
    if (!userData.has_value())
        return;

    userData.value().pinPreferred = pinPreferred;
    setUserPreferences(userData.value());
}

bool UserViewModel::authenticatePassword(const QString& password)
{
    auto loggedInUuid = m_userModelPropertySource->loggedInSurgeonId();
    auto result = m_userManager->isPasswordAuthenticated(loggedInUuid.toStdString(),
                                                             password.toStdString());
    if (!result)
    {
        qDebug() << "Authentication failed for user with uuid " << loggedInUuid;

        auto remainingAttempts = loginAttemptsRemaining();
        if (remainingAttempts > 0)
        {
            auto alert = alertsMap.at(DriveAlerts::IncorrectPassword);
            alert.message = fmt::format(alert.message, remainingAttempts);
            m_alertManager->createAlert(alert);
        }
        else
        {
            m_alertManager->createAlert(
                alertsMap.at(DriveAlerts::AccountLocked));
        }
    }

    return result;
}

void UserViewModel::setUseMetric(bool useMetric)
{
    auto loggedInUuid = m_userModelPropertySource->loggedInSurgeonId();
    auto userData = m_userList->getUserData(loggedInUuid);
    if (!userData.has_value())
        return;

   userData.value().isMetric = useMetric;
   if (setUserPreferences(userData.value()))
   {
       m_userModelPropertySource->setMetricUnitSelection(useMetric);
       emit useMetricChanged();
   }
}

void UserViewModel::setPinAccess(bool pinAccess)
{
    auto loggedInUuid = m_userModelPropertySource->loggedInSurgeonId();
    auto userData = m_userList->getUserData(loggedInUuid);
    if (!userData.has_value())
        return;

    userData.value().pinAccess = pinAccess;
    setUserPreferences(userData.value());
}

void UserViewModel::deactivateUser(const QString& uuid)
{
    if (m_userManager->deactivateLocalUser(uuid.toStdString()))
    {
        qDebug() << "Successfully deactivated the user " << m_activeUser->name()
                 << " with uuid " << uuid;
        if (m_userModelPropertySource->selectedUser() == uuid)
        {
            m_userModelPropertySource->setUser(QString());
        }
        m_userList->updateUserList();
        updateSelectedUser();
    }
    else
    {
        qDebug() << "Failed to deactivate the user " << m_activeUser->name()
                 << " with uuid " << uuid;
    }
}

void UserViewModel::updateLastUsedDate()
{
    if (deleteDirectoryContents(
            sys::envvars::EnvVarsFactory::createInstance()->tempStorageDir()))
    {
        qDebug() << "Cleared temp directory";
    }

    else
    {
        qDebug() << "Could not clear temp directory";
    }


    m_userManager->setLastUsedDate(m_activeUser->uuid().toStdString());
}

void UserViewModel::setMirrorEnbled(bool isEnabled)
{
    auto loggedInUuid = m_userModelPropertySource->loggedInSurgeonId();
    auto userData = m_userList->getUserData(loggedInUuid);
    if (!userData.has_value())
        return;

    userData.value().mirrorEnabled = isEnabled;
    setUserPreferences(userData.value());
}

void UserViewModel::setTutorialViewed(bool isViewed)
{
    auto loggedInUuid = m_userModelPropertySource->loggedInSurgeonId();
    auto userData = m_userList->getUserData(loggedInUuid);
    if (!userData.has_value())
        return;

    userData.value().tutorialViewed = isViewed;
    setUserPreferences(userData.value());
}

bool UserViewModel::serviceUserExists() const
{
    auto userMap = m_userManager->getUsersMap();

    for (auto const& userElement : userMap)
    {
        auto license = m_userList->getUserLicense(userElement.second.email,
                                                  userElement.second.key);

        if (userElement.second.active && license &&
            license->isLicensed(
                encode(drive::licensing::UserFeatures::ServiceAccess)))
        {
            return true;
        }
    }

    return false;
}

void UserViewModel::validateUserAging()
{
    checkUserExpiration();
}

ActiveUserViewModel* UserViewModel::activeUser() const
{
    return m_activeUser;
}

UserListModel* UserViewModel::userList() const
{
    return m_userList;
}

UserViewModel::PlatformType UserViewModel::platformType() const
{
    return m_platformType;
}

QUrl UserViewModel::logoSource() const
{
    QUrl retLogoUrl = m_platLogoSrc.at(PlatformType::None);
    if (m_platLogoSrc.find(m_platformType) != m_platLogoSrc.end())
    {
        retLogoUrl = m_platLogoSrc.at(m_platformType);
    }
    return retLogoUrl;
}

QString UserViewModel::loggedInUserName() const
{
    return m_userModelPropertySource->loggedInSurgeonName();
}

bool UserViewModel::useMetric() const
{
    auto loggedInUuid = m_userModelPropertySource->loggedInSurgeonId();
    auto userData = m_userList->getUserData(loggedInUuid);
    if (userData.has_value())
        return userData.value().isMetric;

    return false;
}

bool UserViewModel::tutorialViewed() const
{
    auto loggedInUuid = m_userModelPropertySource->loggedInSurgeonId();
    auto userData = m_userList->getUserData(loggedInUuid);
    if (userData.has_value())
        return userData.value().tutorialViewed;

    return false;
}

int UserViewModel::loginAttemptsRemaining() const
{
    if (m_activeUser->uuid().isEmpty())
        return MAX_LOGIN_ATTEMPTS;

    auto userData = m_userManager->getUser(m_activeUser->uuid().toStdString());
    return MAX_LOGIN_ATTEMPTS - userData.failedAuthAttempts;
}

void UserViewModel::updateSelectedUser()
{
    QString selectedUserUuid = m_userModelPropertySource->selectedUser();

    UserData userData = UserData();
    if (!selectedUserUuid.isEmpty())
    {
        auto data = m_userList->getUserData(selectedUserUuid);
        if (data.has_value())
        {
            userData = data.value();
        }
    }

    m_activeUser->setUserData(userData);
    m_userModelPropertySource->setMetricUnitSelection(userData.isMetric);
}

void UserViewModel::handleAlertResponse(const sys::alerts::Alert& alert,
                                        const sys::alerts::Option& option)
{
    if ((drive::alerts::confirmOption == option) ||
            (drive::alerts::dismissOption == option))
    {
        if (alert == alertsMap.at(DriveAlerts::AccountLocked))
        {
            Q_EMIT accountLocked();
        }

        m_alertManager->clearAlert(alert);
    }
}

std::optional<UserData> UserViewModel::getUserData(const QString& email) const
{
    auto emailStr = email.toStdString();
    auto userMap = m_userManager->getUsersMap();
    for (auto const& userElement : userMap)
    {
        if (boost::iequals(emailStr, userElement.second.email))
            return userElement.second;
    }

    return {};
}

bool UserViewModel::setUserPreferences(const UserData &userData)
{
    if (m_userManager->setUserPreferences(userData))
    {
        m_userList->updateUserList();
        updateSelectedUser();
        qDebug() << "User preferences updated successfully for user uuid "
                                  << QString::fromStdString(userData.uuid);
        return true;
    }

    qDebug() << "Failed to update the preferences for user with uuid "
                                  << QString::fromStdString(userData.uuid);
    return false;
}

void UserViewModel::checkUserExpiration()
{
    auto userMap = m_userManager->getUsersMap();
    for (auto const& userElement : userMap)
    {
        if (!userElement.second.active)
            continue;

        auto license = m_userList->getUserLicense(userElement.second.email, userElement.second.key);
        if (license && license->isLicensed(encode(
                           drive::licensing::UserFeatures::ClinicalAccess)))
            continue;

        if (license && license->isLicensed(encode(
                           drive::licensing::UserFeatures::ServiceAccess)))
        {
            const auto& created = userElement.second.created;
            // Skip validating service session duration for manufacturing user
            // and the user without created time
            if (created.empty() ||
                boost::iequals(MANUFACTURING_EMAIL, userElement.second.email))
                continue;

            QDateTime creationTime =
                QDateTime::fromString(QString::fromStdString(created), drive::itf::usermanager::DATE_FORMAT);
            if (creationTime.secsTo(QDateTime::currentDateTime()) < SERVICE_SESSION_TIMEOUT)
                continue;

            qDebug() << "session expired for service user with uuid "
                     << QString::fromStdString(userElement.second.uuid);
        }

        qDebug() << "Deactivating the expired user "
                 << QString::fromStdString(userElement.second.name)
                 << " with uuid "
                 << QString::fromStdString(userElement.second.uuid);
        m_userManager->deactivateLocalUser(userElement.second.uuid);
        if (QString::fromStdString(userElement.second.uuid) ==
                           m_userModelPropertySource->selectedUser())
        {
            m_userModelPropertySource->setUser(QString());
        }
    }
    m_userList->updateUserList();
    updateSelectedUser();
}

}  // namespace drive::viewmodel
