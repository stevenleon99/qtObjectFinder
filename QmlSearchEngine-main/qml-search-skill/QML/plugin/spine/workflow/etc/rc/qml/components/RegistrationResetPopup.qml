import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4

import Theme 1.0

import Enums 1.0
import ViewModels 1.0

Popup {
    visible: false

    property  RegistrationResetViewModel regResetViewModel

    Rectangle {
        id: popup
        width: layout.width
        height: layout.height
        radius: 4
        anchors { centerIn: parent }
        color: Theme.backgroundColor

        ColumnLayout {
            id: layout
            Layout.minimumWidth: 400
            spacing: 0

            Item {
                Layout.minimumWidth: headerText.implicitWidth + Theme.marginSize * 2
                Layout.preferredHeight: 160
                Layout.fillWidth: true
                clip: true

                Rectangle {
                    radius: 4
                    width: popup.width
                    height: popup.height
                    color: Theme.foregroundColor
                }

                ColumnLayout {
                    anchors { centerIn: parent }
                    spacing: Theme.marginSize

                    Label {
                        Layout.alignment: Qt.AlignHCenter
                        state: "h6"
                        text: qsTr("TROUBLESHOOTING")
                        color: Theme.lineColor
                    }

                    Label {
                        id: headerText
                        state: "h5"
                        text: qsTr("Registration Options")
                    }
                }

                Button {
                    anchors { right: parent.right; top: parent.top; margins: Theme.marginSize / 2 }
                    icon.source: "qrc:/icons/x.svg"
                    state: "icon"

                    onClicked: close()
                }
            }

            RowLayout {
                Layout.margins: spacing
                spacing: Theme.marginSize * 2

                Repeater {
                    id: repeater
                    model: regResetViewModel.resetOptionsList

                    Rectangle {
                        id: rectangle
                        Layout.preferredWidth: 300
                        Layout.preferredHeight: 300
                        radius: 4
                        color: mouseArea.pressed ? Theme.slate800 : Theme.backgroundColor
                        border { width: mouseArea.pressed ? 0 : 1; color: Theme.white }

                        ColumnLayout {
                            anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 40}
                            spacing: Theme.margin(1.5)

                            IconImage {
                                Layout.alignment: Qt.AlignHCenter
                                sourceSize.width: Theme.iconSize.width * 1.5
                                sourceSize.height: Theme.iconSize.height * 1.5
                                color: mouseArea.pressed ? Theme.blue : Theme.navyLight
                                source: role_icon
                            }

                            Label {
                                Layout.maximumWidth: rectangle.width - Theme.margin(4)
                                Layout.alignment: Qt.AlignHCenter
                                horizontalAlignment: Text.AlignHCenter
                                font { bold: true }
                                state: "h6"
                                color: Theme.navyLight
                                text: role_title
                                wrapMode: Text.Wrap
                            }

                            ColumnLayout {
                                Layout.maximumWidth: rectangle.width - Theme.margin(8)
                                Layout.alignment: Qt.AlignHCenter
                                spacing: Theme.margin(1.5)

                                Repeater {
                                    model: role_steps

                                    RowLayout {
                                        Layout.fillWidth: true
                                        spacing: Theme.margin(2)

                                        Label {
                                            Layout.alignment: Qt.AlignTop
                                            font { bold: true }
                                            state: "body1"
                                            color: Theme.navyLight
                                            text: "•"
                                            wrapMode: Text.Wrap
                                        }

                                        Label {
                                            Layout.fillWidth: true
                                            Layout.alignment: Qt.AlignHCenter
                                            horizontalAlignment: Text.AlignLeft
                                            font { bold: true }
                                            state: "body1"
                                            color: Theme.navyLight
                                            text: modelData
                                            wrapMode: Text.Wrap
                                        }
                                    }
                                }
                            }
                        }

                        MouseArea {
                            id: mouseArea
                            anchors { fill: parent }

                            onClicked: { 
                                if (role_key == RegistrationResetOption.ReImagePatient)
                                {
                                    regResetViewModel.reImagePatientRequest()
                                }
                                else if (role_key == RegistrationResetOption.ConvertTo2d3d)
                                {
                                    regResetViewModel.convertTo2d3dRequest()
                                }
                                else if (role_key == RegistrationResetOption.ConvertTo2d)
                                {
                                    regResetViewModel.convertTo2dRequest()
                                }
                                else if (role_key == RegistrationResetOption.RetakeShots)
                                {
                                    regResetViewModel.retakeShotsRequest()
                                }

                                close()
                            }
                        }
                    }
                }
            }
        }
    }
}
