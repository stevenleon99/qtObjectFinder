import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import "../components"

Popup {
    id: userActivationPopup
    y: Qt.inputMethod.visible ? Theme.margin(28) : (parent.height / 2) - (height / 2)
    width: Theme.margin(68)
    height: columnLayout.height
    closePolicy: Popup.CloseOnEscape

    signal createUser(string email, string key)

    ColumnLayout {
        id: columnLayout
        ColumnLayout {
            Layout.margins: Theme.margin(4)
            spacing: Theme.marginSize

            Label {
                Layout.maximumWidth: Theme.margin(60)
                state: "h4"
                text: qsTr("New User")
            }

            Label {
                Layout.maximumWidth: Theme.margin(60)
                state: "h6"
                maximumLineCount: 2
                wrapMode: TextInput.WordWrap
                text: qsTr("Enter your activation key and email for account creation.")
            }
            
            TitledTextField {
                id: keyInput
                objectName: "keyInput"
                Layout.preferredWidth: Theme.margin(60)
                inputMethod: TitledTextField.InputMethod.ActivationKey
                title: qsTr("Activation Key")
            }

            TitledTextField {
                id: emailInput
                objectName: "emailInput"
                Layout.preferredWidth: Theme.margin(60)
                title: qsTr("Email")
            }

            LayoutSpacer {
                Layout.preferredHeight: Theme.margin(2)
            }

            RowLayout {
                id: layout
                Layout.alignment: Qt.AlignRight
                spacing: Theme.marginSize

                Button {
                    id: autoCancelUserCreationBtnObj
                    state: "available"
                    text: qsTr("Cancel")
                    onPressed: close()
                }

                Button {
                    objectName: "autoConfirmCreateUserBtnObj"
                    enabled: emailInput.text && keyInput.text
                    state: "active"
                    text: qsTr("Confirm Email")
                    onPressed:  {
                        if (userViewModel.validateActivationKey(emailInput.text, keyInput.text) &&
                                !userViewModel.activeUserAvailable(emailInput.text)) {
                            createUser(emailInput.text, keyInput.text);
                        }
                        close();
                    }
                }
            }
        }
    }

    onClosed: {
        keyInput.text = "";
        emailInput.text = "";
    }

    onVisibleChanged: {
        if(visible) {
            keyInput.textField.cursorPosition = 1
            keyInput.textField.forceActiveFocus()
        }
    }
}
