import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import PageEnum 1.0
import IctImageStatesPage 1.0
import GmQml 1.0

import "../../components"
import "../../image"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    IctImageViewModel {
        id: ictImageViewModel
    }

    AutoScanImporterViewModel {
        id: autoScanImporterViewModel
    }

    states: [
        State {
            when: comboBox.currentIndex === -1
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: busyIndicator; visible: false }
            PropertyChanges { target: detectText; text: qsTr("No Image Selected") }
            PropertyChanges { target: checkmark; source: "qrc:/icons/images.svg"; color: Theme.navyLight; visible: true }
        },
        State {
            when: ictImageViewModel.isTaskCancelling
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: busyIndicator; visible: true }
            PropertyChanges { target: detectText; text: qsTr("Canceling...") }
            PropertyChanges { target: detectButton; visible: false }
        },
        State {
            when: ictImageViewModel.isTaskRunning
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: busyIndicator; visible: true }
            PropertyChanges { target: detectText; text: qsTr("Searching for ICT...") }
            PropertyChanges { target: detectButton; visible: false }
        },
        State {
            when: ictImageViewModel.pageState == IctImageStatesPage.IctFoundStateCanContinue ||
                  ictImageViewModel.pageState == IctImageStatesPage.IctFoundStateCanNotContinue
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: checkmark; source: "qrc:/icons/check.svg"; color: Theme.green; visible: true }
            PropertyChanges { target: detectText; text: qsTr("ICT Acquired") }
            PropertyChanges { target: detectButton; visible: false }
        },
        State {
            when: ictImageViewModel.pageState == IctImageStatesPage.IctNotFoundStateCanContinue && !ictImageViewModel.attemptedDetectionForVolume
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: checkmark; source: "qrc:/icons/ict-array-2.svg"; color: Theme.navyLight; visible: true }
            PropertyChanges { target: detectText; text: qsTr("Detect ICT?") }
        },
        State {
            when: ictImageViewModel.pageState == IctImageStatesPage.IctNotFoundStateCanNotContinue || (ictImageViewModel.pageState == IctImageStatesPage.IctNotFoundStateCanContinue && ictImageViewModel.attemptedDetectionForVolume)
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: checkmark; source: "qrc:/icons/x.svg"; color: Theme.red; visible: true }
            PropertyChanges { target: detectText; text: qsTr("No ICT Found") }
        }
    ]

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            title: qsTr("Image")
            pageNumber: 3
            maxPageNumber: 5
            description: qsTr("Select image with ICT.")
        }

        ColumnLayout {
            Layout.margins: Theme.marginSize
            Layout.fillHeight: false
            spacing: Theme.marginSize

            ColumnLayout {
                spacing: Theme.margin(1)

                Label {
                    id: label
                    Layout.fillWidth: true
                    state: "body1"
                    color: Theme.navyLight
                    text: qsTr("Image Name")
                }

                ComboBox {
                    id: comboBox
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(6)
                    rightPadding: iconButton.width
                    textRole: "role_label"
                    currentIndex: ictImageViewModel.ictVolumeIndex
                    displayText: volumeSelected ? currentText : qsTr("Import Image...")

                    model: ictImageViewModel.ctVolumeListModel

                    property bool volumeSelected: comboBox.currentIndex >= 0

                    indicator: Item { }

                    onActivated: {
                        var index = ictImageViewModel.ctVolumeListModel.index(index, 0)
                        ictImageViewModel.selectVolume(model.data(index,256))
                    }

                    MouseArea {
                        anchors { fill: parent }

                        onClicked:  {
                            if (!comboBox.volumeSelected)
                                importPopupLoader.item.open()
                        }
                    }

                    Button {
                        id: iconButton
                        enabled: applicationViewModel.canImportVolume && !ictImageViewModel.isTaskCancelling
                        anchors { right: parent.right }
                        icon.source: comboBox.volumeSelected ? "qrc:/icons/trash.svg"
                                                             : "qrc:/icons/image-add.svg"
                        state: "icon"

                        onClicked: {
                            if (comboBox.volumeSelected) {
                                var index = ictImageViewModel.ctVolumeListModel.index(comboBox.currentIndex, 0)
                                ictImageViewModel.deleteVolume(comboBox.model.data(index,256))
                            } else {
                                importPopupLoader.item.open()
                            }
                        }
                    }
                }

                ImportPopupLoader {
                    id: importPopupLoader
                }
            }

            RowLayout {
                id: detectRow
                visible: false
                Layout.preferredHeight: Theme.marginSize * 4
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
                    Layout.fillWidth: true
                    state: "active"
                    text: "Detect"

                    onClicked: {
                        var index = ictImageViewModel.ctVolumeListModel.index(comboBox.currentIndex, 0)
                        ictImageViewModel.detectIct(comboBox.model.data(index, 256))
                    }
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

    Loader {
        anchors { fill: parent }
        active: autoScanImporterViewModel.importInProgress
        sourceComponent: ProgressBarDialog {
            visible: true
            progressBar.from: 0
            progressBar.to:  1
            progressBar.value: autoScanImporterViewModel.progress
            header: qsTr("Loading Scan")
        }
    }

    DividerLine { }
}
