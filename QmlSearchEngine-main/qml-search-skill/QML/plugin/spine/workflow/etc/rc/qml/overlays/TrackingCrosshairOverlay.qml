import QtQuick 2.12
import ViewModels 1.0
import QtQuick.Controls.impl 2.15
import QtGraphicalEffects 1.15

import Theme 1.0


Item {
    visible: trackingCrosshairOverlayViewModel.display &&
             renderer.viewType !== ImageViewport.ThreeD

    opacity: 0.75
    clip: true

    property var renderer

    TrackingCrosshairOverlayViewModel {
        id: trackingCrosshairOverlayViewModel
        viewport: renderer
    }

    property vector2d position: trackingCrosshairOverlayViewModel.position

    //property double crosshairScale: preferenceManager.preferenceMap["crosshairScale"] ? preferenceManager.preferenceMap["crosshairScale"] : 1.0
    //property color crosshairColor: preferenceManager.preferenceMap["crosshairColor"] ? preferenceManager.preferenceMap["crosshairColor"] : Theme.white
    property double crosshairScale:  1.0
    property color crosshairColor: Theme.lineColor

    IconImage {
        id: crosshair
        x: position.x - (width / 2)
        y: position.y - (height / 2)
        scale: Math.floor(crosshairScale)
        antialiasing: false
        smooth: false
        color: crosshairColor
        opacity: trackingCrosshairOverlayViewModel.opacity
        source: "qrc:/images/crosshair.png"
    }

    Glow {
        scale: crosshairScale
        radius: 3
        anchors { fill: crosshair }
        antialiasing: false
        smooth: false
        source: crosshair
        color: "black"
        opacity: trackingCrosshairOverlayViewModel.opacity
        samples: 7
        spread: 0.8
    }

}


