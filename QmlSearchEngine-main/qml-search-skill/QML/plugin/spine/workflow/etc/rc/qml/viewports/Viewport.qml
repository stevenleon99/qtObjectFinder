import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0

import ".."

ImageViewport {
    id: renderer

    property var backgroundComponent: null
    
    signal expandClicked()

    Rectangle {
        anchors { fill: parent }
        color: Theme.black
        visible: !renderer.scanList.length
    }

    // Additonal background Component
    // Can be used to inject an overlay into a specific instance of a viewport.
    Loader {
        z: 0
        anchors { fill: parent }
        sourceComponent: backgroundComponent 
        onLoaded: {
            item.renderer = renderer
        }
    }

    Repeater {
        model: overlayViewModel     

        delegate: Loader {
            z: index + 1
            anchors { fill: parent }
            source: role_overlaySource 

            onLoaded: item.renderer = renderer
        }        
    }
    
    Button {
        objectName: "expand3DViewportButton" 
        visible: viewType === ImageViewport.ThreeD
        anchors { right: parent.right; top: parent.top; topMargin: Theme.margin(1) }
        state: "icon"
        icon.source: "qrc:/icons/expand.svg"

        onClicked: toggleExpand()
    }
}
