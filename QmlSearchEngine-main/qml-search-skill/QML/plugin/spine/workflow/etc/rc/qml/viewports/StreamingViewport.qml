import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import ".."
import "../overlays"

ImageViewport {
    id: viewport
    streamingViewport: true

    property var backgroundComponent: null
    
    Rectangle {
        anchors { fill: parent }
        color: Theme.black
        visible: !viewport.scanList.length
    }

    OrientationOverlay {
        objectName: "orientationOverlay_" + viewportUid 
        anchors { fill: parent }
        renderer: viewport
    }
    TrackingCrosshairOverlay {
        anchors { fill: parent }
        renderer: viewport
    }
}
