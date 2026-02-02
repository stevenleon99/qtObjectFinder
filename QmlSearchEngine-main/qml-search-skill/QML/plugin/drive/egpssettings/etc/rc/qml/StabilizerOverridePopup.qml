import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Popup {
    visible: false
    closePolicy: Popup.CloseOnPressOutsideParent

    onOpened: {
        acknowledgeButton.enabled = false
        acknowledgeTimer.restart()
    }

    signal cancelClicked()
    signal acknowledgeClicked()

    onCancelClicked: close()
    onAcknowledgeClicked: close()

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
                        state: "h5"
                        text: qsTr("Ensure Stabilizers Are Engaged")
                    }
                }
            }

            ColumnLayout {
                spacing: Theme.marginSize

                ColumnLayout {
                    Layout.margins: spacing
                    Layout.alignment: Qt.AlignTop
                    spacing: Theme.marginSize

                    RowLayout {
                        Layout.leftMargin: Theme.marginSize * 2
                        Layout.rightMargin: Theme.marginSize * 2
                        spacing: Theme.marginSize * 6

                        Image {
                            Layout.alignment: Qt.AlignHCenter
                            source: "qrc:/images/stabilizer/stabilizer-birds-eye.png"

                            Repeater {
                                model: ListModel {
                                    ListElement { role_source: "qrc:/images/stabilizer/stabilizer-top-left.png" }
                                    ListElement { role_source: "qrc:/images/stabilizer/stabilizer-top-right.png" }
                                    ListElement { role_source: "qrc:/images/stabilizer/stabilizer-bottom-right.png" }
                                    ListElement { role_source: "qrc:/images/stabilizer/stabilizer-bottom-left.png" }
                                }

                                Image {
                                    source: role_source
//                                    visible: stabilizerFailed

//                                    property bool stabilizerFailed: gpsClientController.stabilizerFailureList[index] ? gpsClientController.stabilizerFailureList[index] : false
                                }
                            }
                        }

                        AnimatedImage {
                            Layout.alignment: Qt.AlignHCenter
                            source: "qrc:/images/stabilizer/stabilizer-override.gif"
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        state: "h6"
                        text: qsTr("Engage failed stabilizers <font color=\"" + Theme.blue + "\">manually</font>.")
                        color: Theme.black
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 120
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

                            ColumnLayout {
                                spacing: 0

                                Repeater {
                                    model: ListModel {
                                        ListElement { role_text: "1. Identify the engaged stabilizers"}
                                        ListElement { role_text: "2. Remove remaining stabilizer covers." }
                                        ListElement { role_text: "3. Rotate dial count-clockwise until lifted." }
                                        ListElement { role_text: "4. Check the system stability; adjust height if needed." }
                                    }

                                    Label {
                                        text: role_text
                                        state: "body1"
                                        wrapMode: Text.WordWrap
                                        color: Theme.black
                                    }
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    spacing: Theme.marginSize
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: Theme.marginSize * 2

                    Button {
                        id: acknowledgeButton
                        enabled: false
                        state: "hinted"
                        text: qsTr("Acknowledge")

                        onClicked: acknowledgeClicked()

                        Timer {
                            id: acknowledgeTimer
                            running: true
                            interval: 5000

                            onTriggered: parent.enabled = true
                        }
                    }

                    Button {
                        state: "available"
                        text: qsTr("Cancel")
                        borderColor: Theme.blue

                        onClicked: cancelClicked()
                    }
                }
            }
        }
    }
}
