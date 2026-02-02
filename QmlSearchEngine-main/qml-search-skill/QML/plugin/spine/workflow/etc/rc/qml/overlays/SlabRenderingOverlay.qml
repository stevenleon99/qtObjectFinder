import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

import ViewModels 1.0
import Enums 1.0

import "../components"

Item {
    visible: renderer.scanList.length &&
             slabRenderingOverlayVM.slabRenderingVisible

    property var renderer

    anchors { fill: parent }

    SlabRenderingOverlayViewModel {
        id: slabRenderingOverlayVM
        viewport: renderer
    }

    RowLayout {
        anchors { right: parent.right; top: parent.top; topMargin: Theme.margin(1); rightMargin: Theme.margin(1) }
        spacing: Theme.margin(2)

        Button {
            state: "icon"
            icon.source: "qrc:/icons/mesh-overlay.svg"
            highlighted: slabRenderingOverlayVM.meshVisibilityEnabled
            visible: slabRenderingOverlayVM.xrEnabled
            enabled: slabRenderingOverlayVM.meshAvailable
            onClicked: slabRenderingOverlayVM.toggleMeshVisbility()
        }

        IconButton {
            id: slabDecrement 
            objectName: "slabDecrementButton"  
            visible: slab.active && slabRenderingOverlayVM.slabThicknessChangeVisible
            enabled: slabRenderingOverlayVM.decrementSlabThicknessEnabled
            icon.source: "qrc:/icons/minus.svg"
            color: Theme.white

            onClicked: slabRenderingOverlayVM.decrementSlabThickness()
        }

        IconButton { 
            objectName: "slabIncrementButton"  
            visible: slab.active && slabRenderingOverlayVM.slabThicknessChangeVisible
            enabled: slabRenderingOverlayVM.incrementSlabThicknessEnabled
            icon.source: "qrc:/icons/plus.svg"
            color: Theme.white

            onClicked: slabRenderingOverlayVM.incrementSlabThickness()
        }

        IconButton {
            id: slab
            objectName: "slabButton"
            icon.source: "qrc:/icons/layers.svg"
            color: Theme.white
            active: slabRenderingOverlayVM.slabRenderingEnabled

            onClicked: slabRenderingOverlayVM.toggleSlabRendering()
        }
    }
}
