import QtQuick 2.12
import ViewModels 1.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import "../components"

import Theme 1.0

Item {
    id: windowLevelOverlay
    visible: windowLevelOverlayViewModel.display
    
    property var renderer
    
    WindowLevelOverlayViewModel {
        id: windowLevelOverlayViewModel
        viewport: renderer
        dragging: windowLevelSlider.dragging
    }
    
    WindowLevelSlider {
        id: windowLevelSlider
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right; margins: 30; leftMargin: 80;}
        height: 40

        minValue: windowLevelOverlayViewModel.windowMinMax.x
        maxValue: windowLevelOverlayViewModel.windowMinMax.y

        onMinShift: windowLevelOverlayViewModel.shiftMinWindow(shift)
        onMaxShift: windowLevelOverlayViewModel.shiftMaxWindow(shift)
        onMinMaxShift: windowLevelOverlayViewModel.shiftWindow(shift)
    }

    RowLayout {
        anchors { right: parent.right }

        Button {
            id: resetId
            state: "icon"
            icon.source: "qrc:/icons/reset.svg"

            onClicked: windowLevelOverlayViewModel.reset()
        }

        Item {
            visible: true
            width: resetId.width
            height: resetId.height
        }

        Item {
            visible: viewType === ImageViewport.ThreeD
            width: resetId.width
            height: resetId.height
        }
    }

}
