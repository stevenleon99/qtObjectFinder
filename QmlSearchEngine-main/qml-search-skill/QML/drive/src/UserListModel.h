/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#ifndef Q_MOC_RUN
#include <drive/itf/usermanager/IUserManager.h>
#include <gm/util/functional/optional.h>
#include <sys/licensing/client/ILicense.h>
#include <sys/licensing/common/DurationType.h>
#endif

#include <QObject>
#include <QVector>
#include <QAbstractListModel>

/**
 * Class for retrieve and present user details as view model
 */

class UserListModel : public QAbstractListModel
{
    Q_OBJECT

    using UserData = drive::itf::usermanager::UserData;

public:
    enum RoleNames {
        UUid = Qt::UserRole,
        Name,
        Initials,
        Color,
        LastUsed,
        Email,
        Expiration,
        ServiceAccess,
        Active,
    };

    explicit UserListModel(QObject* parent = nullptr);
    explicit UserListModel(std::shared_ptr<drive::itf::usermanager::IUserManager> userManager,
                                                                    QObject* parent = nullptr);
    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role) const override;

    std::optional<UserData> getUserData(const QString& uuid) const;
    std::unique_ptr<const sys::licensing::client::ILicense> getUserLicense(
                       const std::string& email, const std::string& key) const;
    void updateUserList();

signals:
    void userDataChanged();

private:
    sys::licensing::common::DurationType getDurationRemaining(
                       const std::string& email, const std::string& key) const;

    std::shared_ptr<drive::itf::usermanager::IUserManager> m_userManager;
    std::map<std::string, drive::itf::usermanager::UserData> m_userMap;
    QVector<drive::itf::usermanager::UserData> m_userDataList;
    QVector<std::string> m_uuidlist;
};
