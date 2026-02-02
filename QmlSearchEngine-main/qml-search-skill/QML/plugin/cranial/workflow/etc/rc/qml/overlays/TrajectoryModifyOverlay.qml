import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import ViewModels 1.0

import Theme 1.0

Item {
    visible: renderer.scanList.length && 
             renderer.viewType !== ImageViewport.ThreeD  &&
             trajectoryModifyOverlayViewModel.active
    
    property var renderer

    TrajectoryModifyOverlayViewModel {
        id: trajectoryModifyOverlayViewModel
        viewport: renderer
    }

    RowLayout {
        anchors { top: parent.top; right: parent.right; }
        spacing: Theme.marginSize / 2

        Button {
            state: "icon"
            icon.source: "qrc:/icons/crosshair.svg"
            color: Theme.blue
        }

        Label {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.rightMargin: 6 * Theme.marginSize
            font { bold: true }
            verticalAlignment: Text.AlignVCenter
            state: "subtitle1"
            color: Theme.blue
            text: trajectoryModifyOverlayViewModel.modifyTarget.toUpperCase()
        }
    }

    ControlPuck {

        onShiftLeftClicked: trajectoryModifyOverlayViewModel.shiftPosition(-1, 0)

        onShiftRightClicked: trajectoryModifyOverlayViewModel.shiftPosition(1, 0)

        onShiftUpClicked: trajectoryModifyOverlayViewModel.shiftPosition(0, -1)

        onShiftDownClicked: trajectoryModifyOverlayViewModel.shiftPosition(0, 1)

        onPressed: trajectoryModifyOverlayViewModel.startDrag()

        onPositionChanged: {
            var x = centerPoint.x - (parent.width / 2)
            var y = centerPoint.y - (parent.height / 2)
            trajectoryModifyOverlayViewModel.dragPosition(x, y)
        }

        onReleased: {
            trajectoryModifyOverlayViewModel.endDrag()
            x = (parent.width / 2) - (width / 2)
            y = (parent.height / 2) - (height / 2)
        }
    }
}


