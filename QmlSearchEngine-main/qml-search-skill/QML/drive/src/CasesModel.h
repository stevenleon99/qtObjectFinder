/* Copyright (c) Thu 04/09/2020 Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include "CaseListModel.h"
#include "CaseSummaryModel.h"
#include <drive/com/propertysource/CasesPropertySource.h>
#include <QObject>

class CasesModel: public QObject
{
    Q_OBJECT

    using CasesPropertySource = ::drive::com::propertysource::CasesPropertySource;

    Q_PROPERTY(QString patientName READ patientName NOTIFY patientNameChanged)
    Q_PROPERTY(QString selectedCaseId READ selectedCaseId NOTIFY selectedCaseIdChanged)
    Q_PROPERTY(QString selectedCaseType READ selectedCaseType NOTIFY selectedCaseTypeChanged)
    
public:
    explicit CasesModel(QObject *parent = nullptr);

    QString patientName() const;
    QString selectedCaseId() const;
    QString selectedCaseType() const;

signals:
    void patientNameChanged();
    void selectedCaseIdChanged();
    void selectedCaseTypeChanged();

private:
    std::unique_ptr<CasesPropertySource> m_casesPropertySource;
};
