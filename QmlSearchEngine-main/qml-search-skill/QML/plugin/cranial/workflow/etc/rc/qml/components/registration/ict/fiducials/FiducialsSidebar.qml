import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0
import AppPage 1.0
import IctFiducialStatesPage 1.0

import "../.."
import "../../.."
import "../../../imagesidebar"

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
            when: ictFiducialViewModel.pageState == IctFiducialStatesPage.NoVolumeSelected
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: busyIndicator; visible: false }
            PropertyChanges { target: detectText; text: qsTr("No Image Selected"); visible: true }
            PropertyChanges { target: checkmark; source: "qrc:/icons/images.svg"; color: Theme.navyLight; visible: true }
            PropertyChanges { target: addFiducial; enabled: false }
            PropertyChanges { target: detectButton; visible: false }
            PropertyChanges { target: fiducialHeader; visible: false }
        },
        State {
            when: ictFiducialViewModel.isTaskCancelling
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: detectButton; visible: false }
            PropertyChanges { target: busyIndicator; visible: true }
            PropertyChanges { target: detectText; text: qsTr("Canceling..."); visible: true }
        },
        State {
            when: ictFiducialViewModel.isTaskRunning
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: detectButton; visible: false }
            PropertyChanges { target: busyIndicator; visible: true }
            PropertyChanges { target: detectText; text: qsTr("Searching for ICT..."); visible: true }
        },
        State {
            when: ictFiducialViewModel.pageState == IctFiducialStatesPage.IctErrorLow ||
                  ictFiducialViewModel.pageState == IctFiducialStatesPage.IctErrorHigh
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: checkmark; source: "qrc:/icons/check.svg"; color: Theme.green; visible: true }
            PropertyChanges { target: detectText; text: qsTr("ICT Acquired"); visible: true }
            PropertyChanges { target: valueMeterFreId; visible: true }
            PropertyChanges { target: fiducialHeader; visible: true }
            PropertyChanges { target: detectButton; enabled: false }
        },
        State {
            when: ictFiducialViewModel.pageState == IctFiducialStatesPage.DetectionNotRun
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: checkmark; source: "qrc:/icons/ict-array-2.svg"; color: Theme.navyLight; visible: true }
            PropertyChanges { target: detectText; text: qsTr("Detect ICT?"); visible: true }
            PropertyChanges { target: fiducialHeader; visible: true }
            PropertyChanges { target: detectButton; visible: true }
        },
        State {
            when: ictFiducialViewModel.pageState == IctFiducialStatesPage.NotIctDetected
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: checkmark; source: "qrc:/icons/x.svg"; color: Theme.red; visible: true }
            PropertyChanges { target: detectText; text: qsTr("No ICT Found"); visible: true }
            PropertyChanges { target: fiducialHeader; visible: true }
            PropertyChanges { target: detectButton; visible: true }
        }
    ]

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            state: "Registration Sidebar"
            title: qsTr("Image")
            pageNumber: 2
            maxPageNumber: 4
            description: qsTr("Select image with ICT and modify fiducials until fit is sufficient.")
        }

        ColumnLayout {
            spacing: 0
            Layout.fillHeight: false
            Layout.fillWidth: true

            Label {
                id: label
                Layout.fillWidth: true
                state: "body1"
                color: Theme.navyLight
                text: qsTr("Image Name")
                Layout.leftMargin: Theme.marginSize
                Layout.topMargin: Theme.marginSize/2
            }

            RowLayout {
                Layout.leftMargin: Theme.marginSize
                Layout.rightMargin: Theme.margin(1)
                Layout.fillHeight: false
                Layout.topMargin: Theme.marginSize/4
                spacing: 8

                OptionsDropdown {
                    id: comboBox
                    Layout.preferredWidth: Theme.margin(35)
                    Layout.preferredHeight: Theme.margin(6)
                    textRole: "role_label"
                    currentIndex: ictFiducialViewModel.ictVolumeIndex()
                    displayText: ictFiducialViewModel.pageState == IctFiducialStatesPage.NoVolumeSelected ? qsTr("Select Image") : currentText

                    model: ictFiducialViewModel.ctVolumeListModel
                    property bool volumeSelected: comboBox.currentIndex >= 0

                    onActivated: {
                        var index = ictFiducialViewModel.ctVolumeListModel.index(index, 0)
                        ictFiducialViewModel.selectVolume(model.data(index,256))
                    }
                }

                Button {
                    Layout.fillHeight: true
                    enabled: applicationViewModel.canImportVolume
                    Layout.alignment: Qt.AlignVCenter
                    icon.source: "qrc:/icons/image-add.svg"
                    state: "icon"

                    onClicked: importPopupLoader.item.open()
                }

                ImportPopupLoader {
                    id: importPopupLoader
                }
            }
        }

        RowLayout {
            id: detectRow
            visible: false
            Layout.preferredHeight: Theme.margin(6)
            Layout.preferredWidth: Theme.margin(40)
            Layout.rightMargin: Theme.marginSize
            Layout.topMargin: Theme.marginSize
            Layout.leftMargin: Theme.marginSize
            spacing: Theme.marginSize

            BusyIndicator {
                id: busyIndicator
                visible: false
                Layout.preferredWidth: Theme.marginSize * 2
                Layout.preferredHeight: Theme.marginSize * 2
            }

            IconImage {
                id: checkmark
                visible: false
                source: "qrc:/icons/check.svg"
                sourceSize: Theme.iconSize
                color: Theme.green
            }

            Label {
                id: detectText
                Layout.fillWidth: true
                state: "subtitle1"
            }

            Button {
                id: detectButton
                visible: comboBox.currentIndex > -1
                leftPadding: Theme.marginSize
                rightPadding: Theme.marginSize
                font.letterSpacing: 0
                state: "active"
                text: "Detect"

                onClicked: {
                    var index = ictFiducialViewModel.ctVolumeListModel.index(comboBox.currentIndex, 0)
                    ictFiducialViewModel.detectIct(comboBox.model.data(index, 256))
                }
                Rectangle {
                    id: detectButtonColor
                    anchors.fill: parent
                    color: Theme.transparent
                }
            }
        }


        SectionHeader {
            id: fiducialHeader
            anchors.top: detectRow.bottom
            Layout.rightMargin: Theme.margin(1)
            title: qsTr("FIDUCIALS (") + ictFiducialViewModel.fiducialCount + ("/7)")
            spacing: 0

            Button {
                enabled: ictFiducialViewModel.fiducialCount > 0 && !ictFiducialViewModel.isTaskCancelling
                icon.source: "qrc:/icons/trash.svg"
                state: "icon"

                onClicked: {
                    if (enabled) {
                        ictFiducialViewModel.deleteSelectedFiducial()
                    }
                }
            }

            Button {
                id: addFiducial
                enabled: ictFiducialViewModel.fiducialCount < 7
                icon.source: "qrc:/icons/plus.svg"
                state: "icon"

                onClicked: ictFiducialViewModel.addFiducial()
            }
        }

        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: false
            sourceComponent: gridLayoutComponent
            active: ictFiducialViewModel.pageState == IctFiducialStatesPage.IctErrorLow ||
                    ictFiducialViewModel.pageState == IctFiducialStatesPage.IctErrorHigh ||
                    ictFiducialViewModel.pageState == IctFiducialStatesPage.NotIctDetected
            asynchronous: true
            visible: status == Loader.Ready
        }

        ColumnLayout {
            id: gridLayoutComponent
            spacing: Theme.marginSize

            GridLayout {
                id: gridLayout
                columns: 4
                rowSpacing: Theme.margin(1)
                columnSpacing: Theme.margin(1)
                Layout.leftMargin: Theme.marginSize
                Layout.rightMargin: 32.71

                Repeater {
                    model: ictFiducialViewModel.fiducialList

                    delegate: ImageThumbnail {
                        Layout.fillWidth: true
                        Layout.preferredHeight: width
                        Layout.maximumWidth: Theme.margin(9)
                        source: "image://combinedBB/" +
                                ictFiducialViewModel.scanUuid + "/" +
                                role_position.x + "/" +
                                role_position.y + "/" +
                                role_position.z + "/" +
                                mmWidth + "/" +
                                width

                        property real mmWidth: 6.35 * 2

                        Rectangle {
                            visible: role_isSelected
                            anchors { fill: parent; margins:0 }
                            border { width: 2; color: Theme.blue }
                            color: Theme.transparent
                            radius: 4
                        }

                        Rectangle {
                            anchors { centerIn: parent }
                            width: Theme.margin(4)
                            height: width
                            radius: width / 2
                            border { width: 2; color: Theme.blue }
                            color: Theme.transparent
                        }

                        MouseArea {
                            anchors { fill: parent }

                            onClicked: {
                                ictFiducialViewModel.toggleSelectedFiducial(index)
                            }
                        }
                    }
                }
            }

            ValueMeter {
                id: valueMeterFreId
                Layout.fillWidth: true
                Layout.bottomMargin: Theme.marginSize
                Layout.leftMargin: Theme.marginSize
                Layout.rightMargin: 22
                value: ictFiducialViewModel.fre
                visible: false
                text: qsTr("Registration Fit")
            }
        }

        LayoutSpacer { }

        PageControls {
            Layout.fillHeight: false

            forwardEnabled: ictFiducialViewModel.pageState == IctFiducialStatesPage.IctErrorLow

            onBackClicked: applicationViewModel.switchToPage(AppPage.IctSetup)

            onForwardClicked: applicationViewModel.switchToPage(ictFiducialViewModel.nextPage)
        }
    }

    DividerLine { }
}
