/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include <SystemSettingsAlerts.h>

namespace drive::systemsettings {

using namespace sys::alerts;

const Option dismissOption{"Dismiss"};

const std::unordered_map<SystemSettingsAlerts, Alert> alertsMap = {
    {SystemSettingsAlerts::ExportingLogs,
     Alert{"SS1", "Exporting Logs", "This may take a few minutes, please wait.", "",
           sys::alerts::AlertLevel::Info, std::vector<sys::alerts::Option>{}, true}},
    {SystemSettingsAlerts::ExportingLogsFailed,
     Alert{"SS2", "Exporting Logs Failed", "Check your output location or re-export.", "",
           sys::alerts::AlertLevel::Warning,
           std::vector<sys::alerts::Option>{sys::alerts::Option{"Dismiss"}}, false}},
    {SystemSettingsAlerts::LicenseAppliedSuccess,
     Alert{"SS6", "License Code Accepted",
           "The provided license code was valid.\nRestart the system to "
           "finishing activating the following license:{}",
           "", sys::alerts::AlertLevel::Info,
           std::vector<sys::alerts::Option>{sys::alerts::Option{"Dismiss"}}, false}},
    {SystemSettingsAlerts::LicenseAppliedFail,
     Alert{"SS7", "Invalid License Code",
           "No licenses were activated.\nCheck your license code and "
           "try again.",
           "", sys::alerts::AlertLevel::Warning,
           std::vector<sys::alerts::Option>{sys::alerts::Option{"Dismiss"}}, false}}};
}  // namespace drive::systemsettings
