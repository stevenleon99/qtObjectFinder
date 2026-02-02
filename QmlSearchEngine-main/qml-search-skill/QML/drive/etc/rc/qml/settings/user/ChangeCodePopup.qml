import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import "../../components"
import "../../login"

Popup {
    width: Theme.margin(74)
    height: layout.height + Theme.margin(8)
    closePolicy: Popup.NoAutoClose

    property string password
    property alias state: layout.state

    onClosed: userCodeInput.clear()

    UserCodeRequirementsPopup {
        id: userCodeRequirementsPopup
        visible: userCodeInput.pinInput.editing ||
                 userCodeInput.confirmPinInput.editing ||
                 userCodeInput.passwordInput.editing ||
                 userCodeInput.confirmPasswordInput.editing
        code: pinMode ? userCodeInput.pinInput.text : userCodeInput.passwordInput.text
        confirmCode: pinMode ? userCodeInput.confirmPinInput.text : userCodeInput.confirmPasswordInput.text
        z: 1
    }

    ColumnLayout {
        id: layout
        width: parent.width - Theme.margin(8)
        anchors { centerIn: parent }
        spacing: Theme.margin(4)

        state: "pin"

        states: [
            State {
                name: "pin"
                PropertyChanges { target: title; text: qsTr("Change PIN"); }
                PropertyChanges { target: userCodeInput; inputPassword: false }
                PropertyChanges {
                    target: confirmButton

                    onClicked: {
                        if (userViewModel.setUserPin(userViewModel.activeUser.uuid, password, userCodeInput.pinInput.text)) {
                            userViewModel.setPinAccess(true)
                            userViewModel.setPinPreferred(userViewModel.activeUser.uuid, true)
                        }
                        close()
                    }
                }
            },
            State {
                name: "password"
                PropertyChanges { target: title; text: qsTr("Change Password"); }
                PropertyChanges { target: userCodeInput; inputPin: false }
                PropertyChanges {
                    target: confirmButton

                    onClicked: {
                        userViewModel.setUserPassword(userViewModel.activeUser.uuid, password, userCodeInput.passwordInput.text)
                        close()
                    }
                }
            }
        ]

        ColumnLayout {
            Layout.topMargin: Theme.margin(1)
            spacing: Theme.margin(2)

            Label {
                id: title
                Layout.fillWidth: true
                state: "h4"
                text: qsTr("Change PIN")
            }

            UserCodeInput {
                id: userCodeInput
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: Theme.marginSize

            Button {
                state: "available"
                text: qsTr("Cancel")
                onClicked: close()
            }

            Button {
                id: confirmButton
                enabled: userCodeRequirementsPopup.valid
                state: "active"
                text: qsTr("Confirm")
            }
        }
    }
}
