import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import DriveEnums 1.0

import ".."

RowLayout {
    spacing: Theme.margin(4)

    SettingsDescription {
        title: qsTr("Login Method")
        description: qsTr("Change your default login method.")
    }

    RowLayout {
        Layout.preferredHeight: Theme.margin(8)
        spacing: Theme.marginSize

        Label {
            opacity: loginSwitch.enabled && loginSwitch.checked ? 0.5 : 1.0
            state: "body1"
            font.bold: true
            text: qsTr("Password")
        }

        Switch {
            id: loginSwitch
            enabled: userViewModel.activeUser.pinAccess
            checked: userViewModel.activeUser.pinPreferred
            onClicked: userViewModel.setPinPreferred(userViewModel.activeUser.uuid,
                                                     loginSwitch.checked)
        }

        Label {
            opacity: loginSwitch.enabled && loginSwitch.checked ? 1.0 : 0.5
            state: "body1"
            font.bold: true
            text: qsTr("PIN")
        }
    }
}
