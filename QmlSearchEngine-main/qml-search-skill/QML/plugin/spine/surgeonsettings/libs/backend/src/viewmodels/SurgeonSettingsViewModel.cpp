#include <apps/spine/backend/SurgeonSettingsViewModel.h>

#include <procd/spine/managers/IocManager.h>
#include <procd/spine/managers/ToolboxManager.h>
#include <procd/spine/tools/SurgeonSettingsTools.h>
#include <gm/util/qt/typeconv.h>
#include <QDebug>

using namespace spine::tools;
using ::gm::util::typeconv::convert;
using ::spine::types::enums::PairingSystemType;


SurgeonSettingsViewModel::SurgeonSettingsViewModel(::drive::model::SurgeonIdentifier surgeonId,
                                                   QObject* parent)
    : QObject(parent)
    , m_toolboxManager{spine::iocmanager::resolveContainer<spine::managers::ToolboxManager>()}
    , m_settings{QSettings(surgeonSettingsFile(), QSettings::IniFormat, this)}
    , m_arrayTypeListModel(std::make_shared<ArrayTypeListModel>())
{
    m_settings.beginGroup(convert<QString>(to_string(surgeonId.id)));
    updateArrayTypeList();
}

void SurgeonSettingsViewModel::toggleInvalidShotsDisplay()
{
    m_settings.setValue(surgeonsettingnames::SHOW_INVALID_SHOTS, !displayInvalidShots());
    emit displayInvalidShotsChanged();
}

void SurgeonSettingsViewModel::toggleIctUnstableAlertDisplay()
{
    m_settings.setValue(surgeonsettingnames::ICT_DISPLAY_UNSTABLE_ALERT,
                        !displayIctUnstableAlert());
    emit displayIctUnstableAlertChanged();
}

void SurgeonSettingsViewModel::toggleReduceBackoffDistance()
{
    m_settings.setValue(surgeonsettingnames::REDUCE_BACKOFF_DISTANCE, !reduceBackoffDistance());
    emit reduceBackoffDistanceChanged();
}

void SurgeonSettingsViewModel::toggleArrayType(surgeonsettings::ArrayType arrayType)
{
    auto enabledPairingSystems = getEnabledPairingSystems();

    for (auto&& systemType : toPairingSystemType(arrayType))
    {
        if (enabledPairingSystems.contains(systemType))
        {
            enabledPairingSystems.erase(systemType);
        }
        else
        {
            enabledPairingSystems.insert(systemType);
        }
    }

    QStringList systemStringList;
    for (auto&& system : enabledPairingSystems)
    {
        systemStringList.append(convert<QString>(system));
    }
    m_settings.setValue(surgeonsettingnames::ENABLED_PAIRING_SYSTEMS, systemStringList);

    updateArrayTypeList();
}

void SurgeonSettingsViewModel::updateCrosshairsOpacity(int opacity)
{
    if (opacity < surgeonsettingconsts::MIN_OPACITY || opacity > surgeonsettingconsts::MAX_OPACITY)
    {
        SYS_LOG_DEBUG("Skip setting out of range implant cad opacity {}", opacity);
        return;
    }

    m_settings.setValue(surgeonsettingnames::CROSSHAIRS_OPACITY, opacity);
    emit crosshairsOpacityChanged();
}

void SurgeonSettingsViewModel::updateimplantCadOpacity(int opacity)
{
    if (opacity < surgeonsettingconsts::MIN_CAD_OPACITY ||
        opacity > surgeonsettingconsts::MAX_OPACITY)
    {
        SYS_LOG_DEBUG("Skip setting out of range implant cad opacity {}", opacity);
        return;
    }

    m_settings.setValue(surgeonsettingnames::IMPLANT_CAD_OPACITY, opacity);
    emit implantCadOpacityChanged();
}

void SurgeonSettingsViewModel::updateinstrumentCadOpacity(int opacity)
{
    if (opacity < surgeonsettingconsts::MIN_CAD_OPACITY ||
        opacity > surgeonsettingconsts::MAX_OPACITY)
    {
        SYS_LOG_DEBUG("Skip setting out of range instrument cad opacity {}", opacity);
        return;
    }

    m_settings.setValue(surgeonsettingnames::INSTRUMENT_CAD_OPACITY, opacity);
    emit instrumentCadOpacityChanged();
}

