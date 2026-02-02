import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0
import DriveEnums 1.0
import ViewModels 1.0

import "../components"

Popup {
    id: createUserDialog
    width: layout.width
    height: layout.height
    closePolicy: Popup.CloseOnEscape

    property string email
    property string activationKey
    property bool pinPreferred: false

    UserCodeRequirementsPopup {
        id: userCodeRequirementsPopup
        visible: userCodeInput.editing
        code: userCodeInput.pinInput.text
        confirmCode: userCodeInput.confirmPinInput.text
        z: 1
    }

    ColumnLayout {
        id: layout
        spacing: 0

        RowLayout {
            Layout.margins: Theme.margin(4)
            spacing: Theme.margin(3)

            UserIcon {
                id: userIcon
                Layout.alignment: Qt.AlignTop
                Layout.preferredWidth: 160
                Layout.preferredHeight: 160
                iconColor: Theme.blueLight500
                iconText: "GM"
                state: "login"
            }

            ColumnLayout {
                spacing: Theme.margin(3)

                ColumnLayout {
                    Layout.preferredWidth: Theme.margin(66)
                    spacing: Theme.margin(2)

                    Label {
                        state: "h4"
                        text: qsTr("New Service User")
                    }

                    UserCodeInput {
                        id: userCodeInput
                        inputPassword: false
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: Theme.margin(2)

                    Button {
                        objectName: "autoServiceUserCancelBtnObj"
                        Layout.preferredWidth: 128
                        state: "available"
                        text: qsTr("Cancel")

                        onPressed: close()
                    }

                    Button {                     
                        objectName: "autoServiceUserconfirmBtnObj"
                        enabled: userCodeRequirementsPopup.valid
                        Layout.preferredWidth: 128
                        state: "hinted"
                        text: qsTr("Confirm")

                        onPressed: {
                            userViewModel.createUser(email, activationKey, email, "GM", Theme.blueLight500, userCodeInput.pinInput.text, "", true);
                            close();
                        }
                    }
                }
            }
        }
    }

    onClosed: userCodeInput.clear()
}
