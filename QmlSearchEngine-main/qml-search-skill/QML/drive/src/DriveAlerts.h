/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <sys/alerts/Alert.h>
#include <unordered_map>

namespace drive::alerts {

enum class DriveAlerts
{
    ProfileUpdated,  //@< user profile changed
    PinUpdated,  //@< user PIN changed
    PasswordUpdated,  //@< user password changed
    ActivationFailed,  //@< incorrect activation key and/or email
    IncorrectPassword,  //@< password aunthentication failed
    UserAlreadyExists,  //@< user already exists for given email
    CaseImportMismatch,  //@< case belongs to different patient
    CaseImportFailed,  //@< failed to import the case
    CaseExportFailed,  //@< failed to export the case
    ScreenScaled,  // @< invalid screen resolution
    InvalidLicense,  //@< License missing or invalid for requested plugin
    DiskFreeSpaceLow,  // @< disk capacity low
    EmailUpdated,  //@< user email changed
    ForceRehomeConfirmation,  //@< confirm that the user wants to rehome the arm
    CaseLogsExportFailed,  //@< case logs could not be exported
    ResolutionIncompatible,  //@< incompatible external monitor resolution
    CaseImported,  //@< case successfully imported
    CaseExported,  //@< case successfully exported
    AccountLocked,  //@< user locked out
    ScreenshotsExport,  //@< exporting screenshots
    ScreenshotsExportSuccess,  //@< successful screenshots export
    ScreenshotsExportFailed,  //@< failed to export screenshots
    TooManyConnections,  //@< multiple glink connection present
    EGPSScreenMirroringDisabled,  //@< screen mirroring disabled in GPS mirror
                                  // server
    E3DScreenMirroringDisabled,  //@< screen mirroring disabled in E3D mirror
                                 // server
    FootPedalPressedBeforeRehoming,  //@< foot pedal pressed before rehoming
                                     // started
    ImageExported,  //@< image successfully exported
    ImageExportFailed,  //@< image could not be exported
    NetworkConfigSuccess,  //@< Network configuration updated successfully
    NetworkConfigFailed,  //@< Network Configuration update failed
    NetworkDisconnected  //@< Network Connection Disconnected

};

extern const sys::alerts::Option confirmOption;
extern const sys::alerts::Option dismissOption;
extern const sys::alerts::Option cancelOption;

extern const std::unordered_map<DriveAlerts, sys::alerts::Alert> alertsMap;

}  // namespace drive::alerts
