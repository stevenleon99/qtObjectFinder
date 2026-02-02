import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import ViewModels 1.0

import Theme 1.0

Item {
    id: checkerboardOverlay
    visible: ((renderer.scanList.length == 2   && renderer.viewType === ImageViewport.Traj_1) || 
              (renderer.imageNames.length == 2 && renderer.viewType === ImageViewport.FluoroImage))
            && checkerboardOverlayViewModel.active
    
    property var renderer
    
    clip: true

    function updatePuckPosition() {
        puck.x = checkerboardOverlayViewModel.checkboardPosition.x*checkerboardOverlay.width - puck.width/2
        puck.y = checkerboardOverlayViewModel.checkboardPosition.y*checkerboardOverlay.height - puck.height/2
    }

    Component.onCompleted: updatePuckPosition()

    onWidthChanged: updatePuckPosition()

    onHeightChanged: updatePuckPosition()

    CheckerboardOverlayViewModel {
        id: checkerboardOverlayViewModel

        onCheckboardPositionChanged: {
            if(!puckMouseArea.pressed) {
                updatePuckPosition()
            }
        }
    }

    Image {
        id: puck
        x: (parent.width/2) - (width/2)
        y: (parent.height/2) - (height/2)
        property point centerPoint: Qt.point(x+width/2,y+height/2)
        source: "qrc:/icons/checkerboard.svg"

        MouseArea {
            id: puckMouseArea
            anchors { fill: puck }
            drag { target: puck; axis: Drag.XAndYAxis; threshold: 0;
                   minimumX: 0 - puck.width/2; maximumX: checkerboardOverlay.width - puck.width/2; 
                   minimumY: 0 - puck.height/2; maximumY: checkerboardOverlay.height - puck.height/2 }

            onPositionChanged: checkerboardOverlayViewModel.updatePosition( 
                    puck.centerPoint.x/checkerboardOverlay.width, 
                    puck.centerPoint.y/checkerboardOverlay.height);
        }
    }
}
