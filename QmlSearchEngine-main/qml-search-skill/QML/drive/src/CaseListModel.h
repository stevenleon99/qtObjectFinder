/* Copyright (c) Thu 04/09/2020 Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/com/propertysource/CasesPropertySource.h>
#include <CaseItemModel.h>
#include <QAbstractListModel>

class CaseListModel : public QAbstractListModel
{
    Q_OBJECT

    using CasesPropertySource =
        ::drive::com::propertysource::CasesPropertySource;
    using CaseOrStudyIdentifier = ::drive::model::CaseOrStudyIdentifier;

    Q_PROPERTY(int count READ count NOTIFY countChanged)
    Q_PROPERTY(
        QString selectedCaseId READ selectedCaseId NOTIFY selectedCaseIdChanged)

    Q_PROPERTY(QString caseSortedRoleName READ caseSortedRoleName NOTIFY
                   caseSortedRoleNameChanged)

    Q_PROPERTY(
        int caseSortedOrder READ caseSortedOrder NOTIFY caseSortedOrderChanged)

public:
    enum RoleNames
    {
        CaseId = Qt::UserRole,
        CaseName,
        CaseType,
        TotalImages,
        CreatedTime,
        AccessedTime,
        CreatedTimeStr,
        AccessedTimeStr
    };

    explicit CaseListModel(QObject* parent = nullptr);

    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role) const override;

    int count() const;
    QString selectedCaseId() const;

    Q_INVOKABLE void selectCase(const QString& caseId);

    int caseSortedOrder() const;
    QString caseSortedRoleName() const;

    Q_INVOKABLE void setCaseSortedOrder(int sortedOrder);
    Q_INVOKABLE void setCaseSortedRoleName(QString sortedRoleName);

signals:
    void countChanged();
    void selectedCaseIdChanged();
    void caseSortedOrderChanged();
    void caseSortedRoleNameChanged();
private slots:
    void refreshCases();

private:
    std::unique_ptr<CasesPropertySource> m_casesPropertySource;
    immer::vector<CaseOrStudyIdentifier> m_caseIdList;
    QList<CaseItemModel*> m_caseItemList;

    void loadCases();
    CaseItemModel* newCase(const CaseOrStudyIdentifier& caseId);
};
