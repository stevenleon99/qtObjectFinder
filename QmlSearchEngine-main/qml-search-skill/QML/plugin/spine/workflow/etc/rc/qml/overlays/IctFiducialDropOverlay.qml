import QtQuick 2.12
import ViewModels 1.0

import Theme 1.0


Item {
    visible: renderer.scanList.length

    property var renderer

    IctFiducialDropOverlayViewModel {
        id: ictFiducialDropOverlayViewModel
        viewport: renderer
    }

    DropArea {
        anchors { fill: parent }
        keys: ["draggedFiducial"]

        onEntered: ictFiducialDropOverlayViewModel.setViewMmPerPixel()

        onDropped: {
            ictFiducialDropOverlayViewModel.dropFiducial(drag.source.fiducialIndex, Qt.vector2d(drop.x, drop.y))
        }
    }
}
