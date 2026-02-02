import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmFluoroVisualizer 1.0

import "qrc:/uicom/fluorovisualizer/qml"

ColumnLayout {
    spacing: Theme.margin(4)

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text: qsTr("Fluoroscopy Configuration")
    }

    RowLayout {
        spacing: Theme.margin(4)
        visible: false // DRIVE-394
        SettingsDescription {
            Layout.alignment: Qt.AlignTop
            title: qsTr("Video Output")
            description: qsTr("Change the fluoroscopy system video output format.")
        }


        ColumnLayout {
            spacing: Theme.margin(1)

            Label {
                state: "body1"
                color: Theme.navyLight
                text: qsTr("Format")
            }

            ComboBox {
                Layout.preferredWidth: Theme.margin(25)
                Layout.preferredHeight: Theme.margin(6)
                model: ["PAL", "NTSC"]

                Component.onCompleted: currentIndex = find(settingsPlugin.videoFormat)

                onActivated: settingsPlugin.videoFormat = currentText
            }
        }
    }

    RowLayout {
        spacing: Theme.margin(4)

        SettingsDescription {
            Layout.alignment: Qt.AlignTop
            title: qsTr("Fixture Type")
            description: qsTr("Select the relevant fluoroscopy fixture type.")
        }

        ColumnLayout {
            spacing: Theme.margin(1)

            Label {
                state: "body1"
                color: Theme.navyLight
                text: qsTr("Type")
            }

            ComboBox {
                Layout.preferredWidth: Theme.margin(25)
                Layout.preferredHeight: Theme.margin(6)
                model: licenseManagerViewModel.getFluoroFixtureLicensed()

                Component.onCompleted: {
                    currentIndex = find(settingsPlugin.fluoroFixtureSize)
                    if (currentIndex === -1)
                    {
                        settingsPlugin.fluoroFixtureSize = licenseManagerViewModel.getFluoroFixtureLicensed()[0]
                        currentIndex = find(settingsPlugin.fluoroFixtureSize)
                    }
                }

                onActivated: settingsPlugin.fluoroFixtureSize = currentText
            }
        }
    }

    RowLayout {
        spacing: Theme.margin(4)

        SettingsDescription {
            Layout.alignment: Qt.AlignTop
            title: qsTr("Sensitivity")
            description: qsTr("Change the automatic fluoroscopy image capture sensitivity.")
        }

        ColumnLayout {
            spacing: Theme.margin(1)

            Label {
                state: "body1"
                color: Theme.navyLight
                text: qsTr("Level")
            }

            ComboBox {
                Layout.preferredWidth: Theme.margin(25)
                Layout.preferredHeight: Theme.margin(6)
                model: ["Off", "Low", "Medium", "High"]

                Component.onCompleted: currentIndex = find(settingsPlugin.fluoroSensitivity)

                onActivated: settingsPlugin.fluoroSensitivity = currentText
            }
        }
    }

    RowLayout {
        spacing: Theme.margin(4)

        SettingsDescription {
            title: qsTr("Connection Output")
            description: qsTr("View the output of the fluoroscopy connection to ensure image capture.")
        }

        Button {
            Layout.alignment: Qt.AlignTop
            state: "active"
            text: qsTr("View Output")

            onClicked: fluoroscopyOutputPopup.open()

            FluoroVisualizerPopup {
                id: fluoroscopyOutputPopup
            }
        }
    }
}
