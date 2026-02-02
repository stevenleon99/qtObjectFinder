import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

ColumnLayout {
    spacing: Theme.margin(4)

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("Calibration")
    }

    ColumnLayout {
        spacing: Theme.margin(2)

        SettingsDescription {
            title: qsTr("Calibration")
            description: qsTr("Calibrate motion components.")
        }

        Label {
            state: "body1"
            color: Theme.navyLight
            text: qsTr("Loadcell Data:")
        }

        Rectangle {
            Layout.preferredHeight: gridLayout.height
            Layout.preferredWidth: gridLayout.width
            radius: 4
            border { width: 1; color: Theme.lineColor }
            color: Theme.transparent

            GridLayout {
                id: gridLayout
                columns: 4
                rowSpacing: 0
                columnSpacing: 0

                LoadCellViewModel {
                    id: loadCellViewModel
                }

                Repeater {
                    model: 4

                    delegate: ColumnLayout {
                        spacing: 0

                        LoadCellValue {
                            label: "F"
                            valueVector: loadCellViewModel.loadCellForce
                        }

                        LoadCellValue {
                            label: "T"
                            valueVector: loadCellViewModel.loadCellTorque
                        }
                    }
                }
            }
        }
    }

    Button {
        state: "active"
        text: qsTr("Calibrate Loadcell")
        onClicked: loadCellViewModel.onCalibrateLoadCellPressed()
    }
    
    ColumnLayout {
        spacing: Theme.margin(1)

        SettingsDescription {
            title: qsTr("Rehome Arm")
            description: qsTr("Calibrate the arm's joint positions.")
        }

        Repeater {
            model: ListModel {
                ListElement { role_text: qsTr("Ensure foot pedal is not engaged.") }
                ListElement { role_text: qsTr("Push \"Rehome\" button below and follow instructions on screen.") }
            }

            Label {
                state: "body1"
                text: (index + 1) + ". " + role_text
            }
            
        }
    }
    
    Button {
        state: "active"
        text: qsTr("Rehome")
        onClicked: homingViewModel.forceRehome()
    }

    ColumnLayout {
        spacing: Theme.margin(1)

        SettingsDescription {
            title: qsTr("End Effector Calibration")
            description: qsTr("Calibrate End Effector.")
        }

        Repeater {
            model: ListModel {
                ListElement { role_text: qsTr("Disconnect the End Effector from the robotic arm.") }
                ListElement { role_text: qsTr("Place an instrument in the End Effector.") }
                ListElement { role_text: qsTr("Reconnect the End Effector to the robotic arm.") }
                ListElement { role_text: qsTr("The blue light should begin blinking.") }
                ListElement { role_text: qsTr("When the blue light begins blinking rapidly, remove the instrument.") }
                ListElement { role_text: qsTr("Wait for the blue light to stop blinking and remain solid.") }
                ListElement { role_text: qsTr("Press and release the foot pedal or surgeon bracelet.") }
            }

            Label {
                state: "body1"
                text: (index + 1) + ". " + role_text
            }
        }
    }
}
