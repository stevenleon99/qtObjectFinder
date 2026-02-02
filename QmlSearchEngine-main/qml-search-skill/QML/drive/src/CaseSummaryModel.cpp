/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "CaseSummaryModel.h"
#include <drive/common/DriveCommon.h>

#include <gm/util/qt/ranges.h>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

CaseSummaryModel::CaseSummaryModel(QObject* parent)
    : QObject(parent)
    , m_caseSummaryPropertySource(
          std::make_unique<CaseSummaryPropertySource>(parent))
    , m_caseSummaryListModel{std::make_shared<CaseSummaryListModel>()}
    , m_sortedCaseSummaryListModel(new QSortFilterProxyModel(this))
{
    connect(m_caseSummaryPropertySource.get(), &CaseSummaryPropertySource::caseNameChanged,
                                                               this, &CaseSummaryModel::caseNameChanged);
    connect(m_caseSummaryPropertySource.get(), &CaseSummaryPropertySource::caseNotesChanged,
                                                               this, &CaseSummaryModel::caseNotesChanged);
    connect(m_caseSummaryPropertySource.get(), &CaseSummaryPropertySource::caseCreatorChanged,
                                                               this, &CaseSummaryModel::creatorNameChanged);
    connect(m_caseSummaryPropertySource.get(), &CaseSummaryPropertySource::tileImagePathsChanged,
                                                               this, &CaseSummaryModel::tileImagePathsChanged);
    connect(m_caseSummaryPropertySource.get(), &CaseSummaryPropertySource::thumbnailImagePathsChanged,
                                                               this, &CaseSummaryModel::thumbnailPathsChanged);
    connect(m_caseSummaryPropertySource.get(), &CaseSummaryPropertySource::fullscreenImagePathsChanged,
                                                               this, &CaseSummaryModel::imagePathsChanged);
    connect(m_caseSummaryPropertySource.get(), &CaseSummaryPropertySource::createdTimeChanged,
                                                               this, &CaseSummaryModel::createdTimeChanged);
    connect(m_caseSummaryPropertySource.get(), &CaseSummaryPropertySource::accessedTimeChanged,
                                                               this, &CaseSummaryModel::accessedTimeChanged);
    connect(m_caseSummaryPropertySource.get(), &CaseSummaryPropertySource::workflowChanged,
                                                               this, &CaseSummaryModel::workflowChanged);
    connect(m_caseSummaryPropertySource.get(),
            &CaseSummaryPropertySource::keyDetailsChanged, this,
            &CaseSummaryModel::setKeyDetails);
    connect(m_caseSummaryPropertySource.get(), &CaseSummaryPropertySource::caseIdStrChanged,
                                                               this, &CaseSummaryModel::caseIdChanged);
    connect(m_caseSummaryPropertySource.get(),
            &CaseSummaryPropertySource::screenshotsChanged, this,
            &CaseSummaryModel::screenshotsIdsChanged);

    initSortedModel();
    setKeyDetails(m_caseSummaryPropertySource->keyDetails());
}

QString CaseSummaryModel::caseName() const
{
    return m_caseSummaryPropertySource->caseName();
}

QString CaseSummaryModel::caseNotes() const
{
    return m_caseSummaryPropertySource->caseNotes();
}

QStringList CaseSummaryModel::imagePaths() const
{
    return m_caseSummaryPropertySource->fullscreenImagePaths();
}

QStringList CaseSummaryModel::thumbnailPaths() const
{
    return m_caseSummaryPropertySource->thumbnailImagePaths();
}

QStringList CaseSummaryModel::tileImagePaths() const
{
    return m_caseSummaryPropertySource->tileImagePaths();
}

QString CaseSummaryModel::creatorName() const
{
    return m_caseSummaryPropertySource->caseCreator();
}

QString CaseSummaryModel::createdTime() const
{
    return drive::common::formatDateTime(
        m_caseSummaryPropertySource->createdTime(), drive::common::TIME_FORMAT);
}

QString CaseSummaryModel::accessedTime() const
{
    return drive::common::formatDateTime(
        m_caseSummaryPropertySource->accessedTime(),
        drive::common::TIME_FORMAT);
}

QString CaseSummaryModel::workflow() const
{
    return m_caseSummaryPropertySource->workflow();
}

