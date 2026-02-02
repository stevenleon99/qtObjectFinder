import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import "../.."

ColumnLayout {
    spacing: Theme.marginSize * 3 / 4
    Layout.alignment: Qt.AlignVCenter

    property real _repeatDelay: 500
    property real _repeatInterval: 10

    states: [
        State {
            name: "Implant Length"
            PropertyChanges {
                target: m;
                lineColor: Theme.blue
                elementValue: trajectoryViewModel.activeTrajectory.implantLengthMm
            }
            PropertyChanges {
                target: elementLabel;
                text: qsTr("EE Top to Target")
            }
            PropertyChanges {
                target: horizontalLine
                width: 50
                anchors { left: parent.right; verticalCenter: parent.verticalCenter; leftMargin: Theme.marginSize }
            }
            PropertyChanges {
                target: verticalLine
                height: 496
                anchors { left: parent.right; verticalCenter: parent.verticalCenter; verticalCenterOffset: 55 }
            }
            PropertyChanges {
                target: minusButton
                onClicked: trajectoryViewModel.activeTrajectory.setImplantLengthMm(trajectoryViewModel.activeTrajectory.implantLengthMm - 0.5)
            }
            PropertyChanges {
                target: plusButton
                onClicked: trajectoryViewModel.activeTrajectory.setImplantLengthMm(trajectoryViewModel.activeTrajectory.implantLengthMm + 0.5)
            }
            PropertyChanges {
                target: applyToAllButton
                onClicked: trajectoryViewModel.setImplantLengthAll(trajectoryViewModel.activeTrajectory.implantLengthMm)
            }
            PropertyChanges {
                target: valueMouseArea
                onClicked: distanceCalculator.setup(parent,
                                                    trajectoryViewModel.activeTrajectory.implantLengthMm,
                                                    "",
                                                    "",
                                                    "",
                                                    (value) => { trajectoryViewModel.activeTrajectory.setImplantLengthMm(Math.abs(value)) })
            }
        },
        State {
            name: "EE Bottom to Entry"
            PropertyChanges {
                target: m;
                lineColor: Theme.yellow
                elementValue: trajectoryViewModel.activeTrajectory.eeBottomToEntryMm
            }
            PropertyChanges {
                target: elementLabel;
                text: qsTr("EE Bottom to Entry")
            }
            PropertyChanges {
                target: horizontalLine
                width: 88
                anchors { right: parent.left; verticalCenter: parent.verticalCenter; rightMargin: Theme.marginSize }
            }
            PropertyChanges {
                target: verticalLine
                height: 261
                anchors { right: parent.left; verticalCenter: parent.verticalCenter; verticalCenterOffset: -28 }
            }
            PropertyChanges {
                target: minusButton
                onClicked: trajectoryViewModel.activeTrajectory.setEeBottomToEntryMm(trajectoryViewModel.activeTrajectory.eeBottomToEntryMm - 0.5)
            }
            PropertyChanges {
                target: plusButton
                onClicked: trajectoryViewModel.activeTrajectory.setEeBottomToEntryMm(trajectoryViewModel.activeTrajectory.eeBottomToEntryMm + 0.5)
            }
            PropertyChanges {
                target: applyToAllButton
                onClicked: trajectoryViewModel.setEeBottomToEntryMmAll(trajectoryViewModel.activeTrajectory.eeBottomToEntryMm)
            }
            PropertyChanges {
                target: valueMouseArea
                onClicked: distanceCalculator.setup(parent,
                                                    trajectoryViewModel.activeTrajectory.eeBottomToEntryMm,
                                                    "",
                                                    "",
                                                    "",
                                                    (value) => { trajectoryViewModel.activeTrajectory.setEeBottomToEntryMm(Math.abs(value)) })
            }
        },
        State {
            name: "EE Top to Entry"
            PropertyChanges {
                target: m;
                lineColor: Theme.green
                elementValue: trajectoryViewModel.activeTrajectory.eeTopToEntryMm
            }
            PropertyChanges {
                target: elementLabel;
                text: qsTr("EE Top to Entry")
            }
            PropertyChanges {
                target: horizontalLine
                width: 20
                anchors { right: parent.left; verticalCenter: parent.verticalCenter; rightMargin: Theme.marginSize }
            }
            PropertyChanges {
                target: verticalLine
                height: 333
                anchors { right: parent.left; verticalCenter: parent.verticalCenter; verticalCenterOffset: 111 }
            }
            PropertyChanges {
                target: minusButton
                onClicked: trajectoryViewModel.activeTrajectory.setEeTopToEntryMm(trajectoryViewModel.activeTrajectory.eeTopToEntryMm - 0.5)
            }
            PropertyChanges {
                target: plusButton
                onClicked: trajectoryViewModel.activeTrajectory.setEeTopToEntryMm(trajectoryViewModel.activeTrajectory.eeTopToEntryMm + 0.5)
            }
            PropertyChanges {
                target: applyToAllButton
                onClicked: trajectoryViewModel.setEeTopToEntryMmAll(trajectoryViewModel.activeTrajectory.eeTopToEntryMm)
            }
            PropertyChanges {
                target: valueMouseArea
                onClicked: distanceCalculator.setup(parent,
                                                    trajectoryViewModel.activeTrajectory.eeTopToEntryMm,
                                                    "",
                                                    "",
                                                    "",
                                                    (value) => { trajectoryViewModel.activeTrajectory.setEeTopToEntryMm(Math.abs(value)) })
            }
        }
    ]

    Item {
        id: m

        property color lineColor
        property double elementValue
    }

    Rectangle {
        width: 216
        height: 64
        radius: 4
        color: Theme.transparent
        border { width: 1; color: Theme.lineColor }

        CalculatorLPS {
            id: distanceCalculator
        }

        Rectangle {
            id: horizontalLine
            width: 80
            height: 2
            color: m.lineColor

            Rectangle {
                id: verticalLine
                width: 2
                color: m.lineColor

                Rectangle {
                    width: 16
                    height: 2
                    anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.top }
                    color: m.lineColor
                }

                Rectangle {
                    width: 16
                    height: 2
                    anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.bottom }
                    color: m.lineColor
                }
            }
        }

        Rectangle {
            width: elementLabel.width + Theme.marginSize / 2
            height: 21
            anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.top }
            color: Theme.backgroundColor

            Label {
                id: elementLabel
                anchors.centerIn: parent
                state: "body1"
                color: m.lineColor
            }
        }

        RowLayout {
            anchors { fill: parent }

            RowLayout {
                Layout.alignment: Qt.AlignVCenter
                Layout.leftMargin: Theme.marginSize / 2
                Layout.rightMargin: Theme.marginSize / 2

                Button {
                    id: minusButton
                    Layout.fillWidth: false
                    icon.source: "qrc:/icons/minus.svg"
                    state: "icon"
                    autoRepeat: true
                    autoRepeatDelay: _repeatDelay
                    autoRepeatInterval: _repeatInterval
                }

                LayoutSpacer { }

                Label {
                    id: valueLabel
                    state: "h6"
                    font.bold: true
                    color: m.elementValue < 0 ? Theme.red : Theme.white
                    text: m.elementValue.toFixed(1)

                    MouseArea {
                        id: valueMouseArea
                        anchors { fill: parent }
                    }
                }

                LayoutSpacer { }

                Button {
                    id: plusButton
                    Layout.fillWidth: false
                    icon.source: "qrc:/icons/plus.svg"
                    state: "icon"
                    autoRepeat: true
                    autoRepeatDelay: _repeatDelay
                    autoRepeatInterval: _repeatInterval
                }
            }
        }
    }

    Rectangle {
        width: 216
        height: 48
        radius: 4
        color: Theme.transparent
        border { width: 1; color: Theme.white }

        Label {
            anchors { centerIn: parent }
            state: "body1"
            text: qsTr("Apply to All")
        }

        MouseArea {
            id: applyToAllButton
            anchors { fill: parent }
        }
    }
}
