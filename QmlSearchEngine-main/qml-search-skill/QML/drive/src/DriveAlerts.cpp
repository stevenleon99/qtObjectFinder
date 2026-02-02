/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include <DriveAlerts.h>

namespace drive::alerts {

using namespace sys::alerts;

const Option confirmOption{"Confirm"};

const Option dismissOption{"Dismiss"};

const Option cancelOption{"Cancel"};

const std::unordered_map<DriveAlerts, Alert> alertsMap = {
    {DriveAlerts::ProfileUpdated,
     Alert{"DRV01", "Profile Updated", "Your profile details have been saved.",
           "", AlertLevel::Info, std::vector<Option>{confirmOption}, false}},
    {DriveAlerts::PinUpdated,
     Alert{"DRV02", "PIN Updated", "Your PIN has been successfully updated.",
           "", AlertLevel::Info, std::vector<Option>{confirmOption}, false}},
    {DriveAlerts::PasswordUpdated,
     Alert{"DRV03", "Password Updated",
           "Your password has been successfully updated.", "", AlertLevel::Info,
           std::vector<Option>{confirmOption}, false}},
    {DriveAlerts::ActivationFailed,
     Alert{"DRV04", "Account Creation Failed",
           "Creation of account has failed. Ensure the activation key and "
           "email have been entered correctly.",
           "", AlertLevel::Warning, std::vector<Option>{dismissOption}, false}},
    {DriveAlerts::IncorrectPassword,
     Alert{"DRV05", "Authentication Failed",
           "The password you entered is incorrect. Please try again. [{}] "
           "attempts remaining before you are locked out of this account.",
           "", AlertLevel::Warning, std::vector<Option>{dismissOption}, false}},
    {DriveAlerts::UserAlreadyExists,
     Alert{"DRV06", "Account Already Active",
           "This account email has already been created on this system. Try a "
           "different email or go to login.",
           "", AlertLevel::Error, std::vector<Option>{dismissOption}, false}},
    {DriveAlerts::CaseImportMismatch,
     Alert{"DRV07", "Case Import Mismatch",
           "Imported case contains details belonging to another patient. "
           "Continue with import?",
           "", AlertLevel::Warning,
           std::vector<Option>{cancelOption, confirmOption}, false}},
    {DriveAlerts::CaseImportFailed,
     Alert{"DRV08", "Case Import Failed",
           "Failed to import the case. Please try again.", "",
           AlertLevel::Error, std::vector<Option>{dismissOption}, false}},
    {DriveAlerts::CaseExportFailed,
     Alert{"DRV09", "Case Export Failed",
           "Failed to export the case. Please try again.", "",
           AlertLevel::Error, std::vector<Option>{dismissOption}, false}},
    {DriveAlerts::ScreenScaled,
     Alert{"DRV10", "Display Resolution Invalid",
           "The resolution of the display is invalid and may cause "
           "registration errors.",
           "Please logout and disconnect incompatible monitors. If issue "
           "persists, contact Globus Medical Service.",
           AlertLevel::Error, std::vector<Option>{}, false}},
    {DriveAlerts::InvalidLicense,
     Alert{"DRV11", "Invalid License Error",
           "License file for desired plugin is either absent or invalid. "
           "Please contact excelsiussupport@globusmedical.com for help "
           "acquiring the correct license.",
           "", AlertLevel::Error, std::vector<Option>{dismissOption}, false}},
    {DriveAlerts::DiskFreeSpaceLow,
     Alert{"DRV12", "Hard Drive Capacity", "Disk capacity is above 80%.",
           "The system hard drive is almost full. Consider deleting cases "
           "before creating new ones.",
           AlertLevel::Error, std::vector<Option>{}, false}},
    {DriveAlerts::EmailUpdated,
     Alert{"DRV13", "Email Updated",
           "Your email has been successfully updated.", "", AlertLevel::Info,
           std::vector<Option>{confirmOption}, false}},
    {DriveAlerts::ForceRehomeConfirmation,
     Alert{"DRV14", "Force Rehome Confirmation",
           "Once started, rehoming cannot be canceled.",
           "Are you sure you want to rehome the arm?", AlertLevel::Warning,
           std::vector<Option>{cancelOption, confirmOption}, false}},
    {DriveAlerts::CaseLogsExportFailed,
     Alert{"DRV15", "Failed to export case logs",
           "Could not export case logs: exported case archive will not contain "
           "any logs. Consider exporting system logs from the System Settings "
           "page.",
           "", AlertLevel::Warning, std::vector<Option>{dismissOption}, false}},
    {DriveAlerts::ResolutionIncompatible,
     Alert{"DRV16", "External Monitor is Incompatible",
           "External monitor does not support required resolution.",
           "Please use a different monitor that support 1920x1080 (known as "
           "1080p) resolution.",
           AlertLevel::Warning, std::vector<Option>{}, false}},
    {DriveAlerts::CaseImported,
     Alert{"DRV17", "Case Imported", "The case has been successfully imported.",
           "", AlertLevel::Info, std::vector<Option>{dismissOption}, false}},
    {DriveAlerts::CaseExported,
     Alert{"DRV18", "Case Exported", "The case has been successfully exported.",
           "", AlertLevel::Info, std::vector<Option>{dismissOption}, false}},
    {DriveAlerts::AccountLocked,
     Alert{"DRV19", "Account Locked",
           "You have entered too many incorrect passwords. This account is "
           "locked until reactivated.",
           "", AlertLevel::Warning, std::vector<Option>{dismissOption}, false}},
    {DriveAlerts::ScreenshotsExport,
     Alert{"DRV20", "Exporting Screenshots",
           "This may take a few minutes, please wait.", "",
           sys::alerts::AlertLevel::Info, std::vector<sys::alerts::Option>{},
           true}},
    {DriveAlerts::ScreenshotsExportSuccess,
     Alert{"DRV21", "Screenshots Exported",
           "The screenshots have been successfully exported.", "",
           AlertLevel::Info, std::vector<Option>{dismissOption}, false}},
    {DriveAlerts::ScreenshotsExportFailed,
     Alert{"DRV22", "Exporting Screenshots Failed",
           "Check your output location or re-export.", "",
           sys::alerts::AlertLevel::Warning,
           std::vector<sys::alerts::Option>{sys::alerts::Option{"Dismiss"}},
           false}},
    {DriveAlerts::TooManyConnections,
     Alert{"DRV23", "Too Many Excelsius Network Connections",
           "Ensure only one Excelsius system is connected to this device. You "
           "may need to disconnect this device or another Excelsius system "
           "from PACS.",
           "", AlertLevel::Warning, std::vector<Option>{}, false}},
    {DriveAlerts::EGPSScreenMirroringDisabled,
     Alert{"DRV24", "Screen Mirroring Disabled",
           "Screen mirroring is disabled in ExcelsiusGPS System Settings.", "",
           AlertLevel::Warning,
           std::vector<Option>{sys::alerts::Option{"Dismiss"}}, false}},
    {DriveAlerts::E3DScreenMirroringDisabled,
     Alert{"DRV24", "Screen Mirroring Disabled",
           "Screen mirroring is disabled in Excelsius3D System Settings.", "",
           AlertLevel::Warning,
           std::vector<Option>{sys::alerts::Option{"Dismiss"}}, false}},
    {DriveAlerts::FootPedalPressedBeforeRehoming,
     Alert{"DRV25", "Foot Pedal Pressed Before Rehoming",
           "The foot pedal was pressed before rehoming was started.",
           "Do not engage the foot pedal until instructed to do so.",
           AlertLevel::Warning, std::vector<Option>{}, false}},
    {DriveAlerts::ImageExported,
     Alert{"DRV26", "Image Exported",
           "The image have been successfully exported.", "", AlertLevel::Info,
           std::vector<Option>{dismissOption}, false}},
    {DriveAlerts::ImageExportFailed,
     Alert{"DRV27", "Exporting Image Failed",
           "Check your output location or re-export.", "", AlertLevel::Warning,
           std::vector<Option>{dismissOption}, false}},
    {DriveAlerts::NetworkConfigSuccess,
     Alert{"DRV28", "Network Settings Updated",
           "Network settings have been successfully updated.", "",
           sys::alerts::AlertLevel::Info,
           std::vector<sys::alerts::Option>{sys::alerts::Option{"Dismiss"}},
           false}},
    {DriveAlerts::NetworkConfigFailed,
     Alert{"DRV29", "Network Settings Failed",
           "Network settings have failed to update. Check the settings then "
           "try again.",
           "", sys::alerts::AlertLevel::Warning,
           std::vector<sys::alerts::Option>{sys::alerts::Option{"Dismiss"}},
           false}},
    {DriveAlerts::NetworkDisconnected,
     Alert{"DRV30", "Network Settings Failed",
           "Network settings have failed to update. Check the ethernet "
           "connection and network status then try again.",
           "", sys::alerts::AlertLevel::Warning,
           std::vector<sys::alerts::Option>{sys::alerts::Option{"Dismiss"}},
           false}}};


}  // namespace drive::alerts