QString CaseSummaryModel::keyDetails() const
{
    return m_caseSummaryPropertySource->keyDetails();
}

QString CaseSummaryModel::caseType() const
{
    return m_caseSummaryPropertySource->caseType();
}

QString CaseSummaryModel::caseId() const
{
    return m_caseSummaryPropertySource->caseIdStr();
}

void CaseSummaryModel::setCaseName(const QString& caseName)
{
    m_caseSummaryPropertySource->setCaseName(caseName);
}

void CaseSummaryModel::setCaseNotes(const QString& caseNotes)
{
    m_caseSummaryPropertySource->setCaseNotes(caseNotes);
}

void CaseSummaryModel::exportSeries()
{
    auto studyName = "Study_" + caseName() + "_" + QDateTime::currentDateTime().toString("yyyy.MM.dd_hh:mm:ss");
    m_caseSummaryPropertySource->exportSeries(studyName);
}

QStringList CaseSummaryModel::screenshotsIds() const
{
    QStringList allScreenShotsIds;

    auto listScreenshotsIds = m_caseSummaryPropertySource->screenshots();

    for (auto screenshot : listScreenshotsIds)
    {
        allScreenShotsIds.push_back(screenshot.first);
    }

    return allScreenShotsIds;
}

void CaseSummaryModel::setKeyDetails(const QString& keyDetails)
{
    using drive::model::CASE_SUMMARY_PROPERTY;

    QJsonArray caseSummaryArray;
    QJsonDocument jsonDoc = QJsonDocument::fromJson(keyDetails.toUtf8());

    if (!jsonDoc.isNull())
    {
        QJsonObject jsonObj = jsonDoc.object();

        if (jsonObj.contains(CASE_SUMMARY_PROPERTY) &&
            jsonObj[CASE_SUMMARY_PROPERTY].isArray())
        {
            caseSummaryArray = jsonObj[CASE_SUMMARY_PROPERTY].toArray();
        }
    }

    updateCaseSummaryListModel(caseSummaryArray);
}

void CaseSummaryModel::initSortedModel()
{
    using gm::util::qt::ranges::keyValues;

    m_sortedCaseSummaryListModel->setSourceModel(
        m_caseSummaryListModel->abstractListModel());

    static constexpr char DISPLAY_ORDER_ROLE[] = "role_displayOrder";
    static constexpr int SORT_COLUMN_INDEX = 0;
    int displayOrderRoleKey = -1;

    auto roles = m_sortedCaseSummaryListModel->roleNames();
    for (auto&& [key, value] : keyValues(roles))
    {
        if (value == DISPLAY_ORDER_ROLE)
        {
            displayOrderRoleKey = key;
            break;
        }
    }

    m_sortedCaseSummaryListModel->setSortRole(displayOrderRoleKey);
    m_sortedCaseSummaryListModel->sort(SORT_COLUMN_INDEX, Qt::AscendingOrder);
}

void CaseSummaryModel::updateCaseSummaryListModel(
    const QJsonArray& caseSummaryArray)
{
    using drive::model::ITEM_NAME_PROPERTY;
    using drive::model::ITEM_ORDER_PROPERTY;
    using drive::model::ITEM_VALUE_PROPERTY;

    CaseSummaryList caseSummaryList;
    for (const QJsonValue& arrayItem : caseSummaryArray)
    {
        CaseSummaryItem caseSummaryItem;
        QJsonObject itemObj = arrayItem.toObject();
        if (itemObj.contains(ITEM_NAME_PROPERTY))
        {
            caseSummaryItem.name = itemObj[ITEM_NAME_PROPERTY].toString();
        }

        if (itemObj.contains(ITEM_VALUE_PROPERTY))
        {
            caseSummaryItem.value = itemObj[ITEM_VALUE_PROPERTY].toString();
        }

        if (itemObj.contains(ITEM_ORDER_PROPERTY))
        {
            caseSummaryItem.displayOrder = itemObj[ITEM_ORDER_PROPERTY].toInt();
        }

        caseSummaryList =
            caseSummaryList.set(caseSummaryItem.name, caseSummaryItem);
    }

    m_caseSummaryListModel->update(caseSummaryList);
}
