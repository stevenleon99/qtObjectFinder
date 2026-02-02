import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4
import QtQml.Models 2.2

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0

Popup {
    visible: !navigationTipsViewModel.navigationTipsAcknowledged
    closePolicy: Popup.NoAutoClose

    NavigationTipsViewModel {
        id: navigationTipsViewModel
    }

    Rectangle {
        id: popup
        width: layout.width
        height: layout.height
        radius: 4
        anchors { centerIn: parent }
        color: Theme.white

        ColumnLayout {
            id: layout
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
                    color: Theme.blue
                }

                ColumnLayout {
                    anchors { centerIn: parent }
                    spacing: Theme.marginSize

                    Label {
                        Layout.alignment: Qt.AlignHCenter
                        state: "h6"
                        text: qsTr("HOW TO")
                        color: Theme.headerColor
                    }

                    Label {
                        id: headerText
                        objectName: "navigationTipsHeaderText"
                        state: "h5"
                        text: qsTr("Ensure Navigational Integrity")
                    }
                }
            }

            ColumnLayout {
                spacing: 0

                RowLayout {
                    Layout.margins: spacing
                    spacing: Theme.marginSize * 2

                    Repeater {
                        id: repeater
                        model: ListModel {
                            ListElement { role_source: "qrc:/images/offset-check.png"; role_message: qsTr("Perform an anatomical landmark check <font color=\"#0099FF\">with each new instrument or level</font>."); role_details: qsTr("Landmark checks ensure integrity of registration and instruments.") }
                            ListElement { role_source: "qrc:/images/work-towards-base.png"; role_message: qsTr("<font color=\"#0099FF\">Work towards the reference base</font> from the distal level."); role_details: qsTr("This order limits changes to registration for multi-level surgery.") }
                            ListElement { role_source: "qrc:/images/surveillance-drift.png"; role_message: qsTr("<font color=\"#0099FF\">Use a surveillance marker</font> to reduce registration anatomical drift."); role_details: qsTr("Surveillance provides continuous monitoring of the reference array.") }
                        }

                        ColumnLayout {
                            visible: switch (index) {
                                     case 0:
                                     case 1: return true
                                     case 2: return gpsClientController.surveillanceStatus !== TrackingEnums.SURVEILLANCE_ACTIVE
                                     }

                            Layout.alignment: Qt.AlignTop
                            Layout.preferredWidth: 320
                            spacing: Theme.marginSize

                            Image {
                                Layout.alignment: Qt.AlignHCenter
                                source: role_source
                            }

                            Label {
                                Layout.fillWidth: true
                                wrapMode: Text.WordWrap
                                horizontalAlignment: Text.AlignHCenter
                                state: "h6"
                                text: role_message
                                color: Theme.black
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 100
                                radius: 4
                                color: Qt.lighter(Theme.yellow, 1.8)

                                RowLayout {
                                    anchors { fill: parent; margins: Theme.marginSize }
                                    spacing: Theme.marginSize

                                    Rectangle {
                                        Layout.alignment: Qt.AlignTop
                                        Layout.preferredWidth: Theme.marginSize * 2.5
                                        Layout.preferredHeight: width
                                        radius: height / 2
                                        color: Theme.yellow

                                        IconImage {
                                            anchors { centerIn: parent }
                                            sourceSize: Qt.size(Theme.marginSize * 1.5, Theme.marginSize * 1.5)
                                            source: "qrc:/icons/alert-caution.svg"
                                            color: Theme.black
                                        }
                                    }

                                    Label {
                                        Layout.fillWidth: true
                                        Layout.fillHeight: true
                                        text: role_details
                                        state: "body1"
                                        wrapMode: Text.WordWrap
                                        color: Theme.black
                                    }
                                }
                            }
                        }
                    }
                }

                Button {
                    objectName: "navigationAcknowledgeButton"
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: Theme.marginSize * 2
                    width: 160
                    height: 48
                    state: "hinted"
                    text: qsTr("Acknowledge")

                    onClicked: {
                        navigationTipsViewModel.acknowledge()
                        close()
                    }
                }
            }
        }
    }
}
