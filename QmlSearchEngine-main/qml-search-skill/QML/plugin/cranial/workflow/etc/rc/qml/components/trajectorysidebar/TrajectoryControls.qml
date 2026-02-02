import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import ".."

ColumnLayout {
    spacing: 0

    property bool positionControlEnabled: true
    property bool angleControlEnabled: true
    property bool setEntryTargetVisible: true
    property bool trajectoryLocked: trajectoryViewModel.activeTrajectory.isLocked

    SectionHeader {
        id: sectionHeader
        title: trajectoryViewModel.activeTrajectory.name
        textState: "h6"
        textColor: Theme.white

        Button {
            state: "icon"
            icon.source: "qrc:/icons/fill-color-outline.svg"

            Button {
                state: "icon"
                icon.source: "qrc:/icons/fill-color-fill.svg"
                color: trajectoryViewModel.activeTrajectory.cadColor

                onClicked: trajectoryColorPopup.setup(sectionHeader)

                TrajectoryColorPopup {
                    id: trajectoryColorPopup
                    selectedColor: trajectoryViewModel.activeTrajectory.cadColor

                    onColorSelected: trajectoryViewModel.activeTrajectory.cadColor = color
                }
            }
        }

        Button {
            state: "icon"
            icon.source: trajectoryViewModel.activeTrajectory.visible ? "qrc:/icons/visibility-on.svg"
                                                                      : "qrc:/icons/visibility-off.svg"

            onClicked: trajectoryViewModel.activeTrajectory.visible = !trajectoryViewModel.activeTrajectory.visible
        }

        Button {
            rotation: 90
            icon.source: "qrc:/icons/dots.svg"
            state: "icon"

            onClicked: trajectoryOptionsPopup.setup(this)

            TrajectoryOptionsPopup {
                id: trajectoryOptionsPopup
                visible: false
                width: sectionHeader.width
            }
        }
    }

    TrajectoryPositionControl {
        Layout.leftMargin: Theme.margin(2)
        Layout.rightMargin: Theme.margin(2)
        Layout.bottomMargin: Theme.margin(2)
    }
}
