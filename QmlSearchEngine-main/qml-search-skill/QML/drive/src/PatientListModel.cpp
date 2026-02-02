/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "PatientListModel.h"
#include <drive/common/DriveCommon.h>

PatientListModel::PatientListModel(QObject* parent)
    : QAbstractListModel(parent)
    , m_patientsPropertySource(std::make_unique<PatientsPropertySource>(parent))
{
    loadPatients();
    connect(m_patientsPropertySource.get(),
            &PatientsPropertySource::patientIdListChanged, this,
            &PatientListModel::refreshPatients);
    connect(m_patientsPropertySource.get(),
            &PatientsPropertySource::selectedPatientIdStrChanged, this,
            &PatientListModel::selectedPatientIdChanged);
}

QHash<int, QByteArray> PatientListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[PatientId] = "role_id";
    roles[PatientName] = "role_name";
    roles[TotalCase] = "role_totalCases";
    roles[CreatedTime] = "role_createdTime";
    roles[AccessedTime] = "role_accessedTime";
    roles[CreatedTimeStr] = "role_createdTimeStr";
    roles[AccessedTimeStr] = "role_accessedTimeStr";

    return roles;
}

int PatientListModel::rowCount(const QModelIndex&) const
{
    return count();
}

QVariant PatientListModel::data(const QModelIndex& index, int role) const
{
    int rowIndex = index.row();

    if (rowIndex < 0 || rowIndex >= m_patientItemList.size())
        return QVariant();

    PatientItemModel* patientItem = m_patientItemList.at(index.row());
    if (!patientItem)
        return {};

    switch (role)
    {
    case PatientId: return patientItem->patientId();
    case PatientName: return patientItem->patientName();
    case TotalCase: return patientItem->totalCases();
    case CreatedTime: return patientItem->createdTime();
    case AccessedTime: return patientItem->accessedTime();
    case CreatedTimeStr:
        return drive::common::formatDateTime(patientItem->createdTime(),
                                             drive::common::DATE_FORMAT);
    case AccessedTimeStr:
        return drive::common::formatDateTime(patientItem->accessedTime(),
                                             drive::common::DATE_FORMAT);
    default: return QVariant();
    }
}

int PatientListModel::count() const
{
    return m_patientItemList.count();
}

QString PatientListModel::selectedPatientId() const
{
    return m_patientsPropertySource->selectedPatientIdStr();
}

void PatientListModel::selectPatient(const QString& patientId)
{
    m_patientsPropertySource->selectPatient(patientId);
}

int PatientListModel::patientSortedOrder() const
{
    return m_patientsPropertySource->patientSortedOrder();
}

QString PatientListModel::patientSortedRoleName() const
{
    return m_patientsPropertySource->patientSortedRoleName();
}

void PatientListModel::setPatientSortedOrder(int sortedOrder)
{
    m_patientsPropertySource->setPatientSortedOrder(sortedOrder);
}

void PatientListModel::setPatientSortedRoleName(QString sortedRoleName)
{
    m_patientsPropertySource->setPatientSortedRoleName(sortedRoleName);
}

void PatientListModel::refreshPatients()
{
    if (m_patientItemList.size() == 0)
        return loadPatients();

    QList<PatientItemModel*> newItemList;
    beginResetModel();

    for (const auto& patientId : m_patientsPropertySource->patientIdList())
    {
        bool found = false;
        for (int index = 0; index < m_patientItemList.size(); index++)
        {
            if (patientId == m_patientItemList.at(index)->getPatientId())
            {
                newItemList += m_patientItemList.takeAt(index);
                found = true;
                break;
            }
        }

        if (!found)
            newItemList += newPatient(patientId);
    }

    m_patientItemList = newItemList;

    endResetModel();
    emit countChanged();
}


void PatientListModel::loadPatients()
{
    beginResetModel();

    for (const auto& patientId : m_patientsPropertySource->patientIdList())
        m_patientItemList += newPatient(patientId);

    endResetModel();
    emit countChanged();
}

PatientItemModel* PatientListModel::newPatient(
    const PatientIdentifier& patientId)
{
    PatientItemModel* newPatientItem = new PatientItemModel(patientId, this);

    connect(newPatientItem, &PatientItemModel::patientNameChanged,
            [this, newPatientItem] {
                int itemIndex = m_patientItemList.indexOf(newPatientItem);
                dataChanged(index(itemIndex), index(itemIndex),
                            (QVector<int>() << PatientName));
            });
    connect(newPatientItem, &PatientItemModel::totalCasesChanged,
            [this, newPatientItem] {
                int itemIndex = m_patientItemList.indexOf(newPatientItem);
                dataChanged(index(itemIndex), index(itemIndex),
                            (QVector<int>() << TotalCase));
            });
    connect(newPatientItem, &PatientItemModel::accessedTimeChanged,
            [this, newPatientItem] {
                int itemIndex = m_patientItemList.indexOf(newPatientItem);
                dataChanged(index(itemIndex), index(itemIndex),
                            (QVector<int>() << AccessedTime));
            });

    return newPatientItem;
}
