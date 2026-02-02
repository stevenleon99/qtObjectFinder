import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4

import Theme 1.0

import Enums 1.0
import ViewModels 1.0

Popup {
    visible: false
    signal resetRegistration

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
                        text: qsTr("Interbody Placement Detected")
                        color: Theme.lineColor
                    }

                    Label {
                        id: headerText
                        state: "h5"
                        text: qsTr("Registration for Screw Navigation")
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

                Rectangle {
                        Layout.preferredWidth: 300
                        Layout.preferredHeight: 300
                        radius: 4
                        color: mouseAreaContinue.pressed ? Theme.slate800 : Theme.backgroundColor
                        border { width: mouseAreaContinue.pressed ? 0 : 1; color: Theme.white }

                        ColumnLayout {
                            anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 40}
                            spacing: Theme.marginSize / 2

                            IconImage {
                                Layout.alignment: Qt.AlignHCenter
                                sourceSize.width: Theme.iconSize.width * 1.5
                                sourceSize.height: Theme.iconSize.height * 1.5
                                color: mouseAreaContinue.pressed ? Theme.blue : Theme.navyLight
                                source: "qrc:/icons/screw.svg"
                            }

                            Label {
                                Layout.alignment: Qt.AlignHCenter
                                horizontalAlignment: Text.AlignHCenter
                                font { bold: true }
                                state: "h6"
                                color: Theme.white
                                text: "Continue with Current \nRegistration"
                            }

                            Label {
                                Layout.alignment: Qt.AlignHCenter
                                horizontalAlignment: Text.AlignLeft
                                font { bold: true }
                                state: "body1"
                                color: Theme.navyLight
                                text: "• Images may have shifted \nafter interbody placement"
                            }
                        }

                        MouseArea {
                            id: mouseAreaContinue 
                            anchors { fill: parent }

                            onClicked: { 
                                close()
                            }
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 300
                        Layout.preferredHeight: 300
                        radius: 4
                        color: mouseAreaChange.pressed ? Theme.slate800 : Theme.backgroundColor
                        border { width: mouseAreaChange.pressed ? 0 : 1; color: Theme.white }

                        ColumnLayout {
                            anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: 40}
                            spacing: Theme.marginSize / 2

                            IconImage {
                                Layout.alignment: Qt.AlignHCenter
                                sourceSize.width: Theme.iconSize.width * 1.5
                                sourceSize.height: Theme.iconSize.height * 1.5
                                color: mouseAreaChange.pressed ? Theme.blue : Theme.navyLight
                                source: "qrc:/icons/image-add.svg"
                            }

                            Label {
                                Layout.alignment: Qt.AlignHCenter
                                horizontalAlignment: Text.AlignHCenter
                                font { bold: true }
                                state: "h6"
                                color: Theme.white
                                text: "Re-Image & Invalidate \nCurrent Shots"
                            }

                            Label {
                                Layout.alignment: Qt.AlignHCenter
                                horizontalAlignment: Text.AlignLeft
                                font { bold: true }
                                state: "body1"
                                color: Theme.navyLight
                                text: "• Invalidates current shots \nirreversibly \n \n • Requires acquisition of \n new shots to Navigate"
                            }
                        }

                        MouseArea {
                            id: mouseAreaChange
                            anchors { fill: parent }

                            onClicked: { 
                                resetRegistration()
                                close()
                            }
                        }
                    }
            }
        }
    }
}