/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/com/propertysource/PatientsPropertySource.h>
#include <PatientItemModel.h>
#include <QAbstractListModel>

class PatientListModel : public QAbstractListModel
{
    Q_OBJECT

    using PatientsPropertySource =
        ::drive::com::propertysource::PatientsPropertySource;
    using PatientIdentifier = ::drive::model::PatientIdentifier;

    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(QString selectedPatientId READ selectedPatientId NOTIFY
                   selectedPatientIdChanged)

    Q_PROPERTY(QString patientSortedRoleName READ patientSortedRoleName NOTIFY
                   patientSortedRoleNameChanged)

    Q_PROPERTY(int patientSortedOrder READ patientSortedOrder NOTIFY
                   patientSortedOrderChanged)

public:
    enum RoleNames
    {
        PatientId = Qt::UserRole,
        PatientName,
        TotalCase,
        CreatedTime,
        AccessedTime,
        CreatedTimeStr,
        AccessedTimeStr
    };

    explicit PatientListModel(QObject* parent = nullptr);

    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role) const override;

    int count() const;
    QString selectedPatientId() const;

    Q_INVOKABLE void selectPatient(const QString& patientId);

    int patientSortedOrder() const;
    QString patientSortedRoleName() const;

    Q_INVOKABLE void setPatientSortedOrder(int sortedOrder);
    Q_INVOKABLE void setPatientSortedRoleName(QString sortedRoleName);

signals:
    void countChanged();
    void selectedPatientIdChanged();
    void patientSortedOrderChanged();
    void patientSortedRoleNameChanged();

private slots:
    void refreshPatients();

private:
    std::unique_ptr<PatientsPropertySource> m_patientsPropertySource;
    immer::vector<PatientIdentifier> m_patientIdList;
    QList<PatientItemModel*> m_patientItemList;

    void loadPatients();
    PatientItemModel* newPatient(const PatientIdentifier& patientId);
};
