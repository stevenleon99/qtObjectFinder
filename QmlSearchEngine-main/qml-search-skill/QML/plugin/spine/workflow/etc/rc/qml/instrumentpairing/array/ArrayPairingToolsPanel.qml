import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0

Item {
    id: it
    Layout.preferredWidth: Theme.margin(135)
    Layout.fillHeight: true

    property var swappablePairingsViewModel

    ColumnLayout {
        anchors { fill: parent; leftMargin: Theme.marginSize; rightMargin: Theme.marginSize; bottomMargin: Theme.margin(1) }
        spacing: 0

        Label {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)
            state: "h6"
            font.bold: true
            verticalAlignment : Text.AlignVCenter
            text: qsTr("Instruments")
        }

        ListView {
            id: instrumentList
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            headerPositioning: ListView.OverlayHeader
            currentIndex: -1
            interactive: contentHeight > height

            model: swappablePairingsViewModel.toolList

            ListModel {
                id: instrumentHeaderModel
                ListElement { role: "role_pairingIndex"; displayText: ""; stateText: "text"; weight: 40 }
                ListElement { role: "role_partNumber"; displayText: "PART #"; stateText: "text"; weight: 100 }
                ListElement { role: "role_name"; displayText: "NAME"; stateText: "text"; weight: 400 }
            }

            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                visible: instrumentList.contentHeight > instrumentList.height
                anchors { right: parent.right; rightMargin: -Theme.margin(2) }
            }

            header: Rectangle {
                z: 100
                width: {
                    if (scrollBar.visible)
                        return instrumentList.width - Theme.margin(2)

                    return instrumentList.width
                }
                height: Theme.margin(8)
                color: Theme.backgroundColor

                RowLayout {
                    anchors { fill: parent; bottomMargin: Theme.marginSize * .5 }
                    spacing: 0

                    Repeater {
                        model: instrumentHeaderModel
                        property int selectedRole: -1

                        SortHeader {
                            Layout.alignment: Qt.AlignRight
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.preferredWidth: weight
                            state: stateText
                            sortText: displayText
                            sortRole: role === "role_pairingIndex" ? "" : role
                            sortedRole: swappablePairingsViewModel.sortedRoleName
                            sortedOrder: swappablePairingsViewModel.sortedOrder

                            onSort: swappablePairingsViewModel.sortToolList(roleName, order)
                        }
                    }
                }

                DividerLine { anchors.bottom: parent.bottom; anchors.bottomMargin: Theme.marginSize * .5; orientation: Qt.Horizontal }
            }

            delegate: Rectangle {
                width:  {
                    if (scrollBar.visible)
                        return instrumentList.width - Theme.margin(2)

                    return instrumentList.width
                }
                height: Theme.marginSize * 4
                radius: 8
                color: Theme.transparent

                Rectangle {
                    visible: role_toolId === swappablePairingsViewModel.selectedToolId
                    anchors { fill: parent }
                    opacity: 0.16
                    color: Theme.blue
                }

                ColumnLayout {
                    anchors { fill: parent }
                    spacing: 0

                    RowLayout {
                        spacing: 0
                        Layout.fillWidth: true
                        Layout.fillHeight: true

                        Repeater {
                            model: instrumentHeaderModel

                            Item {
                                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                                Layout.fillHeight: true
                                Layout.fillWidth: true
                                Layout.preferredWidth: weight

                                Rectangle {
                                    visible: role === "role_pairingIndex"
                                    anchors.centerIn: parent
                                    width: Theme.margin(4)
                                    height: width
                                    radius: width/2
                                    color: role_isPaired ? role_pairingColor : Theme.transparent
                                    border { color: Theme.lineColor; width: 1 }

                                    Label {
                                        visible: role_isPaired && role_displayArrayIndex
                                        anchors { centerIn: parent }
                                        state: "subtitle2"
                                        text: role_pairingIndex
                                    }
                                }

                                Label {
                                    visible: role !== "role_pairingIndex"
                                    leftPadding: Theme.marginSize
                                    state: "body1"
                                    anchors.fill: parent
                                    maximumLineCount: 1
                                    elide: Label.ElideRight
                                    wrapMode: Label.WrapAnywhere

                                    horizontalAlignment: Text.AlignLeft
                                    verticalAlignment: Text.AlignVCenter
                                    text: switch (index) {
                                          case 0: ""; break;
                                          case 1: role_partNumber; break;
                                          case 2: role_name; break;
                                          }
                                }
                            }
                        }
                    }

                    DividerLine { }
                }

                MouseArea {
                    z: 100
                    anchors { fill: parent }
                    onClicked: {
                        if (role_toolId === swappablePairingsViewModel.selectedToolId)
                        {
                            swappablePairingsViewModel.removeToolPairing()
                            return;
                        }
                        swappablePairingsViewModel.pairTool(role_toolId)
                    }
                }
            }
        }
    }

    DividerLine {
        anchors { right: parent.right }
    }
}
