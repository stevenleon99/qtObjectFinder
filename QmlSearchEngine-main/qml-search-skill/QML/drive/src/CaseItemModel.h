/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/com/propertysource/CaseItemPropertySource.h>
#include <QObject>

class CaseItemModel : public QObject
{
    Q_OBJECT

    using CaseItemPropertySource = ::drive::com::propertysource::CaseItemPropertySource;
    using CaseOrStudyIdentifier = ::drive::model::CaseOrStudyIdentifier;

    Q_PROPERTY(QString caseId READ caseType NOTIFY caseIdChanged)
    Q_PROPERTY(QString caseType READ caseType NOTIFY caseTypeChanged)
    Q_PROPERTY(QString caseName READ caseName NOTIFY caseNameChanged)
    Q_PROPERTY(int totalImages READ totalImages NOTIFY totalImagesChanged)
    Q_PROPERTY(QDateTime createdTime READ createdTime NOTIFY createdTimeChanged)
    Q_PROPERTY(QDateTime accessedTime READ accessedTime NOTIFY accessedTimeChanged)

public:
    explicit CaseItemModel(const CaseOrStudyIdentifier caseId, QObject* parent = nullptr);

    QString caseId() const;
    QString caseType() const;
    QString caseName() const;
    int totalImages() const;
    QDateTime createdTime() const;
    QDateTime accessedTime() const;

    CaseOrStudyIdentifier getCaseId() const;

signals:
    void caseIdChanged();
    void caseTypeChanged();
    void caseNameChanged();
    void totalImagesChanged();
    void createdTimeChanged();
    void accessedTimeChanged();

private:
    CaseOrStudyIdentifier m_caseId;
    std::unique_ptr<CaseItemPropertySource> m_caseItemPropertySource;
};
