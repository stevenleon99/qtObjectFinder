import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import GmScreenSaver 1.0
import DriveEnums 1.0
import ViewModels 1.0

Popup {
    visible: screenSaver.active

    Overlay.modal: Rectangle { color: "#80000000" }

    readonly property int secondsInMinute: 60
    readonly property int logoutTimeout: 55 // logout in 55 seconds after screensaver activation
    readonly property int validationTimeout: 600 // validate user every 10 minutes upon screensaver activation
    readonly property int screenDimTimeout: (applicationViewModel.screenTimeout * secondsInMinute) - logoutTimeout

    Timer {
        running: screenSaver.active
        interval: logoutTimeout * 1000 // logout timeout in milliseconds
        onTriggered: {
            if (settingsPluginLoader.active)
                settingsPluginLoader.active = false;
            userViewModel.validateUserAging();

            userViewModel.updateLastUsedDate();
            if (driveMirrorViewModel.usingGPS && driveMirrorViewModel.serverSetup
                && (connectionsViewModel.connectedPeerType !== ConnectedPeerType.E3d))
            {
                console.log("Stopping Mirror Server")
                driveMirrorViewModel.stopMirrorServer();
            }

            console.log("Logging out user " + userViewModel.loggedInUserName + " due to user inactivity");
            drivePageViewModel.currentPage = DrivePage.Login;
        }
    }

    Timer {
        running: screenSaver.active
        interval: validationTimeout * 1000 // user validation timeout in milliseconds
        repeat: true
        onTriggered: userViewModel.validateUserAging();
    }

    ScreenSaver {
        id: screenSaver
        timeout: screenDimTimeout
    }
}
