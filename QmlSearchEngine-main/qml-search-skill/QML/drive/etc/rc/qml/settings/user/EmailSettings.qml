import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import ".."
import "../../components"

RowLayout {
    spacing: Theme.margin(4)

    SettingsDescription {
        Layout.alignment: Qt.AlignTop
        title: qsTr("Change Email")
        description: qsTr("Change your account email.")
    }

    ColumnLayout {
        spacing: Theme.marginSize
		
        TitledTextField {
            id: currentPassword
            Layout.preferredWidth: Theme.margin(58)
			inputMethod: TitledTextField.InputMethod.Password
            title: qsTr("Current Password")
        }

        Button {
            enabled: currentPassword.text
            state: "active"
            text: qsTr("Change Email")
            onClicked: {
                if (userViewModel.authenticatePassword(currentPassword.text))
                {
                    changeEmailPopup.password = currentPassword.text;
                    changeEmailPopup.open();
                }
                currentPassword.text = "";
            }
        }

    }

    ChangeEmailPopup { id: changeEmailPopup }
}
