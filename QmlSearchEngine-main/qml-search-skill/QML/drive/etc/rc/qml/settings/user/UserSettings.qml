import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0
import DriveEnums 1.0

import "../../components"

ColumnLayout {
    x: Theme.margin(6)
    width: parent.width
    spacing: Theme.marginSize * 2

    Connections {
        target: userViewModel

        onAccountLocked: {
            if (settingsPluginLoader.active) {
                settingsPluginLoader.active = false;
            }
            drivePageViewModel.currentPage = DrivePage.Login;
        }
    }

    states: [
        State {
            when: userViewModel.activeUser.isServiceUser
            PropertyChanges { target: repeater; model: ["UserDetails"] }
        }
    ]

    Repeater {
        id: repeater
        model: ["UserDetails", "Profile", "Account"]

        delegate: ColumnLayout {
            spacing: Theme.margin(4)

            DividerLine {
                Layout.fillWidth: true
                visible: index
            }

            Loader {
                Layout.margins: item ? item.Layout.margins : 0
                Layout.fillHeight: item ? item.Layout.fillHeight : 0
                Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
                active: true
                source: modelData + "Settings.qml"
            }
        }
    }
}
