import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

import ViewModels 1.0
import Enums 1.0

Item {
    visible: renderer.scanList.length &&
             renderer.viewType === ImageViewport.ThreeD

    property var renderer

    anchors { fill: parent }

    RowLayout {
        anchors { right: parent.right; top: parent.top; topMargin: Theme.margin(1); rightMargin: Theme.margin(6) }
        spacing: Theme.margin(2)

        Rectangle {
            visible: viewType === ImageViewport.ThreeD
            Layout.preferredWidth: orientationPresetLayout.width
            Layout.preferredHeight: Theme.margin(5)
            radius: 4
            color: Theme.transparent
            border.color: Theme.white

            RowLayout {
                id: orientationPresetLayout
                anchors { centerIn: parent }
                spacing: 0


                Button {
                    objectName: "view3DAxialButton" 
                    state: "icon"
                    icon.source: "qrc:/icons/orientation/axial.svg"

                    onClicked: renderer.set3DOrientation(ImageViewport.Axial)
                }

                Button {
                    objectName: "view3DSagittalButton"  
                    state: "icon"
                    icon.source: "qrc:/icons/orientation/sagittal.svg"

                    onClicked: renderer.set3DOrientation(ImageViewport.Sagittal)
                }

                Button {
                    objectName: "view3DCoronalButton" 
                    state: "icon"
                    icon.source: "qrc:/icons/orientation/coronal.svg"

                    onClicked: renderer.set3DOrientation(ImageViewport.Coronal)
                }

            }
        }

        Button {
            objectName: "view3DRenderModeButton"  
            visible: viewType === ImageViewport.ThreeD
            state: "icon"
            icon.source: "qrc:/icons/photo-filter.svg"

            onClicked: renderer.toggleRenderType3D()
        }
    }
}
