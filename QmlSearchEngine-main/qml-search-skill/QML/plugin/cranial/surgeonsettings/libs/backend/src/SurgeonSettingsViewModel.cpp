#include <apps/cranial/backend/SurgeonSettingsViewModel.h>
#include <procd/cranial/tools/SurgeonSettingsTools.h>

#include <gm/util/qt/typeconv.h>
#include <sys/log.h>

using ::gm::util::typeconv::convert;

namespace surgeonsettings {
SurgeonSettingsViewModel::SurgeonSettingsViewModel(::drive::model::SurgeonIdentifier surgeonId,
                                                   QObject* parent)
    : QObject(parent)
    , m_settings{QSettings(cranial::tools::surgeonSettingsFile(), QSettings::IniFormat, this)}
{
    m_settings.beginGroup(convert<QString>(to_string(surgeonId.id)));
}

void SurgeonSettingsViewModel::updateCrosshairs3dOpacity(int opacity)
{
    if (opacity < cranial::tools::surgeonsettingconsts::MIN_OPACITY ||
        opacity > cranial::tools::surgeonsettingconsts::MAX_OPACITY)
    {
        SYS_LOG_ERROR("3D crosshair opacity {} out of range", opacity);
        return;
    }

    m_settings.setValue(cranial::tools::surgeonsettingnames::CROSSHAIRS3D_OPACITY, opacity);
    emit crosshairs3dOpacityChanged();
}

int SurgeonSettingsViewModel::crosshairs3dOpacity() const
{
    auto settingValue = m_settings.value(cranial::tools::surgeonsettingnames::CROSSHAIRS3D_OPACITY);
    if (settingValue.isValid() && settingValue.canConvert<int>())
    {
        return settingValue.toInt();
    }

    SYS_LOG_DEBUG("Failed to get crosshairs 3D opacity surgeon setting. Returning default value {}",
                  cranial::tools::surgeonsettingdefaults::DEFAULT_CROSSHAIRS3D_OPACITY);

    return cranial::tools::surgeonsettingdefaults::DEFAULT_CROSSHAIRS3D_OPACITY;
}

void SurgeonSettingsViewModel::updateIsAcpcDisplayTarget(bool autoACPCcoordinates)
{
    m_settings.setValue(cranial::tools::surgeonsettingnames::ACPC_DISPLAY_TARGET,
                        autoACPCcoordinates);
    emit isAcpcDisplayTargetChanged();
}

bool SurgeonSettingsViewModel::isAcpcDisplayTarget() const
{
    auto settingValue = m_settings.value(cranial::tools::surgeonsettingnames::ACPC_DISPLAY_TARGET);
    if (settingValue.isValid() && settingValue.canConvert<bool>())
    {
        return settingValue.toBool();
    }

    SYS_LOG_DEBUG("Failed to get Target ACPC display surgeon setting. Returning default value {}",
                  cranial::tools::surgeonsettingdefaults::DEFAULT_ACPC_DISPLAY_TARGET);

    return cranial::tools::surgeonsettingdefaults::DEFAULT_ACPC_DISPLAY_TARGET;
}

void SurgeonSettingsViewModel::updateIsAcpcDisplayGeneral(bool autoACPCcoordinates)
{
    SYS_LOG_INFO("Updating General ACPC display setting to {}", autoACPCcoordinates);
    m_settings.setValue(cranial::tools::surgeonsettingnames::ACPC_DISPLAY_GENERAL,
                        autoACPCcoordinates);
    emit isAcpcDisplayGeneralChanged();
}

bool SurgeonSettingsViewModel::isAcpcDisplayGeneral() const
{
    auto settingValue = m_settings.value(cranial::tools::surgeonsettingnames::ACPC_DISPLAY_GENERAL);
    if (settingValue.isValid() && settingValue.canConvert<bool>())
    {
        return settingValue.toBool();
    }

    SYS_LOG_DEBUG("Failed to get General ACPC display surgeon setting. Returning default value {}",
                  cranial::tools::surgeonsettingdefaults::DEFAULT_ACPC_DISPLAY_GENERAL);

    return cranial::tools::surgeonsettingdefaults::DEFAULT_ACPC_DISPLAY_GENERAL;
}

void SurgeonSettingsViewModel::updateIsOriginalDicomCoord(bool originalDicomCoord)
{
    m_settings.setValue(cranial::tools::surgeonsettingnames::ORIGINAL_DICOM_COORD,
                        originalDicomCoord);
    emit isOriginalDicomCoordChanged();
}

bool SurgeonSettingsViewModel::isOriginalDicomCoord() const
{
    auto settingValue = m_settings.value(cranial::tools::surgeonsettingnames::ORIGINAL_DICOM_COORD);
    if (settingValue.isValid() && settingValue.canConvert<bool>())
    {
        return settingValue.toBool();
    }
    SYS_LOG_DEBUG(
        "Failed to get Original DICOM coordinate surgeon setting. Returning default value {}",
        cranial::tools::surgeonsettingdefaults::DEFAULT_ORIGINAL_DICOM_COORD);

    return cranial::tools::surgeonsettingdefaults::DEFAULT_ORIGINAL_DICOM_COORD;
}

void SurgeonSettingsViewModel::toggleInterpolationMode()
{
    bool isInterpolationMode = cranial::tools::surgeonsettingdefaults::DEFAULT_INTERPOLATION_MODE;
    auto settingValue = m_settings.value(cranial::tools::surgeonsettingnames::INTERPOLATION_MODE);
    if (settingValue.isValid() && settingValue.canConvert<bool>())
    {
        isInterpolationMode = settingValue.toBool();
    }

    m_settings.setValue(cranial::tools::surgeonsettingnames::INTERPOLATION_MODE,
                        !isInterpolationMode);
    emit isInterpolationModeChanged();
}

bool SurgeonSettingsViewModel::isInterpolationMode() const
{
    auto settingValue = m_settings.value(cranial::tools::surgeonsettingnames::INTERPOLATION_MODE);
    if (settingValue.isValid() && settingValue.canConvert<bool>())
    {
        return settingValue.toBool();
    }
    SYS_LOG_DEBUG("Failed to get Interpolation mode surgeon setting. Returning default value {}",
                  cranial::tools::surgeonsettingdefaults::DEFAULT_INTERPOLATION_MODE);

    return cranial::tools::surgeonsettingdefaults::DEFAULT_INTERPOLATION_MODE;
}

}  // namespace surgeonsettings