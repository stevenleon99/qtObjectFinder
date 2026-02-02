import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0
import DriveEnums 1.0

import DriveImport 1.0

ColumnLayout {
    spacing: 0

    property bool exportSeriesEnabled: false

    signal exportSeries()

    states: [
        State {
            name: "patient"
            PropertyChanges {
                target: scanListModel
                scanSource: ScanSource.PATIENT
            }
        },
        State {
            name: "case"
            PropertyChanges {
                target: scanListModel
                scanSource: ScanSource.CASE
            }
        }
    ]

    RowLayout {
        Layout.preferredHeight: Theme.margin(8)

        Label {
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
            state: "body1"
            color: Theme.navyLight
            font { bold: true }
            font.capitalization: Font.AllUppercase
            text: qsTr("images")
        }

        Button {
            visible: exportSeriesEnabled
            enabled: scanListModel.count > 0
            Layout.alignment: Qt.AlignVCenter
            state: "icon"
            icon.source: "qrc:/icons/copy-above.svg"

            onClicked: exportSeries()
        }
    }

    Flickable {
        Layout.fillWidth: true
        Layout.fillHeight: true
        clip: true
        contentHeight: gridLayout.height

        GridLayout {
            id: gridLayout
            rowSpacing: Theme.marginSize
            columnSpacing: Theme.marginSize
            columns: 2

            Repeater {
                model: scanListModel

                ColumnLayout {
                    Layout.preferredWidth: Theme.margin(29)
                    spacing: Theme.margin(1)
                    ImageThumbnail {
                        Layout.preferredWidth: Theme.margin(29)
                        Layout.preferredHeight: Layout.preferredWidth
                        radius: Theme.margin(1)
                        source: "file:///" + role_thumbnail_path

                        onThumbnailClicked: {
                            scanListModel.selectScanId(role_scan_id);
                            scanDetailsPopup.open();
                        }
                    }

                    Item {
                        visible: false
                        Layout.fillWidth: true
                        Layout.preferredHeight: Theme.margin(6)
                        Label {
                            id: label
                            anchors { verticalCenter: parent.verticalCenter }
                            state: "subtitle1"
                            maximumLineCount: 1
                            elide: Label.ElideRight
                            wrapMode: Label.WrapAnywhere
                            font { bold: true }
                            text: role_description
                        }

                        Rectangle {
                            anchors { bottom: parent.bottom; bottomMargin: 5 }
                            width: label.width
                            height: 1
                            color: Theme.navy
                        }
                    }
                }
            }

            ScanDetailsPopup {
                id: scanDetailsPopup
                exportEnabled: imageExportViewModel.locationsCount > 0

                onExportImage: {
                    imageExportPopup.imageId = scanId
                    imageExportPopup.visible = true
                }
            }

            ImageExportPopup { id: imageExportPopup }

            ProgressBarDialog {
                visible: imageExportViewModel.exporting
                progressBar.from: 0
                progressBar.to:  1
                progressBar.value: imageExportViewModel.progress
                header: qsTr("Exporting Image")
            }
        }
    }
}
