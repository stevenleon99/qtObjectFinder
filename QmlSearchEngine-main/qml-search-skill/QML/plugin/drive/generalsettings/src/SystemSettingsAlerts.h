/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <sys/alerts/Alert.h>
#include <unordered_map>

namespace drive::systemsettings {

enum class SystemSettingsAlerts
{
    ExportingLogs,  //@< log export in progress
    ExportingLogsFailed,  //@< log export failed
    NetworkConfigSuccess,  //@< network configuration success
    NetworkConfigFailed,  //@< failed to update network configuration
    NetworkDisconnected,  //@< configuration failed due to network disconnection
    LicenseAppliedSuccess,  //@< license successfully applied with valid code
    LicenseAppliedFail  //@< license failed to apply likely due to an invalid
                        // code
};

extern const sys::alerts::Option dismissOption;

extern const std::unordered_map<SystemSettingsAlerts, sys::alerts::Alert>
    alertsMap;

}  // namespace drive::systemsettings
