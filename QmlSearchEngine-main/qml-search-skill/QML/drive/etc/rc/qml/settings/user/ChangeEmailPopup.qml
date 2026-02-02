import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import "../../components"

Popup {
    id: changeEmailPopup
    width: Theme.margin(74)
    height: layout.height + Theme.margin(8)
    closePolicy: Popup.NoAutoClose

    property string password

    ColumnLayout {
        id: layout
        width: parent.width - Theme.margin(8)
        anchors { centerIn: parent }
        spacing: Theme.margin(4)

        ColumnLayout {
            Layout.topMargin: Theme.margin(1)
            spacing: Theme.margin(2)

            Label {
                Layout.fillWidth: true
                state: "h4"
                text: qsTr("Change Email")
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
                Layout.preferredWidth: Theme.margin(60)
                inputMethod: TitledTextField.InputMethod.ActivationKey
                title: qsTr("Activation Key")
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.margin(2)

                TitledTextField {
                    id: emailInput
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    title: qsTr("Email")
                }

                TitledTextField {
                    id: confirmEmailInput
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    title: qsTr("Confirm Email")
                }
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
                enabled: keyInput.text && emailInput.text &&
                         (emailInput.text == confirmEmailInput.text)
                state: "active"
                text: qsTr("Confirm")

                onClicked:  {
                    if (((emailInput.text === userViewModel.activeUser.email) ||
                         !userViewModel.activeUserAvailable(emailInput.text)) &&
                            userViewModel.validateActivationKey(emailInput.text, keyInput.text)) {
                        userViewModel.setEmailAndActivationKey(password,
                                                               emailInput.text,
                                                               keyInput.text);
                    }
                    close();
                }
            }
        }
    }

    onClosed: {
        keyInput.text = "";
        emailInput.text = "";
        confirmEmailInput.text = "";
    }

    onVisibleChanged: {
        if(visible) {
            keyInput.textField.cursorPosition = 1
            keyInput.textField.forceActiveFocus()
        }
    }
}
