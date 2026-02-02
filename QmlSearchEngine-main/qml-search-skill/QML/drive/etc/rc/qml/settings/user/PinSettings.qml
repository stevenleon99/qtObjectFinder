import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0
import DriveEnums 1.0

import ".."
import "../../components"
import "../../login"

RowLayout {
    spacing: Theme.margin(4)

    SettingsDescription {
        Layout.alignment: Qt.AlignTop
        title: qsTr("Add/Change PIN")
        description: qsTr("Change your system login PIN.")
    }

    ColumnLayout {
        spacing: Theme.marginSize

        TitledTextField {
            id: currentPassword
            Layout.preferredWidth: Theme.margin(58)
            validator: RegExpValidator { id: passwordValidator; regExp: /^[0-9a-zA-Z !@#$%^&*()_+|~=`{}[\]:";'<>?,.\\/-]+$/ }
            inputMethod: TitledTextField.InputMethod.Password
            title: qsTr("Current Password")
        }

        RowLayout {
            spacing: Theme.margin(2)

            Button {
                enabled: currentPassword.text
                state: "active"
                text: qsTr("Change PIN")

                onClicked: {
                    if (userViewModel.authenticatePassword(currentPassword.text)) {
                        changeCodePopup.password = currentPassword.text;
                        changeCodePopup.open();
                    }
                    currentPassword.text = "";
                }
            }

            Button {
                enabled: currentPassword.text && userViewModel.activeUser.pinAccess
                state: "warning"
                text: qsTr("Delete PIN")
                onClicked: {
                    if (userViewModel.authenticatePassword(currentPassword.text)) {
                        userViewModel.setPinAccess(false);
                        userViewModel.setPinPreferred(userViewModel.activeUser.uuid, false)
                    }
                    currentPassword.text = "";
                }
            }
        }
    }

    ChangeCodePopup { id: changeCodePopup }
}
