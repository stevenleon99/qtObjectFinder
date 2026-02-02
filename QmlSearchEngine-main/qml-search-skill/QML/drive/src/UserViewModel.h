/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include "UserListModel.h"
#include "ActiveUserViewModel.h"
#include "DriveAlerts.h"
#include <QUrl>
#ifndef Q_MOC_RUN
#include <drive/itf/usermanager/IUserManager.h>
#include <drive/com/propertysource/UserModelPropertySource.h>
#include <sys/licensing/client/KeyManagerFactory.h>
#include <sys/alerts/itf/IAlertAggregator.h>
#include <sys/alerts/itf/IAlertManager.h>
#include <sys/licensing/client/KeyManagerFactory.h>
#include <unordered_map>
#endif

#include <QObject>

namespace drive::viewmodel {

class UserViewModel : public QObject
{
    Q_OBJECT
    Q_PROPERTY(ActiveUserViewModel* activeUser READ activeUser NOTIFY
                   activeUserChanged)
    Q_PROPERTY(bool isPinAccessAllowed READ isPinAccessAllowed NOTIFY pinAccessAllowedChanged)
    Q_PROPERTY(UserListModel* userList READ userList NOTIFY userListChanged)
    Q_PROPERTY(
        PlatformType platformType READ platformType NOTIFY platformTypeChanged)
    Q_PROPERTY(QString loggedInUserName READ loggedInUserName NOTIFY
                   loggedInUserNameChanged)
    Q_PROPERTY(bool useMetric READ useMetric NOTIFY useMetricChanged)
    Q_PROPERTY(int loginAttemptsRemaining READ loginAttemptsRemaining NOTIFY
                   loginAttemptsRemainingChanged)
    Q_PROPERTY(QUrl logoSource READ logoSource NOTIFY logoSourceChanged)
    Q_PROPERTY(
        bool tutorialViewed READ tutorialViewed NOTIFY tutorialViewedChanged)

public:
    explicit UserViewModel(
        std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
        QObject* parent = nullptr);


    enum class PlatformType
    {
        None = -1,
        Egps = 0, //!< ExcelsiusGPS Surgical Robot
        E3d = 1, //!< Excelsius3D Imaging System
        Ehub = 2, //!< ExcelsiusHub Navigation Platform
        Exr = 3, //!< ExcelsiusXR AR Headset
        Laptop = 4 //!< Laptop or desktop system
    };
    Q_ENUMS(PlatformType)


    const std::unordered_map<UserViewModel::PlatformType, QUrl> m_platLogoSrc =
        {{UserViewModel::PlatformType::None, QUrl("")},
         {UserViewModel::PlatformType::Egps,
          QUrl("qrc:/images/ExcelsiusGPSLogo")},
         {UserViewModel::PlatformType::Ehub,
          QUrl("qrc:/images/ExcelsiusHUBLogo")},
         {UserViewModel::PlatformType::Laptop,
          QUrl("qrc:/images/ExcelsiusLaptopLogo")}};

    Q_INVOKABLE void setActiveUser(const QString& activeUserUuid);

    Q_INVOKABLE bool isPinAccessAllowed() const;

    Q_INVOKABLE bool createUser(const QString& emailStr,
                                const QString& activationKey,
                                const QString& name,
                                const QString& initials,
                                const QString& color,
                                const QString& pin,
                                const QString& password,
                                bool pinPreferred);

    Q_INVOKABLE bool setUserPin(const QString& uuid,
                                const QString& password,
                                const QString& pin);

    Q_INVOKABLE bool setUserPassword(const QString& uuid,
                                     const QString& oldPassword,
                                     const QString& newPassword);

    Q_INVOKABLE bool setUserPreferences(const QString& uuid,
                                        const QString& name,
                                        const QString& initials,
                                        const QString& color);

    Q_INVOKABLE bool login(const QString& code);
    Q_INVOKABLE void loginServiceUser(const QString& uuid, const QString& name);
    Q_INVOKABLE void logOff();
    Q_INVOKABLE bool validateActivationKey(const QString& emailStr,
                                           const QString& activationKey);
    Q_INVOKABLE bool activeUserAvailable(const QString& emailStr) const;
    Q_INVOKABLE bool isServiceUserKey(const QString& emailStr,
                                      const QString& activationKey);
    Q_INVOKABLE bool setEmailAndActivationKey(const QString& password,
                                              const QString& emailStr,
                                              const QString& activationKey);
    Q_INVOKABLE void changePassword(const QString& uuid,
                                    const QString& password);
    Q_INVOKABLE void setPinPreferred(const QString& uuid, bool pinPreferred);
    Q_INVOKABLE bool authenticatePassword(const QString& password);
    Q_INVOKABLE void setUseMetric(bool useMetric);
    Q_INVOKABLE void setPinAccess(bool pinAccess);
    Q_INVOKABLE void deactivateUser(const QString& uuid);
    Q_INVOKABLE void updateLastUsedDate();
    Q_INVOKABLE void setMirrorEnbled(bool isEnabled);
    Q_INVOKABLE void setTutorialViewed(bool isViewed);

    bool serviceUserExists() const;

    /**
     * Validate and deactivates the expired users
     */
    Q_INVOKABLE void validateUserAging();

    // Q_PROPERTY READ
    ActiveUserViewModel* activeUser() const;
    UserListModel* userList() const;
    PlatformType platformType() const;
    QString loggedInUserName() const;
    bool useMetric() const;
    QUrl logoSource() const;
    bool tutorialViewed() const;

    /**
     * Returns the available login attempts for selected user
     */
    int loginAttemptsRemaining() const;

signals:
    void serviceUserCountChanged();

    // Q_PROPERTY NOTIFY
    void activeUserChanged();
    void pinAccessAllowedChanged();
    void userListChanged();
    void platformTypeChanged(const PlatformType& platformType);
    void loggedInUserNameChanged();
    void useMetricChanged();
    void loginAttemptsRemainingChanged();
    void accountLocked();
    void logoSourceChanged();
    void tutorialViewedChanged();

private slots:
    void updateSelectedUser();
    void handleAlertResponse(const sys::alerts::Alert& alert,
                             const sys::alerts::Option&);
    void onPinAccessSettingChanged(bool);

private:
    void getPlatformType();
    std::optional<drive::itf::usermanager::UserData> getUserData(
        const QString& email) const;
    bool setUserPreferences(const drive::itf::usermanager::UserData& userData);
    void checkUserExpiration();
    void setPinAccessAllowed();
    bool m_isPinAccessAllowed = true;
    bool deleteDirectoryContents(const std::filesystem::path& dir);

    std::shared_ptr<drive::itf::usermanager::IUserManager> m_userManager{
        nullptr};
    std::unique_ptr<drive::com::propertysource::UserModelPropertySource>
        m_userModelPropertySource{nullptr};
    std::shared_ptr<sys::licensing::client::IKeyManager> m_keyManager;
    std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertManager;

    // Q_PROPERTY MEMBER
    ActiveUserViewModel* m_activeUser;
    UserListModel* m_userList;
    PlatformType m_platformType = PlatformType::None;
};

}  // namespace drive::viewmodel
