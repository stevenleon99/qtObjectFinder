/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "CaseListModel.h"
#include <drive/common/DriveCommon.h>

CaseListModel::CaseListModel(QObject* parent)
    : QAbstractListModel(parent)
    , m_casesPropertySource(std::make_unique<CasesPropertySource>(parent))
    , m_caseIdList(m_casesPropertySource->caseIdList())
{
    loadCases();
    connect(m_casesPropertySource.get(),
            &CasesPropertySource::caseIdListChanged, this,
            &CaseListModel::refreshCases);
    connect(m_casesPropertySource.get(),
            &CasesPropertySource::selectedCaseIdStrChanged, this,
            &CaseListModel::selectedCaseIdChanged);
}

QHash<int, QByteArray> CaseListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[CaseId] = "role_id";
    roles[CaseName] = "role_name";
    roles[CaseType] = "role_type";
    roles[TotalImages] = "role_totalImages";
    roles[CreatedTime] = "role_createdTime";
    roles[AccessedTime] = "role_accessedTime";
    roles[CreatedTimeStr] = "role_createdTimeStr";
    roles[AccessedTimeStr] = "role_accessedTimeStr";

    return roles;
}

int CaseListModel::rowCount(const QModelIndex&) const
{
    return count();
}

QVariant CaseListModel::data(const QModelIndex& index, int role) const
{
    int rowIndex = index.row();
    if (rowIndex < 0 || rowIndex >= m_caseItemList.size())
        return QVariant();

    CaseItemModel* caseItem = m_caseItemList.at(index.row());
    if (!caseItem)
        return {};

    switch (role)
    {
    case CaseId: return caseItem->caseId();
    case CaseName: return caseItem->caseName();
    case CaseType: return caseItem->caseType();
    case TotalImages: return caseItem->totalImages();
    case CreatedTime: return caseItem->createdTime();
    case AccessedTime: return caseItem->accessedTime();
    case CreatedTimeStr:
        return drive::common::formatDateTime(caseItem->createdTime(),
                                             drive::common::DATE_FORMAT);
    case AccessedTimeStr:
        return drive::common::formatDateTime(caseItem->accessedTime(),
                                             drive::common::DATE_FORMAT);
    default: return QVariant();
    }
}

int CaseListModel::count() const
{
    return m_caseItemList.count();
}

QString CaseListModel::selectedCaseId() const
{
    return m_casesPropertySource->selectedCaseIdStr();
}

void CaseListModel::selectCase(const QString& caseId)
{
    m_casesPropertySource->selectCase(caseId);
}


int CaseListModel::caseSortedOrder() const
{
    return m_casesPropertySource->caseSortedOrder();
}

QString CaseListModel::caseSortedRoleName() const
{
    return m_casesPropertySource->caseSortedRoleName();
}

void CaseListModel::setCaseSortedOrder(int sortedOrder)
{
    m_casesPropertySource->setCaseSortedOrder(sortedOrder);
}

void CaseListModel::setCaseSortedRoleName(QString sortedRoleName)
{
    m_casesPropertySource->setCaseSortedRoleName(sortedRoleName);
}

void CaseListModel::refreshCases()
{
    if (m_caseItemList.size() == 0)
        return loadCases();

    QList<CaseItemModel*> newItemList;
    beginResetModel();

    for (const auto& caseId : m_casesPropertySource->caseIdList())
    {
        bool found = false;
        for (int index = 0; index < m_caseItemList.size(); index++)
        {
            if (caseId == m_caseItemList.at(index)->getCaseId())
            {
                newItemList += m_caseItemList.takeAt(index);
                found = true;
                break;
            }
        }

        if (!found)
            newItemList += newCase(caseId);
    }

    m_caseItemList = newItemList;

    endResetModel();
    emit countChanged();
}

void CaseListModel::loadCases()
{
    beginResetModel();

    for (const auto& caseId : m_casesPropertySource->caseIdList())
        m_caseItemList += newCase(caseId);

    endResetModel();
    emit countChanged();
}

CaseItemModel* CaseListModel::newCase(const CaseOrStudyIdentifier& caseId)
{
    CaseItemModel* newCaseItem = new CaseItemModel(caseId, this);

    connect(newCaseItem, &CaseItemModel::caseNameChanged, [this, newCaseItem] {
        int itemIndex = m_caseItemList.indexOf(newCaseItem);
        dataChanged(index(itemIndex), index(itemIndex),
                    (QVector<int>() << CaseName));
    });
    connect(newCaseItem, &CaseItemModel::totalImagesChanged,
            [this, newCaseItem] {
                int itemIndex = m_caseItemList.indexOf(newCaseItem);
                dataChanged(index(itemIndex), index(itemIndex),
                            (QVector<int>() << TotalImages));
            });
    connect(newCaseItem, &CaseItemModel::accessedTimeChanged,
            [this, newCaseItem] {
                int itemIndex = m_caseItemList.indexOf(newCaseItem);
                dataChanged(index(itemIndex), index(itemIndex),
                            (QVector<int>() << AccessedTime));
            });

    return newCaseItem;
}
