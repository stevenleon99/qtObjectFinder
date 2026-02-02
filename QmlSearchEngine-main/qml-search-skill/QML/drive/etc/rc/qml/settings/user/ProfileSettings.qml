import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import ".."
import "../../login"
import "../../components"

ColumnLayout {
    spacing: Theme.margin(4)

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("Profile")
    }

    RowLayout {
        spacing: Theme.margin(4)

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            spacing: Theme.marginSize

            SettingsDescription {
                Layout.alignment: Qt.AlignTop
                title: qsTr("User Details")
                description: qsTr("Change and view your user details.")
            }

            UserIcon {
                Layout.preferredWidth: Theme.margin(20)
                Layout.preferredHeight: Theme.margin(20)
                iconColor: layout.selectedColor
                iconText: userViewModel.activeUser.initials
                state: "login"
            }
        }

        ColumnLayout {
            spacing: Theme.marginSize

            TitledTextField {
                Layout.preferredWidth: Theme.margin(58)
                Layout.maximumWidth: Theme.margin(58)
                enabled: false
                title: qsTr("Email Address")
                text: userViewModel.activeUser.email
            }

            TitledTextField {
                id: usernameInput
                Layout.preferredWidth: Theme.margin(58)
                Layout.maximumWidth: Theme.margin(58)
                title: qsTr("Username")
                text: userViewModel.activeUser.name
            }

            TitledTextField {
                id: initialsInput
                Layout.preferredWidth: Theme.margin(58)
                Layout.maximumWidth: Theme.margin(58)
                title: qsTr("Initials (2)")
                inputMethod: TitledTextField.InputMethod.Initials
                text: userViewModel.activeUser.initials
            }

            ColumnLayout {
                spacing: Theme.margin(1)

                Label {
                    text: qsTr("Portrait Color")
                    state: "body1"
                    color: Theme.headerTextColor
                }

                Rectangle {
                    Layout.preferredWidth: layout.width + Theme.margin(4)
                    Layout.preferredHeight: layout.height + Theme.margin(4)
                    color: Theme.transparent
                    border.color: Theme.navyLight
                    radius: 4

                    RowLayout {
                        id: layout
                        x: Theme.margin(2)
                        y: Theme.margin(2)
                        spacing: Theme.marginSize

                        Repeater {
                            model: Theme.secondaryColorList

                            Rectangle {
                                Layout.preferredWidth: 40// Theme.marginSize * 2
                                Layout.preferredHeight: width
                                radius: 4
                                border { width: Qt.colorEqual(layout.selectedColor, modelData) ? 4 : 0; color: Theme.blue }
                                color: modelData

                                MouseArea {
                                    anchors { fill: parent }

                                    onClicked: layout.selectedColor = modelData
                                }
                            }
                        }

                        property color selectedColor: userViewModel.activeUser.iconColor
                    }
                }
            }

            Button {
                state: "active"
                text: qsTr("Update User Details")

                onClicked: userViewModel.setUserPreferences(userViewModel.activeUser.uuid,
                                                            usernameInput.text,
                                                            initialsInput.text,
                                                            layout.selectedColor);
            }
        }
    }
}
