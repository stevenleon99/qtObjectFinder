#include <cranialplugin/CranialPluginDataModel.h>
#include <cranialplugin/manifest.h>

#include <procd/cranial/model/ApplicationModel.h>
#include <procd/cranial/propertysources/AppDataPropertySource.h>
#include <procd/cranial/actions/DriveActions.h>
#include <procd/cranial/tools/log.h>
#include <sys/config/config.h>

#include <QDateTime>
#include <QDebug>

#include <boost/lexical_cast.hpp>
#include <boost/uuid/uuid_io.hpp>
#include <exception>

using namespace drive::model;
using sys::config::Config;

CranialPluginDataModel::CranialPluginDataModel(QObject* parent)
    : QObject(parent)
{}

bool CranialPluginDataModel::deleteCase(drive::model::WorkflowCaseId id)
{
    auto homeDir = Config::instance()->config.apps().gpsClientCranial().data();
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

std::optional<drive::model::DriveCaseDataUpdater> CranialPluginDataModel::recoverCase(
    drive::model::WorkflowCaseId id)
{
    SYS_LOG_INFO("Recover case: {}", to_string(id.id));

    auto homeDir = Config::instance()->config.apps().gpsClientCranial().data();
    std::filesystem::path srcDir = homeDir / to_string(id.id);
    if (exists(srcDir))
    {
        // Load latest snapshot
        QString caseFilePath = QString::fromStdString(boost::uuids::to_string(id.id));
        return [res = cranial::actions::restoreLatestDriveSnapshot(caseFilePath)](auto&& original) {
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
CranialPluginDataModel::createNewCase(drive::model::DrivePatientData data)
{
    Q_UNUSED(data);
    std::optional<std::pair<WorkflowCaseId, DriveCaseData>> value = std::nullopt;

    WorkflowCaseId workflowID;
    workflowID.type = cranial::plugin::manifest::DISPLAY_NAME;
    workflowID.id = boost::uuids::random_generator()();

    DriveCaseData driveCaseData;
    driveCaseData.patientData = data.patientData;

    QDateTime dateTime;
    QString caseName = "Cranial Case " + dateTime.currentDateTime().toString("hh:mm ap");
    driveCaseData.caseDetails.name = caseName.toStdString();
    driveCaseData.caseDetails.workflow = workflowID.type;

    return std::make_pair(workflowID, driveCaseData);
}

bool CranialPluginDataModel::exportCase(WorkflowCaseId id, std::filesystem::path destination)
{
    SYS_LOG_INFO("Export case: Id {}, destination {}", to_string(id.id), destination.string());

    auto homeDir = Config::instance()->config.apps().gpsClientCranial().data();
    std::filesystem::path srcDir = homeDir / to_string(id.id);
    if (exists(srcDir))
    {
        copy(srcDir, destination, std::filesystem::copy_options::recursive);
        return true;
    }

    SYS_LOG_ERROR("The case ID passed to exportCase was not found: {}", to_string(id.id));
    return false;
}


bool CranialPluginDataModel::importCase(WorkflowCaseId id, std::filesystem::path source)
{
    SYS_LOG_INFO("Import case: Id {}, source {}", to_string(id.id), source.string());

    auto homeDir = Config::instance()->config.apps().gpsClientCranial().data();
    if (exists(source))
    {
        std::filesystem::path destination = homeDir / to_string(id.id);
        if (exists(destination))
            return false;

        create_directories(destination);
        try
        {
            copy(source, destination, std::filesystem::copy_options::recursive);
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

bool CranialPluginDataModel::caseExists(WorkflowCaseId id)
{
    auto homeDir = Config::instance()->config.apps().gpsClientCranial().data();
    std::filesystem::path srcDir = homeDir / to_string(id.id);
    if (exists(srcDir))
        return true;

    return false;
}
