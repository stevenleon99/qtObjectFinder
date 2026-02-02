import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

import ViewModels 1.0
import Enums 1.0

Item {
    visible: renderer.scanList.length

    property var renderer

    anchors { fill: parent }

    CadDropAreaOverlayViewModel {
        id: cadDropAreaOverlayViewModel
        viewport: renderer
    }

    DropArea {
        anchors { fill: parent }
        keys: ["draggedCad"]

        onEntered: cadDropAreaOverlayViewModel.setDragActiveViewportProperties()

        onDropped: cadDropAreaOverlayViewModel.dropCad(drag.source.implantId, drop.x, drop.y)
    }
}


