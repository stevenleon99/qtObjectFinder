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
    y: Qt.inputMethod.visible ? Theme.margin(5) : (parent.height / 2) - (height / 2)
    width: layout.width
    height: layout.height
    closePolicy: Popup.CloseOnEscape

    property string email
    property string activationKey

    property bool pinPreferred: false

    UserCodeRequirementsPopup {
        id: pinRequirements
        visible: false
        pinMode: true
        code: userCodeInput.pinInput.text
        confirmCode: userCodeInput.confirmPinInput.text
    }

    UserCodeRequirementsPopup {
        id: passwordRequirements
        visible: false
        pinMode: false
        code: userCodeInput.passwordInput.text
        confirmCode: userCodeInput.confirmPasswordInput.text
    }

    UserCodeRequirementsPopup {
        id: userCodeRequirementsPopup
        visible: userCodeInput.editing
        code: pinMode ? userCodeInput.pinInput.text : userCodeInput.passwordInput.text
        confirmCode: pinMode ? userCodeInput.confirmPinInput.text : userCodeInput.confirmPasswordInput.text
        z: 1
    }

    ColumnLayout {
        id: layout
        spacing: 0

        RowLayout {
            Layout.margins: Theme.margin(4)
            spacing: Theme.margin(3)

            UserIcon {
                Layout.alignment: Qt.AlignTop
                Layout.preferredWidth: 160
                Layout.preferredHeight: 160
                iconColor: userDetailsInput.selectedColor
                iconText: userDetailsInput.initials
                state: "login"
            }

            ColumnLayout {
                spacing: Theme.margin(3)

                ColumnLayout {
                    spacing: Theme.margin(2)

                    Label {
                        state: "h4"
                        text: qsTr("New User")
                    }

                    UserDetailsInput {
                        id: userDetailsInput
                    }

                    UserCodeInput {
                        id: userCodeInput
                        inputPin: userViewModel.platformType !== PlatformType.Laptop
                    }

                    RowLayout {
                        visible: userCodeInput.inputPin
                        spacing: parent.spacing

                        Label {
                            Layout.fillWidth: true
                            state: "body1"
                            color: Theme.navyLight
                            text: "Default Login Method"
                        }

                        Label {
                            opacity: !pinPreferred ? 1.0 : 0.5
                            state: "body1"
                            font.bold: true
                            text: "Password"
                        }

                        Switch {
                            objectName: "autoPinPreferredSwitchObj"
                            checked: pinPreferred

                            onClicked: pinPreferred = !pinPreferred
                        }

                        Label {
                            opacity: pinPreferred ? 1.0 : 0.5
                            state: "body1"
                            font.bold: true
                            text: "PIN"
                        }
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: Theme.margin(2)

                    Button {
                        Layout.preferredWidth: 128
                        state: "available"
                        text: qsTr("Cancel")

                        onPressed: close()
                    }

                    Button {
                        objectName: "autoCreateUserButtonObj"
                        enabled: userDetailsInput.username &&
                                 userDetailsInput.initials &&
                                 (!userCodeInput.inputPin || pinRequirements.valid) &&
                                 passwordRequirements.valid &&
                                 !Qt.colorEqual(userDetailsInput.selectedColor, Theme.black)
                        Layout.preferredWidth: 128
                        state: "hinted"
                        text: qsTr("Confirm")

                        onPressed: {
                            userViewModel.createUser(email, activationKey,
                                                     userDetailsInput.username,
                                                     userDetailsInput.initials,
                                                     userDetailsInput.selectedColor,
                                                     userCodeInput.pinInput.text,
                                                     userCodeInput.passwordInput.text,
                                                     pinPreferred)
                            close()
                        }
                    }
                }
            }
        }
    }

    onClosed: {
        userDetailsInput.username = ""
        userDetailsInput.initials = ""
        userCodeInput.clear()
        userDetailsInput.selectedColor = Theme.black
        pinPreferred = false
    }
}
