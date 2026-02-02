import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

ColumnLayout {
    spacing: Theme.marginSize * 2

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text: qsTr("Troubleshooting")
    }

    RowLayout {
        Layout.preferredHeight: Theme.marginSize * 4
        spacing: Theme.margin(4)

        SettingsDescription {
            objectName: "exportDataDescription"
            title: qsTr("Export Data")
            description: qsTr("Export system information.")
        }

        Button {
            objectName: "exportLogsButton"
            Layout.alignment: Qt.AlignTop
            enabled: locationsPopup.count
            Layout.preferredWidth: Theme.margin(24)
            state: "active"
            text: qsTr("Export Logs")

            onClicked: locationsPopup.open()

            LocationsPopup {
                objectName: "exportLogsButtonLocationsPopup"
                id: locationsPopup
                y: -height
                model: settingsPlugin.locationList

                onLocationSelected: {
                    settingsPlugin.exportLogs(location);
                    close();
                }
            }
        }

        Button {
            objectName: "exportScreenshotsButton"
            visible: false
            Layout.preferredWidth: Theme.margin(24)
            state: "active"
            text: qsTr("Export Screenshots")

            onClicked: settingsPlugin.exportScreenshots()
        }
    }

    RowLayout {
        spacing: Theme.margin(4)

        SettingsDescription {
            title: qsTr("Reset Components")
            description: qsTr("Reset software components.")
        }

        Button {
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: Theme.margin(24)
            state: "active"
            text: qsTr("Reset Software")

            onClicked: settingsPlugin.resetSoftware()
        }
    }
}
