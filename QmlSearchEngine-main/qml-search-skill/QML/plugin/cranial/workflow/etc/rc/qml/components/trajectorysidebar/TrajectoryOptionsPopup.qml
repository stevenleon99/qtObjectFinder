import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import ".."

Popup {
    width: layout.width
    height: layout.height

    background: Rectangle { radius: Theme.margin(1); color: Theme.backgroundColor }

    function setup(positionItem) {
        var topRight = positionItem.mapToItem(null, positionItem.width, 0)
        x = topRight.x - width
        y = topRight.y
        open()
    }

    TrajectoryOptionsViewModel {
        id: trajectoryOptionsViewModel
        nextTrajectoryColor: Theme.trajectoriesColorList[trajectoryOptionsViewModel.trajectoryCount %
                                                      Theme.trajectoriesColorList.length]
    }

    ColumnLayout {
        id: layout
        spacing: 0

        TrajectoryOption {
            icon: "qrc:/icons/pencil.svg"
            text: qsTr("Rename Trajectory")

            onClicked: {
                trajectoryRenamePopup.open()
                close()
            }

            TextFieldPopup {
                id: trajectoryRenamePopup
                initialText: trajectoryOptionsViewModel.activeTrajectoryName
                maxTextLength: 50
                placeholderText: qsTr("Ex. Biopsy #1")
                popupTitle: qsTr("Rename Trajectory")

                onConfirmClicked: trajectoryOptionsViewModel.setActiveTrajectoryName(confirmedText)
            }
        }

        TrajectoryOption {
            icon: "qrc:/icons/plus-circle-multiple.svg"
            text: qsTr("Clone Trajectory")

            onClicked: {
                trajectoryOptionsViewModel.cloneActiveTrajectory()
                close()
            }
        }

        TrajectoryOption {
            icon: "qrc:/icons/flip-horizontal.svg"
            text: qsTr("Mirror Trajectory")

            onClicked: {
                trajectoryOptionsViewModel.mirrorActiveTrajectory()
                close()
            }
        }

        TrajectoryOption {
            icon: "qrc:/icons/lock.svg"
            text: trajectoryOptionsViewModel.isActiveTrajeLocked?qsTr("Unlock Trajectory"):qsTr("Lock Trajectory")

            onClicked: {
                trajectoryOptionsViewModel.changeLockStateActiveTrajectory();
                close()
            }
        }

        TrajectoryOption {
            icon: "qrc:/icons/trash.svg"
            iconColor: Theme.red
            text: qsTr("Delete Trajectory")

            onClicked: {
                trajectoryOptionsViewModel.deleteActiveTrajectory()
                close()
            }
        }
    }
}
