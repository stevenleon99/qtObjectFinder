import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import ".."

ColumnLayout {
    spacing: 0

    readonly property alias trajectoryCount: trajectory.trajectoryCount
    readonly property bool trajectorySelected: trajectory.selectedIndex > 0

    TrajectorySelectorViewModel {
        id: trajectorySelector
        // onModelIndexChanged: trajectory.selectedIndex = modelIndex;
    }

    Rectangle {
        id: dropdown
        visible: trajectoryCount
        Layout.fillHeight: false
        Layout.fillWidth: true
        Layout.leftMargin: Theme.marginSize
        Layout.rightMargin: Theme.marginSize
        Layout.preferredHeight: Theme.marginSize * 3
        color: Theme.slate700
        radius: 4
        border.color: trajectoryListPopup.visible || mouseArea.pressed ? Theme.blue : Theme.navy

        RowLayout {
            anchors { fill: parent }
            TrajectoryListDelegate {
                id: trajectory
                width: parent.width
                height: Theme.marginSize * 3
                textColor: Theme.white

                readonly property int selectedIndex: trajectorySelector.modelIndex

                readonly property int trajectoryCount: trajectoryListPopup.count - 1 // 1 is subtracted to account for "none" element in list model

                function selectCurrent() {
                    trajectory.name = trajectorySelector.getTrajectoryListData(trajectorySelector.modelIndex, "role_name")
                    trajectory.iconColor = trajectorySelector.getTrajectoryListData(trajectorySelector.modelIndex, "role_cadColor")
                    trajectory.isLocked = trajectorySelector.getTrajectoryListData(trajectorySelector.modelIndex, "role_locked")
                }

                Connections {
                    target: trajectoryViewModel.activeTrajectory

                    onCadColorChanged: trajectory.selectCurrent()

                    onNameChanged: trajectory.selectCurrent()

                    onIsLockedChanged: trajectory.selectCurrent()
                }

                onSelectedIndexChanged: trajectory.selectCurrent()

                Component.onCompleted: trajectory.selectCurrent()
            }

            IconImage {
                Layout.alignment: Qt.AlignVCenter
                color: trajectoryListPopup.visible || mouseArea.pressed ? Theme.blue : Theme.navyLight
                fillMode: Image.PreserveAspectFit
                source: "qrc:/icons/down.svg"
                sourceSize: Theme.iconSize
            }
        }

        MouseArea {
            id: mouseArea
            anchors { fill: parent }
            onPressed: {
                if (!trajectoryListPopup.visible)
                    trajectoryListPopup.setup(dropdown)
            }
        }

        TrajectoryListPopup {
            id: trajectoryListPopup
            width: dropdown.width
            model: trajectorySelector.trajectoryList
            selectedId: trajectorySelector.activeTrajectoryId

            onItemSelected: {
                trajectorySelector.selectTrajectory(id)
                close()
            }

            onItemMoved: trajectorySelector.setTrajectoryDisplayedOrder(id, position)
        }
    }
}
