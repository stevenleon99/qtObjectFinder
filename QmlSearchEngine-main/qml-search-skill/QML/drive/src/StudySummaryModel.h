/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/com/propertysource/StudySummaryPropertySource.h>
#include <QObject>

class StudySummaryModel : public QObject
{
    Q_OBJECT

    using StudySummaryPropertySource = ::drive::com::propertysource::StudySummaryPropertySource;

    Q_PROPERTY(QString studyId READ studyId NOTIFY studyIdChanged)
    Q_PROPERTY(QString studyName READ studyName NOTIFY studyNameChanged)
    Q_PROPERTY(QString creatorName READ creatorName NOTIFY creatorNameChanged)
    Q_PROPERTY(QString createdTime READ createdTime NOTIFY createdTimeChanged)
    Q_PROPERTY(QString accessedTime READ accessedTime NOTIFY accessedTimeChanged)

public:
    explicit StudySummaryModel(QObject* parent = nullptr);

    QString studyId() const;
    QString studyName() const;
    QString creatorName() const;
    QString createdTime() const;
    QString accessedTime() const;

    Q_INVOKABLE void setCaseName(const QString& studyName);
    Q_INVOKABLE void deleteStudy();

signals:
    void studyIdChanged();
    void studyNameChanged();
    void creatorNameChanged();
    void createdTimeChanged();
    void accessedTimeChanged();

private:
    std::unique_ptr<StudySummaryPropertySource> m_studySummaryPropertySource;
};
