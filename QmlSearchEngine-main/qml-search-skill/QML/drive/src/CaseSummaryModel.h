/* Copyright (c) Thu 04/09/2020 Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/com/propertysource/CaseSummaryPropertySource.h>

#ifndef Q_MOC_RUN
#include <gm/util/qml/MapListModel.h>
#include <lager/extra/struct.hpp>
#endif

#include <QObject>
#include <QSortFilterProxyModel>
#include <memory>

struct CaseSummaryItem
{
    QString name;
    QString value;
    int displayOrder{0};

    LAGER_STRUCT_NESTED(CaseSummaryItem, name, value, displayOrder);
};

using CaseSummaryList = immer::map<QString, CaseSummaryItem>;
using CaseSummaryListModel = gm::util::qml::MapListModel<CaseSummaryList>;

class CaseSummaryModel : public QObject
{
    Q_OBJECT

    using CaseSummaryPropertySource = ::drive::com::propertysource::CaseSummaryPropertySource;

    Q_PROPERTY(QString caseName READ caseName NOTIFY caseNameChanged)
    Q_PROPERTY(QString caseNotes READ caseNotes NOTIFY caseNotesChanged)
    Q_PROPERTY(QStringList imagePaths READ imagePaths NOTIFY imagePathsChanged)
    Q_PROPERTY(QStringList thumbnailPaths READ thumbnailPaths NOTIFY thumbnailPathsChanged)
    Q_PROPERTY(QStringList tileImagePaths READ tileImagePaths NOTIFY tileImagePathsChanged)
    Q_PROPERTY(QString creatorName READ creatorName NOTIFY creatorNameChanged)
    Q_PROPERTY(QString createdTime READ createdTime NOTIFY createdTimeChanged)
    Q_PROPERTY(QString accessedTime READ accessedTime NOTIFY accessedTimeChanged)
    Q_PROPERTY(QString workflow READ workflow NOTIFY workflowChanged)
    Q_PROPERTY(QString keyDetails READ keyDetails NOTIFY keyDetailsChanged)
    Q_PROPERTY(QString caseType READ caseType NOTIFY caseTypeChanged)
    Q_PROPERTY(QString caseId READ caseId NOTIFY caseIdChanged)
    Q_PROPERTY(QStringList screenshotsIds READ screenshotsIds NOTIFY
                   screenshotsIdsChanged)
    Q_PROPERTY(
        QSortFilterProxyModel* caseSummaryList READ caseSummaryList CONSTANT)

public:
    explicit CaseSummaryModel(QObject* parent = nullptr);

    QString caseName() const;
    QString caseNotes() const;
    QStringList imagePaths() const;
    QStringList thumbnailPaths() const;
    QStringList tileImagePaths() const;
    QString creatorName() const;
    QString createdTime() const;
    QString accessedTime() const;
    QString workflow() const;
    QString keyDetails() const;
    QString caseType() const;
    QString caseId() const;
    QStringList screenshotsIds() const;
    QSortFilterProxyModel* caseSummaryList() const
    {
        return m_sortedCaseSummaryListModel;
    }

    void setKeyDetails(const QString& keyDetails);

    Q_INVOKABLE void setCaseName(const QString& caseName);
    Q_INVOKABLE void setCaseNotes(const QString& caseNotes);
    Q_INVOKABLE void exportSeries();

signals:
    void caseNameChanged();
    void caseNotesChanged();
    void imagePathsChanged();
    void thumbnailPathsChanged();
    void tileImagePathsChanged();
    void creatorNameChanged();
    void createdTimeChanged();
    void accessedTimeChanged();
    void workflowChanged();
    void keyDetailsChanged();
    void caseTypeChanged();
    void caseIdChanged();
    void screenshotsIdsChanged();

private:
    void initSortedModel();
    void updateCaseSummaryListModel(const QJsonArray& caseSummaryArray);

    std::unique_ptr<CaseSummaryPropertySource> m_caseSummaryPropertySource;

    std::shared_ptr<CaseSummaryListModel> m_caseSummaryListModel;
    QSortFilterProxyModel* m_sortedCaseSummaryListModel;
};
