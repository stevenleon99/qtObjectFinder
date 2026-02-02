import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import ViewModels 1.0

import Theme 1.0

import ".."

Item {
    id: fPostOpOverlay
    visible: fPostOpOverlayViewModel.isVisible
    clip: true
    property var renderer

    PostOpFluoroOverlayViewModel {
        id: fPostOpOverlayViewModel
        viewport: renderer
    }

    Rectangle {
        id: puck
        property point centerPoint: Qt.point(fPostOpOverlayViewModel.viewCenterProjection.x-width/2,fPostOpOverlayViewModel.viewCenterProjection.y-height/2)
        x: centerPoint.x
        y: centerPoint.y
        width: height
        height: 98
        radius: width/2
        border.color: Theme.blue
        color: 'transparent'
        border.width: 2

        // Center
        Rectangle {
            height: 4
            width: height
            radius: width/2
            color: Theme.blue
            anchors { centerIn: parent }
        }

        // Top
        Rectangle {
            height: 25
            width: 2
            color: Theme.blue
            anchors { horizontalCenter: parent.horizontalCenter; top: parent.top }
        }

        // Bottom
        Rectangle {
            height: 25
            width: 2
            color: Theme.blue
            anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
        }

        // left
        Rectangle {
            height: 2
            width: 25
            color: Theme.blue
            anchors { verticalCenter: parent.verticalCenter; left: parent.left }
        }

        // right
        Rectangle {
            height: 2
            width: 25
            color: Theme.blue
            anchors { verticalCenter: parent.verticalCenter; right: parent.right }
        }

        MouseArea {
            id: puckMouseArea
            anchors { fill: puck }
            drag { target: puck; axis: Drag.XAndYAxis; threshold: 0;
                   minimumX: 0; maximumX: fPostOpOverlay.width - puck.width;
                   minimumY: 0; maximumY: fPostOpOverlay.height - puck.height }

            onPressed: fPostOpOverlayViewModel.startDrag()
            onPositionChanged: fPostOpOverlayViewModel.setNewPosition(puck.x+puck.width/2,puck.y+puck.height/2)
            onReleased: fPostOpOverlayViewModel.endDrag()
        }

        Button {
            anchors { right: puck.left; verticalCenter: puck.verticalCenter }
            width: Theme.margin(6)
            height: Theme.margin(6)
            leftPadding: 0
            rightPadding: 0
            flat: true
            icon.color: down ? Theme.lighterBlue : Theme.blue
            icon.source: "qrc:/icons/arrow.svg"
            onClicked: fPostOpOverlayViewModel.setNewPosition(puck.x+puck.width/2 - 1, puck.y+puck.height/2)
        }

        Button {
            anchors { left: puck.right; verticalCenter: puck.verticalCenter }
            width: Theme.margin(6)
            height: Theme.margin(6)
            leftPadding: 0
            rightPadding: 0
            flat: true
            rotation: 180
            icon.color: down ? Theme.lighterBlue : Theme.blue
            icon.source: "qrc:/icons/arrow.svg"
            onClicked: fPostOpOverlayViewModel.setNewPosition(puck.x+puck.width/2 + 1, puck.y+puck.height/2)
        }

        Button {
            anchors { bottom: puck.top; horizontalCenter: puck.horizontalCenter }
            width: Theme.margin(6)
            height: Theme.margin(6)
            leftPadding: 0
            rightPadding: 0
            flat: true
            rotation: 90
            icon.color: down ? Theme.lighterBlue : Theme.blue
            icon.source: "qrc:/icons/arrow.svg"
            onClicked: fPostOpOverlayViewModel.setNewPosition(puck.x+puck.width/2, puck.y+puck.height/2 - 1)
        }

        Button {
            anchors { top: puck.bottom; horizontalCenter: puck.horizontalCenter }
            width: Theme.margin(6)
            height: Theme.margin(6)
            leftPadding: 0
            rightPadding: 0
            flat: true
            rotation: -90
            icon.color: down ? Theme.lighterBlue : Theme.blue
            icon.source: "qrc:/icons/arrow.svg"
            onClicked: fPostOpOverlayViewModel.setNewPosition(puck.x+puck.width/2, puck.y+puck.height/2 + 1)
        }
    }
}


