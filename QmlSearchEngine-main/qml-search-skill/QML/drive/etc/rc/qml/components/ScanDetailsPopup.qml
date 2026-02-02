import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

Popup {
    width: Theme.margin(124)
    height: columnLayout.height
    closePolicy: Popup.NoAutoClose

    property alias exportEnabled: exportButton.enabled

    signal exportImage(string scanId)

    ColumnLayout {
        id: columnLayout
        width: parent.width

        ColumnLayout {
            Layout.margins: Theme.margin(4)
            spacing: Theme.margin(2)

            RowLayout{
                Label {
                    Layout.fillWidth: true
                    Layout.topMargin: Theme.margin(1)
                    state: "h4"
                    text: qsTr("Image Details")
                }

                LayoutSpacer {}

                Button {
                    id: exportButton
                    state: "icon"
                    icon.source: "qrc:/icons/export.svg"

                    onClicked: {
                        close()
                        exportImage(scanListModel.scanDetails.scanId)
                    }
                }
            }

            RowLayout {
                spacing: Theme.margin(4)

                ColumnLayout {
                    id: thumbnailColumn
                    spacing: 0

                    ImageThumbnail {
                        id: imageThumbnail
                        Layout.preferredWidth: Theme.margin(60)
                        Layout.preferredHeight: width
                        Layout.alignment: Qt.AlignTop
                        source: scanListModel.selectedScanPath ? "file:///" + scanListModel.selectedScanPath
                                                               : ""
                    }

                    Item {
                        visible: repeater.count > 0
                        Layout.preferredWidth: Theme.margin(60)
                        Layout.preferredHeight: Theme.margin(22)
                    }
                }

                ColumnLayout {
                    spacing: Theme.margin(4)

                    RowLayout {
                        Layout.maximumHeight: thumbnailColumn.height
                        spacing: 0

                        Flickable {
                            id: flickable
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.rightMargin: -Theme.margin(2)
                            contentHeight: contentColumn.height
                            clip: true

                            ScrollBar.vertical: ScrollBar {
                                parent: flickable.parent
                                Layout.fillHeight: true
                                Layout.leftMargin: Theme.margin(2)
                                padding: Theme.marginSize
                            }

                            ColumnLayout {
                                id: contentColumn
                                width: parent.width
                                spacing: Theme.margin(3)

                                ColumnLayout {
                                    Layout.alignment: Qt.AlignTop
                                    spacing: Theme.margin(3)

                                    Label {
                                        Layout.fillWidth: true
                                        state: "body2"
                                        font.styleName: Theme.mediumFont.styleName
                                        verticalAlignment: Qt.AlignVCenter
                                        color: Theme.navyLight
                                        text: qsTr("DETAILS")
                                    }

                                    ColumnLayout {
                                        spacing: Theme.margin(1.5)

                                        Label {
                                            visible: scanListModel.scanDetails.showScanId
                                            Layout.fillWidth: true
                                            font.bold: true
                                            state: "subtitle1"
                                            text: scanListModel.scanDetails.scanId
                                        }

                                        NameValueRow { name: qsTr("Patient ID"); value: scanListModel.scanDetails.patientID }
                                        NameValueRow { name: qsTr("Birthdate"); value: scanListModel.scanDetails.birthdate }
                                        NameValueRow { name: qsTr("Created"); value: scanListModel.scanDetails.createdDate }
                                        NameValueRow { name: qsTr("Plane"); value: scanListModel.scanDetails.plane }
                                        NameValueRow { name: qsTr("Series #"); value: scanListModel.scanDetails.seriesNumber }
                                        NameValueRow { name: qsTr("Slices"); value: scanListModel.scanDetails.slices }
                                        NameValueRow { name: qsTr("Thickness"); value: scanListModel.scanDetails.thickness }
                                        NameValueRow { name: qsTr("Description"); value: scanListModel.scanDetails.description }
                                        NameValueRow { name: qsTr("Modality"); value: scanListModel.scanDetails.modality }
                                        NameValueRow { name: qsTr("Equipment"); value: scanListModel.scanDetails.equipment }
                                        NameValueRow { visible: scanListModel.scanDetails.hasE3Dregistration; name: qsTr("E3D Navigated"); }
                                    }
                                }

                                ColumnLayout {
                                    visible: repeater.count > 0
                                    spacing: 0

                                    DividerLine {
                                        orientation: Qt.Horizontal
                                    }

                                    Label {
                                        Layout.preferredHeight: Theme.margin(8)
                                        state: "body2"
                                        font.styleName: Theme.mediumFont.styleName
                                        verticalAlignment: Qt.AlignVCenter
                                        color: Theme.navyLight
                                        text: qsTr("WARNINGS")
                                    }

                                    ColumnLayout {
                                        spacing: Theme.margin(2)

                                        Repeater {
                                            id: repeater
                                            model: scanListModel.scanDetails.warningsList

                                            delegate: Item {
                                                Layout.fillWidth: true
                                                Layout.preferredHeight: rowLayout.height

                                                RowLayout {
                                                    id: rowLayout
                                                    width: parent.width
                                                    spacing: Theme.margin(2)

                                                    IconImage {
                                                        sourceSize: Theme.iconSize
                                                        source: "qrc:/icons/alert-caution.svg"
                                                        color: Theme.yellow
                                                    }

                                                    Label {
                                                        Layout.fillWidth: true
                                                        state: "body1"
                                                        text: role_warning_text
                                                    }

                                                    IconImage {
                                                        sourceSize: Theme.iconSize
                                                        source: "qrc:/icons/info-circle-outline.svg"
                                                        color: Theme.white
                                                    }
                                                }

                                                MouseArea {
                                                    anchors { fill: parent }

                                                    onClicked: scanListModel.scanDetails.displayWarning(role_warning_id)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    Button {
                        Layout.alignment: Qt.AlignRight | Qt.AlignBottom
                        Layout.preferredWidth: Theme.margin(20)
                        state: "available"
                        text: qsTr("Close")

                        onClicked: close()
                    }
                }
            }
        }
    }
}
