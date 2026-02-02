import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import PageEnum 1.0
import IctFiducialStatesPage 1.0

import "../../components"
import "../../components/draggedfiducial"

Item {
    id: ictFiducialsSidebar
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    IctFiducialViewModel {
        id: ictFiducialViewModel
    }

    states: [
        State {
            PropertyChanges { target: valueMeterFreId; visible: false }
        },
        State {
            when: ictFiducialViewModel.pageState == IctFiducialStatesPage.IctErrorHigh
            PropertyChanges { target: valueMeterFreId; visible: false }
        },
        State {
            when: ictFiducialViewModel.pageState == IctFiducialStatesPage.IctErrorLow
            PropertyChanges { target: valueMeterFreId; visible: true }
        }
    ]

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            title: qsTr("Detect ICT")
            pageNumber: 4
            maxPageNumber: 5
            description: qsTr("Modify fiducials until fit is sufficient.")

            SectionHeader {
                Layout.leftMargin: 0
                Layout.rightMargin: 0
                title: qsTr("FIDUCIALS")

                Button {
                    enabled: ictFiducialViewModel.fiducialCount > 0
                    icon.source: "qrc:/icons/trash.svg"
                    state: "icon"

                    onClicked: ictFiducialViewModel.deleteSelectedFiducial()
                }
            }

            ColumnLayout {
                spacing: Theme.marginSize

                GridLayout {
                    id: gridLayout
                    columns: 4
                    rowSpacing: Theme.marginSize / 2
                    columnSpacing: Theme.marginSize / 2

                    Repeater {
                        model: ictFiducialViewModel.fiducialList

                        delegate: Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: width
                            Layout.maximumWidth: (ictFiducialsSidebar.width - ((gridLayout.columns - 1) * gridLayout.rowSpacing)) / gridLayout.columns

                            color: "black"

                            ImageThumbnail {
                                anchors { fill: parent }
                                visible: role_isValid
                            source: "image://combinedBB/" +
                                    ictFiducialViewModel.scanUuid + "/" +
                                    role_position.x + "/" +
                                    role_position.y + "/" +
                                    role_position.z + "/" +
                                    mmWidth + "/" +
                                    width

                            property real mmWidth: 6.35 * 2
                            }

                            Rectangle {
                                visible: role_isSelected || !role_isValid
                                anchors { fill: parent; margins: 0 }
                                border { width: 2; color: role_isValid ? Theme.blue : Theme.red }
                                color: Theme.transparent
                            }

                            Rectangle {
                                anchors { centerIn: parent }
                                width: Theme.margin(4)
                                height: width
                                radius: width / 2
                                border { width: 2; color: role_isValid ? Theme.blue : Theme.red }
                                color: Theme.transparent
                            }

                            DraggedFiducialMouseArea {
                                anchors { fill: parent }

                                fidIndex: index

                                onFiducialPressed: ictFiducialViewModel.toggleSelectedFiducial(index)
                            }
                        }
                    }
                }

                ValueMeter {
                    id: valueMeterFreId
                    Layout.fillWidth: true
                    value: ictFiducialViewModel.fre
                    visible: false
                    text: qsTr("Registration Fit")
                }
            }
        }

        LayoutSpacer { }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            PageControls {
                anchors { verticalCenter: parent.verticalCenter }
                width: parent.width
            }

            DividerLine {
                orientation: Qt.Horizontal
                anchors { top: parent.top }
            }
        }
    }

    DividerLine { }
}
