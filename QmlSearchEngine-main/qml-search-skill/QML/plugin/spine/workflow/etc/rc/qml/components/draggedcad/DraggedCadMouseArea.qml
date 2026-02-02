import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

MouseArea {
    drag.threshold: 0

    property bool dragEnabled: false
    property var draggedCad: undefined

    signal trajectoryPressed ()
    signal startDrag()
    signal endDrag()

    function createDraggedCad() {
        var mappedPoint = mapToItem(spineQmlRoot, mouseX, mouseY)
        var cadObject = cadComponent.createObject(
                    spineQmlRoot,
                    {
                        "locX": mappedPoint.x,
                        "locY": mappedPoint.y
                    })

        return cadObject
    }

    onClicked: trajectoryPressed()

    onPressed: {
        if (pressed) {
            if (dragEnabled && !draggedCad) {
                draggedCad = createDraggedCad()
            }
        }
    }

    onPositionChanged: {
        if (!dragEnabled)
            return

        if (draggedCad.visible) {
            var mappedPoint = mapToItem(spineQmlRoot, mouseX, mouseY)
            draggedCad.locX = mappedPoint.x
            draggedCad.locY = mappedPoint.y

        } else {
            startDrag()
        }
    }

    onReleased: {
        if (draggedCad) {
            if (draggedCad.visible) {
                draggedCad.Drag.drop()
                endDrag()
            }
            draggedCad.destroy()
        }
    }

    Component {
        id: cadComponent

        DraggedCadScene {
            Drag.hotSpot: cadHotSpot
            Drag.active: true
            Drag.keys: ["draggedCad"]
        }
    }

    Component.onDestruction: {
        if (draggedCad) {
            draggedCad.destroy()
        }
    }
}
