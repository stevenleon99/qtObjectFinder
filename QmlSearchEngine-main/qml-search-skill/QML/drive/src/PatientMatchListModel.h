/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <PatientItemModel.h>
#include <QAbstractListModel>

class PatientMatchListModel : public QAbstractListModel
{
    Q_OBJECT

    using PatientIdentifier = ::drive::model::PatientIdentifier;

    Q_PROPERTY(QString selectedPatientId READ selectedPatientId NOTIFY selectedPatientIdChanged)

public:
    enum RoleNames {
        PatientId = Qt::UserRole,
        PatientName,
        PatientDob,
        MedicalId
    };

    explicit PatientMatchListModel(QObject* parent = nullptr);

    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role) const override;

    int count() const;
    void replacePatients(const immer::vector<PatientIdentifier>& patientIdList);
    QString selectedPatientId() const;

    Q_INVOKABLE void selectPatient(const QString& patientId);

signals:
    void selectedPatientIdChanged();

private:
    immer::vector<PatientIdentifier> m_patientIdList;
    QList<PatientItemModel*> m_patientItemList;
    QString m_selectedPatientId;
};
