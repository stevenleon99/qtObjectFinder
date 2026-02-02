import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

import ".."

ImageViewport {
    id: renderer

    signal expandClicked()

    onViewTypeChanged: {

        overlayViewModel.refreshOverlays()
    }

//    Rectangle {
//        anchors { fill: parent }
//        color: Theme.black
//        visible: !renderer.scanList.length
//    }

//    DescriptiveBackground {
//        visible: !renderer.scanList.length
//        icon: "qrc:/icons/image-add.svg"
//        title: qsTr("No Image Selected")
//        description: qsTr("Select an imported image.")
//    }

    Repeater {
        model: overlayViewModel

        delegate: Loader {
            z: index
            anchors { fill: parent }
            source: role_overlaySource

            onLoaded: item.renderer = renderer
        }
    }

    RowLayout {
        anchors { right: parent.right }

        Button {
            visible: viewType === ImageViewport.ThreeD
            state: "icon"
            icon.source: "qrc:/icons/photo-filter.svg"

            onClicked: toggleRenderType3D()
        }

        Button {
            visible: viewType !== ImageViewport.FluoroImage
            state: "icon"
            icon.source: "qrc:/icons/expand.svg"

            onClicked: toggleExpand()
        }
    }
}
