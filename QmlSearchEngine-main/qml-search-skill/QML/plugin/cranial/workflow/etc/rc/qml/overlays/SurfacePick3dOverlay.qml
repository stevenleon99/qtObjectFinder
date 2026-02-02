import QtQuick 2.12
import ViewModels 1.0

import Theme 1.0

Item {
    visible: renderer.viewType == ImageViewport.ThreeD

    property var renderer

    SurfacePick3dOverlayViewModel {
        id: surfacePick3dOverlayViewModel
        viewport: renderer
    }

    MouseArea {
            anchors.fill: parent
            //preventStealing: false
            //propagateComposedEvents: true

            onPressed: {
                surfacePick3dOverlayViewModel.setScreenPosition(Qt.vector2d(mouse.x,mouse.y));
                mouse.accepted = false;
            }
        }
}


