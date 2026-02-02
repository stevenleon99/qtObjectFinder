import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import PageEnum 1.0
import IctImageStatesPage 1.0


import "../../components"
import "../../image"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    E3dImageViewModel {
        id: e3dImageViewModel
    }

    AutoScanImporterViewModel {
        id: autoScanImporterViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            title: qsTr("Image")
            pageNumber: 3
            maxPageNumber: 4
            description: qsTr("Select image with E3D.")
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
                    objectName: "e3dImageComboBox"
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(6)
                    rightPadding: iconButton.width
                    textRole: "role_label"
                    currentIndex: e3dImageViewModel.volumeIndex
                    displayText: volumeSelected ? currentText : qsTr("Import Image...")

                    model: e3dImageViewModel.ctVolumeListModel

                    property bool volumeSelected: comboBox.currentIndex >= 0

                    indicator: Item { }

                    onActivated: {
                        var index = e3dImageViewModel.ctVolumeListModel.index(index, 0)
                        e3dImageViewModel.selectVolume(model.data(index,256))
                    }

                    MouseArea {
                        anchors { fill: parent }

                        onClicked: {
                            if (!comboBox.volumeSelected)
                                importPopupLoader.item.open()
                        }
                    }

                    Button {
                        id: iconButton
                        anchors { right: parent.right }
                        icon.source: comboBox.volumeSelected ? "qrc:/icons/trash.svg"
                                                             : "qrc:/icons/image-add.svg"
                        state: "icon"

                        onClicked: {
                            if (comboBox.volumeSelected) {
                                var index = e3dImageViewModel.ctVolumeListModel.index(comboBox.currentIndex, 0)
                                e3dImageViewModel.deleteVolume(comboBox.model.data(index,256))
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
                Layout.preferredHeight: Theme.marginSize * 4
                spacing: Theme.marginSize

                IconImage {
                    id: checkmark
                    visible: comboBox.currentIndex === -1
                    source: "qrc:/icons/images.svg"
                    sourceSize: Theme.iconSize
                    color: Theme.navyLight
                }

                Label {
                    objectName: "e3dRegisteredLabel"
                    state: "subtitle1"
                    text: comboBox.currentIndex === -1 ?
                              qsTr("No Image Selected")
                            : qsTr("E3D Registered: ")
                }

                IconImage {
                    visible: comboBox.currentIndex !== -1
                    source: e3dImageViewModel.isE3dRegistered ? "qrc:/icons/check.svg" : "qrc:/icons/x.svg"
                    sourceSize: Theme.iconSize
                    color: e3dImageViewModel.isE3dRegistered ? Theme.green : Theme.red
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
