/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "PatientMatchListModel.h"
#include <drive/common/DriveCommon.h>
#include <drive/common/PatientName.h>
#include <QDebug>

PatientMatchListModel::PatientMatchListModel(QObject* parent)
    : QAbstractListModel(parent)
{
}

QHash<int, QByteArray> PatientMatchListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[PatientId] = "role_id";
    roles[PatientName] = "role_name";
    roles[PatientDob] = "role_dateOfBirth";
    roles[MedicalId] = "role_medicalId";

    return roles;
}

int PatientMatchListModel::rowCount(const QModelIndex&) const
{
    return count();
}

QVariant PatientMatchListModel::data(const QModelIndex& index, int role) const
{
    int rowIndex = index.row();

    if (rowIndex < 0 || rowIndex >= m_patientItemList.size())
        return QVariant();

    PatientItemModel* patientItem = m_patientItemList.at(index.row());
    if (!patientItem)
        return QVariant();

    switch(role)
    {
    case PatientId:
        return patientItem->patientId();
    case PatientName:
        return patientItem->patientName();
    case PatientDob:
        return drive::common::formatDateTime(patientItem->dateOfBirth(),
                                             drive::common::DATE_FORMAT);
    case MedicalId: return patientItem->medicalId();
    default:
        return QVariant();
    }
}

int PatientMatchListModel::count() const
{
    return m_patientItemList.count();
}

void PatientMatchListModel::replacePatients(const immer::vector<PatientIdentifier>& patientIdList)
{
    beginResetModel();
    m_selectedPatientId.clear();
    m_patientItemList.clear();
    for (const auto &patientId : patientIdList)
    {
        m_patientItemList += new PatientItemModel(patientId, this);
    }
    endResetModel();
}

QString PatientMatchListModel::selectedPatientId() const
{
    return m_selectedPatientId;
}

void PatientMatchListModel::selectPatient(const QString& patientId)
{
    m_selectedPatientId = patientId;
    selectedPatientIdChanged();
}
