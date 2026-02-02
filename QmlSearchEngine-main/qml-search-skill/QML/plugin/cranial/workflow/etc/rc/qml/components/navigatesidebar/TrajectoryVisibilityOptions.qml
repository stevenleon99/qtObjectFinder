import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import "../trajectorysidebar"

Popup {
    width: layout.width
    height: layout.height

    background: Rectangle { radius: Theme.margin(1); color: Theme.backgroundColor }

    /**
     * Opens this popup adjacent to the QML object positionItem.
     *
     * The popup will be positioned under positionItem, with the top right corner of the popup
     * meeting the bottom right corner of positionItem.
     *
     * Example usage: trajectoryVisibilityOptions.attachAndOpen(this)
     */
    function attachAndOpen(positionItem) {
        var bottomRight = positionItem.mapToItem(null, positionItem.width, positionItem.height)
        x = bottomRight.x - width
        y = bottomRight.y
        open()
    }

    TrajectoryVisibilityOptionsViewModel {
        id: trajectoryVisibilityOptionsVM
    }

    ColumnLayout {
        id: layout
        spacing: 0

        TrajectoryOption {
            iconEnabled: false
            text: qsTr("Show All")

            onClicked: {
                trajectoryVisibilityOptionsVM.showAllTrajectories()
                close()
            }
        }

        TrajectoryOption {
            iconEnabled: false
            text: qsTr("Show Selected Only")

            onClicked: {
                trajectoryVisibilityOptionsVM.showOnlyActiveTrajectory()
                close()
            }
        }

        TrajectoryOption {
            iconEnabled: false
            text: qsTr("Hide All")

            onClicked: {
                trajectoryVisibilityOptionsVM.hideAllTrajectories()
                close()
            }
        }
    }
}