void SurgeonSettingsViewModel::toggleDisplayTrajectoryLine()
{
    m_settings.setValue(surgeonsettingnames::TOOLTIP_CAD_LINE_VISIBLE, !displayTrajectoryLine());
    emit displayTrajectoryLineChanged();
}

bool SurgeonSettingsViewModel::displayInvalidShots() const
{
    auto settingValue = m_settings.value(surgeonsettingnames::SHOW_INVALID_SHOTS);
    if (settingValue.isValid() && settingValue.canConvert<bool>())
    {
        return settingValue.toBool();
    }

    SYS_LOG_DEBUG("Failed to get show invalid shots surgeon setting. Returning default value {}",
                  surgeonsettingdefaults::DEFAULT_SHOW_INVALID_SHOTS);
    return surgeonsettingdefaults::DEFAULT_SHOW_INVALID_SHOTS;
}

bool SurgeonSettingsViewModel::displayIctUnstableAlert() const
{
    auto settingValue = m_settings.value(surgeonsettingnames::ICT_DISPLAY_UNSTABLE_ALERT);
    if (settingValue.isValid() && settingValue.canConvert<bool>())
    {
        return settingValue.toBool();
    }

    SYS_LOG_DEBUG(
        "Failed to get display ICT unstable alert surgeon setting. Returning default value {}",
        surgeonsettingdefaults::DEFAULT_ICT_DISPLAY_UNSTABLE_ALERT);
    return surgeonsettingdefaults::DEFAULT_ICT_DISPLAY_UNSTABLE_ALERT;
}

bool SurgeonSettingsViewModel::reduceBackoffDistance() const
{
    auto settingValue = m_settings.value(surgeonsettingnames::REDUCE_BACKOFF_DISTANCE);
    if (settingValue.isValid() && settingValue.canConvert<bool>())
    {
        return settingValue.toBool();
    }

    SYS_LOG_DEBUG(
        "Failed to get reduce backoff distance surgeon setting. Returning default value {}",
        surgeonsettingdefaults::DEFAULT_REDUCE_BACKOFF_DISTANCE);

    return surgeonsettingdefaults::DEFAULT_REDUCE_BACKOFF_DISTANCE;
}

int SurgeonSettingsViewModel::minimumOpacity() const
{
    return surgeonsettingconsts::MIN_OPACITY;
}

int SurgeonSettingsViewModel::maximumOpacity() const
{
    return surgeonsettingconsts::MAX_OPACITY;
}

int SurgeonSettingsViewModel::minimumCadOpacity() const
{
    return surgeonsettingconsts::MIN_CAD_OPACITY;
}

int SurgeonSettingsViewModel::crosshairsOpacity() const
{
    auto settingValue = m_settings.value(surgeonsettingnames::CROSSHAIRS_OPACITY);
    if (settingValue.isValid() && settingValue.canConvert<int>())
    {
        return settingValue.toInt();
    }

    SYS_LOG_DEBUG(
        "Failed to get reduce crosshairs opacity surgeon setting. Returning default value {}",
        surgeonsettingdefaults::DEFAULT_CROSSHAIRS_OPACITY);

    return surgeonsettingdefaults::DEFAULT_CROSSHAIRS_OPACITY;
}

int SurgeonSettingsViewModel::implantCadOpacity() const
{
    auto settingValue = m_settings.value(surgeonsettingnames::IMPLANT_CAD_OPACITY);
    if (settingValue.isValid() && settingValue.canConvert<int>())
    {
        return settingValue.toInt();
    }

    SYS_LOG_DEBUG("Failed to get implant cad opacity surgeon setting. Returning default value {}",
                  surgeonsettingdefaults::DEFAULT_IMPLANT_CAD_OPACITY);

    return surgeonsettingdefaults::DEFAULT_IMPLANT_CAD_OPACITY;
}

