/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include "ScreenshotListModel.h"
#include <drive/com/propertysource/CaseSummaryPropertySource.h>

#include <QObject>

#ifndef Q_MOC_RUN
#include <sys/alerts/itf/IAlertAggregator.h>
#include <sys/alerts/itf/IAlertManager.h>
#include <filesystem>
#endif

namespace drive::viewmodel {

class ScreenshotsViewModel : public QObject
{
    Q_OBJECT

    using CaseSummaryPropertySource =
        ::drive::com::propertysource::CaseSummaryPropertySource;

    Q_PROPERTY(ScreenshotListModel* screenshotList READ screenshotList NOTIFY
                   screenshotListChanged)

public:
    ScreenshotsViewModel(
        std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
        QObject* parent = nullptr);

    ScreenshotListModel* screenshotList() { return m_screenshotListModel; }

    Q_INVOKABLE void saveScreenshot(QObject* obj);
    Q_INVOKABLE void exportScreenshots(const QString& location);
    Q_INVOKABLE void deleteScreenshot(const QString& screenshotId);

signals:
    void screenshotListChanged();

private slots:
    void updateScreenshots();
    void screenshotCallback(model::ScreenshotId screenshotId);
    void handleAlertResponse(const sys::alerts::Alert& alert,
                             const sys::alerts::Option& option);

private:
    std::unique_ptr<CaseSummaryPropertySource> m_caseSummaryPropertySource;
    std::shared_ptr<sys::alerts::itf::IAlertManager> m_alertManager;

    std::filesystem::path m_path;
    ScreenshotListModel* m_screenshotListModel;
};

}  // namespace drive::viewmodel
