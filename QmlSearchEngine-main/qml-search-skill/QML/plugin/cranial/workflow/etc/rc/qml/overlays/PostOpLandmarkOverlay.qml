import QtQuick 2.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

import '.'

Item {
    visible: renderer.viewType !== ImageViewport.ThreeD  &&
             postOpLandmarkOverlayViewModel.isVisible

    property var renderer

    PostOpLandmarkOverlayViewModel {
        id: postOpLandmarkOverlayViewModel
        viewport: renderer
    }

    ControlPuck {
        onShiftLeftClicked: postOpLandmarkOverlayViewModel.shiftPosition(-1,0)

        onShiftRightClicked: postOpLandmarkOverlayViewModel.shiftPosition(1,0)

        onShiftUpClicked: postOpLandmarkOverlayViewModel.shiftPosition(0,-1)

        onShiftDownClicked: postOpLandmarkOverlayViewModel.shiftPosition(0,1)

        onPressed: {
            var xNew = centerPoint.x - (parent.width / 2)
            var yNew = centerPoint.y - (parent.height / 2)
            postOpLandmarkOverlayViewModel.startDrag()
            console.log("On Pressed", xNew, yNew)
        }

        onPositionChanged: {
            var xNew = centerPoint.x - (parent.width / 2)
            var yNew = centerPoint.y - (parent.height / 2)
            postOpLandmarkOverlayViewModel.dragPosition(xNew, yNew)
        }

        onReleased: {
            postOpLandmarkOverlayViewModel.endDrag()
            x = (parent.width / 2) - (width / 2)
            y = (parent.height / 2) - (height / 2)
        }
    }
}