int SurgeonSettingsViewModel::instrumentCadOpacity() const
{
    auto settingValue = m_settings.value(surgeonsettingnames::INSTRUMENT_CAD_OPACITY);
    if (settingValue.isValid() && settingValue.canConvert<int>())
    {
        return settingValue.toInt();
    }

    SYS_LOG_DEBUG(
        "Failed to get instrument cad opacity surgeon setting. Returning default value {}",
        surgeonsettingdefaults::DEFAULT_INSTRUMENT_CAD_OPACITY);

    return surgeonsettingdefaults::DEFAULT_INSTRUMENT_CAD_OPACITY;
}

bool SurgeonSettingsViewModel::displayTrajectoryLine() const
{
    auto settingValue = m_settings.value(surgeonsettingnames::TOOLTIP_CAD_LINE_VISIBLE);
    if (settingValue.isValid() && settingValue.canConvert<bool>())
    {
        return settingValue.toBool();
    }

    SYS_LOG_DEBUG(
        "Failed to get display trajectory line surgeon setting. Returning default value {}",
        surgeonsettingdefaults::DEFAULT_TOOLTIP_CAD_LINE_VISIBLE);
    return surgeonsettingdefaults::DEFAULT_TOOLTIP_CAD_LINE_VISIBLE;
}

std::set<spine::types::enums::PairingSystemType>
SurgeonSettingsViewModel::getEnabledPairingSystems()
{
    std::set<spine::types::enums::PairingSystemType> pairingSystems;
    auto settingValue = m_settings.value(surgeonsettingnames::ENABLED_PAIRING_SYSTEMS);
    if (settingValue.isValid() || settingValue.canConvert<QStringList>())
    {
        auto systemStringList = settingValue.toStringList();
        for (auto&& system : systemStringList)
        {
            pairingSystems.insert(convert<spine::types::enums::PairingSystemType>(system));
        }
    }
    return pairingSystems;
}

std::map<spine::types::enums::PairingSystemType, QString>
SurgeonSettingsViewModel::getAllPairingSystemTypesAndNames()
{
    std::map<spine::types::enums::PairingSystemType, QString> pairingSystemTypesAndNames;
    auto pairingSystemTypes = m_toolboxManager->getAllPairingSystemTypes();
    for (auto pairingSystemType : pairingSystemTypes)
    {
        pairingSystemTypesAndNames[pairingSystemType] =
            m_toolboxManager->getPairingSystemTypeDisplayName(pairingSystemType);
    }
    return pairingSystemTypesAndNames;
}

void SurgeonSettingsViewModel::updateArrayTypeList()
{
    ArrayTypeList arrayTypeList;
    m_arrayTypeListModel->update(arrayTypeList);
    auto enabledPairingSystems = getEnabledPairingSystems();
    auto pairingSystemTypesAndNames = getAllPairingSystemTypesAndNames();
    for (auto&& [type, _] : pairingSystemTypesAndNames)
    {
        auto arrayType = toArrayType(type);
        if (!arrayTypeList.contains(arrayType))
        {
            arrayTypeList[arrayType] = ArrayDisplayType{arrayType, toString(arrayType),
                                                        enabledPairingSystems.contains(type)};
        }
    }
    m_arrayTypeListModel->update(arrayTypeList);
}

surgeonsettings::ArrayType toArrayType(spine::types::enums::PairingSystemType systemType)
{
    switch (systemType)
    {
    case spine::types::enums::PairingSystemType::LegacyFixation:
        return surgeonsettings::ArrayType::LegacyFixation;
    case spine::types::enums::PairingSystemType::LegacyInterbody:
        return surgeonsettings::ArrayType::LegacyInterbody;
    case spine::types::enums::PairingSystemType::ExcelsiusFixation:
        return surgeonsettings::ArrayType::Excelsius;
    case spine::types::enums::PairingSystemType::ExcelsiusInterbody:
        return surgeonsettings::ArrayType::Excelsius;
    case spine::types::enums::PairingSystemType::ExcelsiusFreehandFixation:
        return surgeonsettings::ArrayType::Excelsius;
    case spine::types::enums::PairingSystemType::Unknown:
        return surgeonsettings::ArrayType::Unknown;
    }
}

