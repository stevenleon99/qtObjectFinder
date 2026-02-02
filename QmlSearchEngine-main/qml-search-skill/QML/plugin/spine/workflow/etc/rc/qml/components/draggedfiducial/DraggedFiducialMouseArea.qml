import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

MouseArea {
    drag.threshold: 0

    readonly property point mappedPoint: mapToItem(spineQmlRoot, mouseX, mouseY)
    property var draggedFiducial: undefined
    property int fidIndex: -1

    signal fiducialPressed()

    function createDraggedFiducial() {
        var fiducialObject = fiducialComponent.createObject(
                    spineQmlRoot,
                    {
                        "locX": mappedPoint.x,
                        "locY": mappedPoint.y,
                        "fiducialIndex": fidIndex
                    })

        return fiducialObject
    }

    onClicked: fiducialPressed()

    onPositionChanged: {
        if (draggedFiducial) {
            draggedFiducial.locX = mappedPoint.x
            draggedFiducial.locY = mappedPoint.y
        } else {
            draggedFiducial = createDraggedFiducial()
        }
    }

    onReleased: {
        if (draggedFiducial) {
            draggedFiducial.Drag.drop()
            draggedFiducial.destroy()
        }
    }

    Component {
        id: fiducialComponent

        Fiducial {
            Drag.hotSpot: Qt.point(width / 2, height/2)
            Drag.active: true
            Drag.keys: ["draggedFiducial"]

            property int fiducialIndex: -1
        }
    }

    Component.onDestruction: {
        if (draggedFiducial) {
            draggedFiducial.destroy()
        }
    }
}
