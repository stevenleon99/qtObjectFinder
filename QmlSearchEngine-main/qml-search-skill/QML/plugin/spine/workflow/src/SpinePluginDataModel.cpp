#include <spineplugin/SpinePluginDataModel.h>
#include <spineplugin/manifest.h>

#include <procd/spine/model/ApplicationModel.h>
#include <procd/spine/propertysources/AppDataPropertySource.h>
#include <procd/spine/actions/DriveActions.h>
#include <procd/common/util/tools/log.h>
#include <sys/config/config.h>

#include <QDateTime>
#include <QDebug>

#include <boost/lexical_cast.hpp>
#include <boost/uuid/uuid_io.hpp>

using namespace drive::model;
using sys::config::Config;

SpinePluginDataModel::SpinePluginDataModel(QObject* parent)
    : QObject(parent)
{}

bool SpinePluginDataModel::deleteCase(drive::model::WorkflowCaseId id)
{
    auto homeDir = Config::instance()->config.apps().gpsClientSpine().data();
    std::filesystem::path srcDir = homeDir / to_string(id.id);
    if (exists(srcDir))
    {
        try
        {
            remove_all(srcDir);
        }
        catch (std::exception& e)
        {
            SYS_LOG_ERROR("Failed to delete case directory: {}", e.what());
            return false;
        }

        return true;
    }
    else
    {
        SYS_LOG_ERROR("Failed to delete case directory, doesn't exist: {}", srcDir);
    }

    return false;
}

std::optional<drive::model::DriveCaseDataUpdater> SpinePluginDataModel::recoverCase(
    drive::model::WorkflowCaseId id)
{
    SYS_LOG_INFO("Recover case: {}", to_string(id.id));

    auto homeDir = Config::instance()->config.apps().gpsClientSpine().data();
    std::filesystem::path srcDir = homeDir / to_string(id.id);
    if (exists(srcDir))
    {
        // Load latest snapshot
        QString caseFilePath = QString::fromStdString(boost::uuids::to_string(id.id));
        return [res = spine::actions::restoreLatestDriveSnapshot(caseFilePath)](auto&& original) {
            return res ? *res : original;
        };
    }
    else
    {
        SYS_LOG_ERROR("The case ID passed to recoverCase was not found: {}", to_string(id.id));
        return std::nullopt;
    }
}

std::optional<std::pair<drive::model::WorkflowCaseId, drive::model::DriveCaseData>>
SpinePluginDataModel::createNewCase(drive::model::DrivePatientData data)
{
    Q_UNUSED(data);
    std::optional<std::pair<WorkflowCaseId, DriveCaseData>> value = std::nullopt;

    WorkflowCaseId workflowID;
    workflowID.type = spine::plugin::manifest::DISPLAY_NAME;
    workflowID.id = boost::uuids::random_generator()();

    DriveCaseData driveCaseData;
    driveCaseData.patientData = data.patientData;

    QDateTime dateTime;
    QString caseName = "Spine Case " + dateTime.currentDateTime().toString("hh:mm ap");
    driveCaseData.caseDetails.name = caseName.toStdString();
    driveCaseData.caseDetails.workflow = workflowID.type;

    return std::make_pair(workflowID, driveCaseData);
}

bool SpinePluginDataModel::exportCase(WorkflowCaseId id, std::filesystem::path destination)
{
    SYS_LOG_INFO("Export case: Id {}, destination {}", to_string(id.id), destination.string());

    auto homeDir = Config::instance()->config.apps().gpsClientSpine().data();
    std::filesystem::path srcDir = homeDir / to_string(id.id);
    std::filesystem::path surgeonSettingsFile = homeDir / "SurgeonSettings.ini";
    if (exists(srcDir))
    {
        try
        {
            copy(srcDir, destination, std::filesystem::copy_options::recursive);
            if (std::filesystem::exists(surgeonSettingsFile))
            {
                copy(surgeonSettingsFile, destination);
            }
            return true;
        }
        catch (std::filesystem::filesystem_error& e)
        {
            SYS_LOG_ERROR("Failed to copy case directory: {}", e.what());
            return false;
        }
    }

    SYS_LOG_ERROR("The case ID passed to exportCase was not found: {}", to_string(id.id));
    return false;
}


bool SpinePluginDataModel::importCase(WorkflowCaseId id, std::filesystem::path source)
{
    SYS_LOG_INFO("Import case: Id {}, source {}", to_string(id.id), source.string());

    auto homeDir = Config::instance()->config.apps().gpsClientSpine().data();
    if (exists(source))
    {
        std::filesystem::path destination = homeDir / to_string(id.id);
        if (exists(destination))
            return false;

        create_directories(destination);
        try
        {
            copy(source, destination, std::filesystem::copy_options::recursive);

            // Prevent the Surgeon Settings file from being copied to the case directory.
            // The exported version is just for case investigations. The user's current
            // settings should never be overwritten.
            std::filesystem::remove(destination / "SurgeonSettings.ini");
            return true;
        }
        catch (std::exception& e)
        {
            SYS_LOG_ERROR("Failed to copy case directory: {}", e.what());
        }
    }

    SYS_LOG_ERROR("Failed to import case with case ID: {}", to_string(id.id));
    return false;
}

bool SpinePluginDataModel::caseExists(WorkflowCaseId id)
{
    auto homeDir = Config::instance()->config.apps().gpsClientSpine().data();
    std::filesystem::path srcDir = homeDir / to_string(id.id);
    if (exists(srcDir))
        return true;

    return false;
}