std::set<spine::types::enums::PairingSystemType> toPairingSystemType(
    surgeonsettings::ArrayType arrayType)
{
    std::set<spine::types::enums::PairingSystemType> pairingSystemTypes;
    switch (arrayType)
    {
    case surgeonsettings::ArrayType::LegacyFixation:
        pairingSystemTypes.insert(spine::types::enums::PairingSystemType::LegacyFixation);
        break;
    case surgeonsettings::ArrayType::LegacyInterbody:
        pairingSystemTypes.insert(spine::types::enums::PairingSystemType::LegacyInterbody);
        break;
    case surgeonsettings::ArrayType::Excelsius:
        pairingSystemTypes.insert(spine::types::enums::PairingSystemType::ExcelsiusFixation);
        pairingSystemTypes.insert(spine::types::enums::PairingSystemType::ExcelsiusInterbody);
        pairingSystemTypes.insert(
            spine::types::enums::PairingSystemType::ExcelsiusFreehandFixation);
        break;
    case surgeonsettings::ArrayType::Unknown: break;
    }
    return pairingSystemTypes;
}

QString toString(surgeonsettings::ArrayType arrayType)
{
    switch (arrayType)
    {
    case surgeonsettings::ArrayType::LegacyFixation: return "Legacy Fixation";
    case surgeonsettings::ArrayType::LegacyInterbody: return "Legacy Interbody";
    case surgeonsettings::ArrayType::Excelsius: return "Excelsius";
    case surgeonsettings::ArrayType::Unknown: return "Unknown";
    }
    return "";
}

bool SurgeonSettingsViewModel::hideMergeScores() const
{
    auto settingValue = m_settings.value(surgeonsettingnames::HIDE_MERGE_SCORES);
    if (settingValue.isValid() && settingValue.canConvert<bool>())
    {
        return settingValue.toBool();
    }

    SYS_LOG_DEBUG("Failed to get hide merge scores surgeon setting. Returning default value {}",
                  surgeonsettingdefaults::DEFAULT_HIDE_MERGE_SCORES);
    return surgeonsettingdefaults::DEFAULT_HIDE_MERGE_SCORES;
}

void SurgeonSettingsViewModel::toggleHideMergeScores()
{
    m_settings.setValue(surgeonsettingnames::HIDE_MERGE_SCORES, !hideMergeScores());
    emit hideMergeScoresChanged();
}

void SurgeonSettingsViewModel::updateVolumeSetFourUpLayout(const QStringList& layoutList)
{
    m_settings.setValue(surgeonsettingnames::VOLUME_SET_FOUR_UP_LAYOUT, layoutList);
    emit volumeSetFourUpLayoutChanged();
}

QVariantList SurgeonSettingsViewModel::volumeSetFourUpLayout() const
{
    auto orientations = m_settings.value(surgeonsettingnames::VOLUME_SET_FOUR_UP_LAYOUT);
    if (!orientations.isValid() || !orientations.canConvert<QStringList>())
    {
        orientations =
            convert<QStringList>(surgeonsettingdefaults::DEFAULT_VOLUME_SET_FOUR_UP_LAYOUT);
    }

    auto displayName = [](const QString& viewportName) {
        using spine::types::ssm::ViewportOrientations;

        auto viewportOrientation = convert<ViewportOrientations>(viewportName);
        if (viewportOrientation == ViewportOrientations::Traj1)
            return "Trajectory 1";
        else if (viewportOrientation == ViewportOrientations::Traj2)
            return "Trajectory 2";
        else if (viewportOrientation == ViewportOrientations::Traj3)
            return "Trajectory 3";
        else if (viewportOrientation == ViewportOrientations::ThreeD)
            return "3D";
        else
            return "Unknown";
    };

    QVariantList layout;
    auto orientationStrings = orientations.toStringList();
    for (int i = 0; i < orientationStrings.size(); ++i)
    {
        QMap<QString, QVariant> layoutMap;
        layoutMap["viewName"] = orientationStrings[i];
        layoutMap["displayName"] = displayName(orientationStrings[i]);
        layoutMap["x"] = i % 2;  // x position (column)
        layoutMap["y"] = i / 2;  // y position (row)

        layout += layoutMap;
    }
    return layout;
}
