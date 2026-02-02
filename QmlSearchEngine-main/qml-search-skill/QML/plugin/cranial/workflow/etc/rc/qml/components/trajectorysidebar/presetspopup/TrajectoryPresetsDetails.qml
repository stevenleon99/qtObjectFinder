import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import ".."
import "../.."

ColumnLayout {
    id: trajectoryPresetDetail
    spacing: 2

    property alias name: name.text
    property alias description: description.text
    property vector3d targetPosRas: Qt.vector3d(0, 0, 0)
    property double coronalAngle: 0
    property double sagittalAngle: 0
    property alias labelLR: valueStepperLR.labelTitle
    property alias labelPA: valueStepperPA.labelTitle
    property alias labelSI: valueStepperSI.labelTitle

    Label {
        id: name
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.preferredHeight: Theme.margin(10)
        state: "subtitle1"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
    }

    Label {
        Layout.fillWidth: true
        Layout.fillHeight: false
        text: qsTr("SOURCE")
        state: "subtitle2"
        color: Theme.navyLight
    }

    Label {
        id: description
        Layout.fillWidth: true
        Layout.fillHeight: false
        state: "body1"
        wrapMode: Label.WordWrap
        lineHeightMode: Text.FixedHeight
        lineHeight: Theme.margin(4)
    }

    Label {
        Layout.fillWidth: true
        Layout.fillHeight: false
        text: qsTr("COORDINATES")
        state: "subtitle2"
        color: Theme.navyLight
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: layout.height + Theme.margin(4)
        radius: Theme.margin(1)
        border { width: 1; color: Theme.blue }
        color: Theme.backgroundColor

        ColumnLayout {
            id: layout
            enabled: false
            width: parent.width - Theme.margin(4)
            anchors { centerIn: parent }
            spacing: Theme.margin(2)

            RowLayout {
                spacing: Theme.margin(2)

                ValueStepper {
                    id: valueStepperLR
                    Layout.preferredHeight: Theme.margin(6)
                    value: Math.abs(trajectoryPresetDetail.targetPosRas.x)
                    valueLabel: trajectoryPresetDetail.targetPosRas.x >= 0 ? "R" : "L"
                }

                ValueStepper {
                    id: valueStepperPA
                    Layout.preferredHeight: Theme.margin(6)
                    value: Math.abs(trajectoryPresetDetail.targetPosRas.y)
                    valueLabel: trajectoryPresetDetail.targetPosRas.y >= 0 ? "A" : "P"
                }

                ValueStepper {
                        id: valueStepperSI
                    Layout.preferredHeight: Theme.margin(6)
                    value: Math.abs(trajectoryPresetDetail.targetPosRas.z)
                    valueLabel: trajectoryPresetDetail.targetPosRas.z >= 0 ? "S" : "I"
                }
            }

            RowLayout {
                spacing: Theme.margin(2)

                TrajectoryAngleStepper {
                    state: "Coronal"
                    value: trajectoryPresetDetail.coronalAngle
                    valueLabel: trajectoryPresetDetail.coronalAngle >= 0 ? "°R" : "°L"
                    absolute: true
                }

                TrajectoryAngleStepper {
                    state: "Sagittal"
                    value: trajectoryPresetDetail.sagittalAngle
                    valueLabel: "°"
                }
            }
        }

    }

    LayoutSpacer { }
}
