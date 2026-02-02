import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

Popup {
    y: Theme.margin(42)
    width: Theme.margin(92)
    height: columnLayout.height
    closePolicy: Popup.NoAutoClose
    visible: false

    property string imageId
    property var locationIcons: {
        "USB": "qrc:/icons/usb.svg",
        "CDROM": "qrc:/icons/cd.svg",
        "HDD": "qrc:/icons/drive.svg"
    }

    ColumnLayout {
        id: columnLayout
        width: parent.width

        Label {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.margin(4)
            Layout.rightMargin: Theme.margin(4)
            Layout.topMargin: Theme.margin(2)
            Layout.preferredHeight: Theme.margin(10)
            state: "h4"
            verticalAlignment: Qt.AlignVCenter
            text: qsTr("Export Image")
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.margin(4)
            Layout.rightMargin: Theme.margin(4)
            spacing: Theme.margin(4)

            ColumnLayout {
                Layout.preferredWidth: Theme.margin(40)
                Layout.alignment: Qt.AlignTop
                spacing: 0

                Label {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(6)
                    state: "subtitle2"
                    verticalAlignment: Qt.AlignVCenter
                    color: Theme.navyLight
                    text: qsTr("LOCATIONS")
                }

                Repeater {
                    model: imageExportViewModel.locationList

                    delegate: SelectionItem {
                        text: role_name
                        iconSource: locationIcons[role_type]
                        selected: role_location == imageExportViewModel.selectedLocation

                        onItemSelected: imageExportViewModel.selectedLocation = role_location
                    }
                }
            }

            ColumnLayout {
                Layout.preferredWidth: Theme.margin(40)
                Layout.alignment: Qt.AlignTop
                spacing: 0

                Label {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(6)
                    state: "subtitle2"
                    verticalAlignment: Qt.AlignVCenter
                    color: Theme.navyLight
                    text: qsTr("TYPE")
                }

                Repeater {
                    model: imageExportViewModel.imageTypeList

                    delegate: SelectionItem {
                        text: modelData
                        iconSource: selected ? "qrc:/icons/check.svg" : ""
                        selected: modelData == imageExportViewModel.selectedImageType

                        onItemSelected: imageExportViewModel.selectedImageType = modelData
                    }
                }
            }
        }

        RowLayout {
            visible: imageExportViewModel.exportWarning
            Layout.leftMargin: Theme.margin(4)
            Layout.rightMargin: Theme.margin(4)
            Layout.topMargin: Theme.margin(4)
            spacing: 0

            IconImage {
                sourceSize: Theme.iconSize
                source: "qrc:/icons/alert-caution.svg"
                color: Theme.yellow500
            }

            Label {
                Layout.leftMargin: Theme.marginSize
                Layout.alignment: Qt.AlignVCenter
                state: "body1"
                color: Theme.yellow
                text: qsTr("Note: ")
            }

            Label {
                Layout.alignment: Qt.AlignVCenter
                state: "body1"
                text: imageExportViewModel.exportWarning
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(10)
            Layout.topMargin: Theme.margin(4)

            RowLayout {
                anchors { right: parent.right; rightMargin: Theme.margin(4); verticalCenter: parent.verticalCenter }
                spacing: Theme.margin(4)

                Button {
                    Layout.preferredWidth: Theme.margin(20)
                    state: "available"
                    text: qsTr("Close")

                    onClicked: close()
                }

                Button {
                    enabled: imageExportViewModel.selectedLocation
                             && imageExportViewModel.selectedImageType
                    Layout.preferredWidth: Theme.margin(20)
                    state: "active"
                    text: qsTr("Export")

                    onClicked: {
                        close()
                        imageExportViewModel.exportImage(imageId)
                    }
                }
            }

            DividerLine { anchors.top: parent.top; orientation: Qt.Horizontal }
        }
    }
}
