/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */


#include "ScreenshotsViewModel.h"
#include "DriveScreenshots.h"
#include "DriveAlerts.h"

#include <sys/alerts/AlertManagerFactory.h>
#include <gm/util/qt/qt_boost_signals2.h>
#include <sys/config/config.h>

#include <QImage>
#include <QDebug>
#include <QQuickWindow>
#include <QThread>

#include <boost/uuid/uuid.hpp>
#include <boost/uuid/uuid_generators.hpp>
#include <boost/lexical_cast.hpp>
#include <boost/uuid/uuid_io.hpp>

namespace drive::viewmodel {

constexpr char SCREENSHOTS_FOLDER_PREFIX[] = "Screenshots";
constexpr char SCREENSHOT_FILE_PREFIX[] = "Screenshot";
constexpr char SCREENSHOT_TIME_FORMAT[] = "-dd-MMM-yyyy_hh-mm-ss";
constexpr char SCREENSHOTS_FORMAT[] = "PNG";
constexpr char TIME_WITH_MS[] = "_z";

using namespace std::filesystem;
using namespace drive::alerts;

ScreenshotsViewModel::ScreenshotsViewModel(
    std::shared_ptr<sys::alerts::itf::IAlertAggregator> alertViewRegistry,
    QObject* parent)
    : QObject(parent)
    , m_caseSummaryPropertySource(
          std::make_unique<CaseSummaryPropertySource>(parent))
    , m_alertManager(sys::alerts::AlertManagerFactory::createInstance())
    , m_path(screenshotPersistenceDir(
          sys::config::Config::instance()->config.apps().drive().data()))
    , m_screenshotListModel(new ScreenshotListModel(parent))
{
    if (!exists(m_path))
    {
        std::filesystem::create_directories(m_path);
    }

    connect(m_caseSummaryPropertySource.get(),
            &CaseSummaryPropertySource::screenshotsChanged, this,
            &ScreenshotsViewModel::updateScreenshots);
    gm::util::qt::connect(m_alertManager->clearRequested, this,
                          &ScreenshotsViewModel::handleAlertResponse);


    alertViewRegistry->addAlertView(m_alertManager);

    updateScreenshots();
}

void ScreenshotsViewModel::saveScreenshot(QObject* obj)
{
    QQuickWindow* applicationWindow = qobject_cast<QQuickWindow*>(obj);

    if (applicationWindow)
    {
        QImage image = applicationWindow->grabWindow();

        QThread* screenshotThread = QThread::create([=, this]() {
            try
            {
                auto uuid = boost::uuids::random_generator()();

                std::filesystem::path fileName =
                    screenshotFile(m_path, boost::uuids::to_string(uuid));

                qDebug() << "Saving screenshot to path "
                         << QString::fromStdString(fileName.string());
                image.save(QString::fromStdString(fileName.string()),
                           SCREENSHOTS_FORMAT);

                QMetaObject::invokeMethod(
                    this, [=, this] { screenshotCallback({uuid}); });
            }
            catch (std::filesystem::filesystem_error const& e)
            {
                qDebug() << "Failed to capture screenshot. " << e.what();
            }
        });
        connect(screenshotThread, &QThread::finished, screenshotThread,
                &QThread::deleteLater);
        screenshotThread->start();
    }
    else
    {
        qDebug() << "Failed to get QQuickWindow for screenshot";
    }
}

void ScreenshotsViewModel::exportScreenshots(const QString& location)
{
    qDebug() << "Received export location : " << location;

    QThread* screenshotThread = QThread::create([=, this]() {
        m_alertManager->createAlert(
            alertsMap.at(DriveAlerts::ScreenshotsExport));

        bool success = false;
        try
        {
            auto currentTime =
                QDateTime::currentDateTime().toString(SCREENSHOT_TIME_FORMAT);
            auto destPath =
                path(location.toStdString()) /
                (SCREENSHOTS_FOLDER_PREFIX + currentTime.toStdString());

            create_directories(destPath);

            auto screenshots = m_caseSummaryPropertySource->screenshots();
            for (auto screenshot : screenshots)
            {
                auto source =
                    screenshotFile(m_path, screenshot.first.toStdString());

                // Screenshots exported to USB is stored with the file name
                // including screenshot captured date and time. The time
                // includes milliseconds to differentiated the screenshots
                // captured within a second.
                auto screenshotTime = screenshot.second.toString(
                    SCREENSHOT_TIME_FORMAT + QString(TIME_WITH_MS));
                auto destination = screenshotFile(
                    destPath,
                    (SCREENSHOT_FILE_PREFIX + screenshotTime.toStdString()));

                copy(source, destination);
            }

            success = true;
        }
        catch (std::filesystem::filesystem_error const& e)
        {
            qDebug() << "Failed to export screenshots: " << e.what();
        }

        m_alertManager->clearAlert(
            alertsMap.at(DriveAlerts::ScreenshotsExport));

        if (success)
        {
            m_alertManager->createAlert(
                alertsMap.at(DriveAlerts::ScreenshotsExportSuccess));
        }
        else
        {
            m_alertManager->createAlert(
                alertsMap.at(DriveAlerts::ScreenshotsExportFailed));
        }
    });
    connect(screenshotThread, &QThread::finished, screenshotThread,
            &QThread::deleteLater);
    screenshotThread->start();
}

void ScreenshotsViewModel::deleteScreenshot(const QString& screenshotId)
{
    m_caseSummaryPropertySource->removeScreenshot(
        {boost::lexical_cast<boost::uuids::uuid>(screenshotId.toStdString())});
}

void ScreenshotsViewModel::updateScreenshots()
{
    auto screenShots = m_caseSummaryPropertySource->screenshots();
    m_screenshotListModel->setScreenshotList(
        screenShots, [path = m_path](const QString& screenshotId) {
            return screenshotFile(path, screenshotId.toStdString());
        });
}

void ScreenshotsViewModel::screenshotCallback(model::ScreenshotId screenshotId)
{
    m_caseSummaryPropertySource->addScreenshot(screenshotId);
}

void ScreenshotsViewModel::handleAlertResponse(const sys::alerts::Alert& alert,
                                               const sys::alerts::Option&)
{
    m_alertManager->clearAlert(alert);
}

}  // namespace drive::viewmodel
