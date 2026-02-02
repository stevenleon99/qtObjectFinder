import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Scene3D 2.0

import ViewModels 1.0
import Enums 1.0

Loader {
    visible: draggedCadVM.active
    anchors { fill: parent }

    readonly property int offset: -75
    readonly property point cadHotSpot: Qt.point(locX, locY + offset)

    readonly property alias implantId: draggedCadVM.implantId

    property double locX: 0
    property double locY: 0

    DraggedCadViewModel {
        id: draggedCadVM
    }

    sourceComponent: Component {
        Scene3D {
            id: scene3D
            x: locX - (width / 2)
            y: locY - (height / 2) + offset
            width: 4096
            height: width
            cameraAspectRatioMode: Scene3D.AutomaticAspectRatio

            DraggedCadEntity {
                source: draggedCadVM.source
                color: draggedCadVM.color
                orientation: draggedCadVM.orientation
                scale: (1 / draggedCadVM.mmPerPixel) / scene3D.width
            }
        }
    }
}
