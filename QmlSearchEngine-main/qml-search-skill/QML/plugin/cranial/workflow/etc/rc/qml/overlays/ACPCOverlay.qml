import QtQuick 2.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

Item {
    visible: renderer.scanList.length && 
             renderer.viewType !== ImageViewport.ThreeD  &&
             acpcOverlayViewModel.onTarget
    
    property var renderer
    
    ACPCOverlayViewModel {
        id: acpcOverlayViewModel
        viewport: renderer
    }

    ControlPuck {

        onShiftLeftClicked: acpcOverlayViewModel.shiftPosition(-1, 0)

        onShiftRightClicked: acpcOverlayViewModel.shiftPosition(1, 0)

        onShiftUpClicked: acpcOverlayViewModel.shiftPosition(0, -1)

        onShiftDownClicked: acpcOverlayViewModel.shiftPosition(0, 1)

        onPressed: acpcOverlayViewModel.startDrag()

        onPositionChanged: {
            var x = centerPoint.x - (parent.width / 2)
            var y = centerPoint.y - (parent.height / 2)
            acpcOverlayViewModel.dragPosition(x, y)
        }

        onReleased: {
            acpcOverlayViewModel.endDrag()
            x = (parent.width / 2) - (width / 2)
            y = (parent.height / 2) - (height / 2)
        }
    }
}
