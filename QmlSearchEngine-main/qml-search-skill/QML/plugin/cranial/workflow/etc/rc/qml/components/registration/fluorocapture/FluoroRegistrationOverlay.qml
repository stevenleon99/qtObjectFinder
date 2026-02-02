import QtQuick 2.11

import Theme 1.0

Item {
    id: fluoroRegistrationOverlay

    property real xPad: 0
    property real yPad: 0
    property real imageScale: 1

    property alias orientationMarkers: orientationMrk.model
    property alias registrationMarkers: registrationMrk.model
    property alias gridMarkers: gridMrk.model

    function imageToScreen(pt) {
        var ptA = Qt.vector2d(pt.x,pt.y)
        return ptA.times(imageScale).plus(Qt.vector2d(xPad,yPad));
    }

    Repeater {
        id: orientationMrk

        FluoroRegistrationMarker {
            color: Theme.purple500
        }
    }

    Repeater {
        id: registrationMrk

        FluoroRegistrationMarker {
            color: Theme.blueLight500
        }
    }

    Repeater {
        id: gridMrk

        FluoroRegistrationMarker {
            color: Theme.teal500
            width: Theme.marginSize / 3
        }
    }
}
