import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import "../components"

Popup {
    id: popup
    width: Theme.margin(74)
    height: layout.height + Theme.margin(8)
    closePolicy: Popup.NoAutoClose

    UserCodeRequirementsPopup {
        id: userCodeRequirementsPopup
        visible: userCodeInput.editing
        code: userCodeInput.passwordInput.text
        confirmCode: userCodeInput.confirmPasswordInput.text
        z: 1
    }

    ColumnLayout {
        id: layout
        width: popup.width - Theme.margin(8)
        anchors { centerIn: parent }
        spacing: Theme.margin(4)

        ColumnLayout {
            Layout.topMargin: Theme.margin(1)
            spacing: Theme.margin(2)

            Label {
                Layout.fillWidth: true
                state: "h4"
                text: qsTr("Reset Password")
            }

            Label {
                Layout.fillWidth: true
                state: "h6"
                maximumLineCount: 2
                wrapMode: TextInput.WordWrap
                text: qsTr("Enter the activation key that was sent to your email or contact Globus Medical Service.")
            }

            TitledTextField {
                id: keyInput
                objectName: "resetPasswordActivationKeyTextField"
                Layout.preferredWidth: Theme.margin(60)
                inputMethod: TitledTextField.InputMethod.ActivationKey
                title: qsTr("Activation Key")
            }

            UserCodeInput {
                id: userCodeInput
                inputPin: false
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: Theme.marginSize

            Button {
                objectName: "resetPasswordCancelBtn"
                state: "available"
                text: qsTr("Cancel")

                onClicked: close()
            }

            Button {
                objectName: "resetPasswordConfirmBtn"
                enabled: keyInput.text && userCodeRequirementsPopup.valid
                state: "active"
                text: qsTr("Confirm")

                onClicked:  {
                    if (userViewModel.validateActivationKey(userViewModel.activeUser.email, keyInput.text)) {
                        userViewModel.changePassword(userViewModel.activeUser.uuid, userCodeInput.passwordInput.text)
                    }
                    close()
                }
            }
        }
    }

    onClosed: {
        keyInput.text = ""
        userCodeInput.clear()
    }

    onVisibleChanged: {
        if(visible) {
            keyInput.textField.cursorPosition = 1
            keyInput.textField.forceActiveFocus()
        }
    }
}
