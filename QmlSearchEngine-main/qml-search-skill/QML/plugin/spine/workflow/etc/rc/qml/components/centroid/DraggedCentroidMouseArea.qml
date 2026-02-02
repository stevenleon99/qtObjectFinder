import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

MouseArea {
    id: mouseArea
    drag.threshold: 0

    property var draggedCentroid: undefined

    property string anatomy
    property bool dragEnabled
    property string anatomyName

    readonly property point mapped: mapToItem(spineQmlRoot, mouseX, mouseY)

    function createDraggedCentroid() {
        var centroidObject = centroidComponent.createObject(
                    spineQmlRoot,
                    {
                        "anatomy": mouseArea.anatomy,
                        "text": mouseArea.anatomyName,
                        "locX": mapped.x,
                        "locY": mapped.y
                    })

        return centroidObject
    }

    onPositionChanged: {
        if (draggedCentroid) {
            draggedCentroid.locX = mapped.x
            draggedCentroid.locY = mapped.y
        } else {
            if (dragEnabled){
                draggedCentroid = createDraggedCentroid()
            }
        }
    }

    onReleased: {
        if (draggedCentroid)
        {
            draggedCentroid.Drag.drop()
            draggedCentroid.destroy()
        }
    }

    Component {
        id: centroidComponent

        Centroid {
            id: ce
            Drag.hotSpot: Qt.point(width / 2, height/2)
            Drag.active: true
            Drag.keys: ["centroid"]
            color: Theme.green

            property string anatomy
        }
    }

    Component.onDestruction: {
        if (draggedCentroid) {
            draggedCentroid.destroy()
        }
    }
}
