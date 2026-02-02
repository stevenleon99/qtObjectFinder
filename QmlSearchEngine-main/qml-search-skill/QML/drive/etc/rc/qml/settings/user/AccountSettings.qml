import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0
import DriveEnums 1.0

import ".."
import "../../components"

ColumnLayout {
    spacing: Theme.margin(4)

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("Account")
    }

    LoginSettings {
        visible: userViewModel.platformType !== PlatformType.Laptop
    }

    PinSettings {
        visible: userViewModel.platformType !== PlatformType.Laptop
    }

    PasswordSettings {}

    EmailSettings {}

    RowLayout {
        spacing: Theme.margin(4)

        SettingsDescription {
            Layout.alignment: Qt.AlignTop
            title: qsTr("Delete Account")
            description: qsTr("Delete your account (requires password confirmation).")
        }

        ColumnLayout {
            spacing: Theme.marginSize

            TitledTextField {
                id: currentPassword
                objectName: "autoCurrentPasswordObj"
                Layout.preferredWidth: Theme.margin(58)
                inputMethod: TitledTextField.InputMethod.Password
                title: qsTr("Current Password")
            }

            Button {               
                objectName: "autoAccountDeleteBtnObj"
                enabled: currentPassword.text
                state: "warning"
                text: qsTr("Delete")
                onClicked: {
                    if (userViewModel.authenticatePassword(currentPassword.text)) {
                        userViewModel.deactivateUser(userViewModel.activeUser.uuid);
                        drivePageViewModel.currentPage = DrivePage.Login;
                    }
                    currentPassword.text = "";
                }
            }
        }
    }
}
