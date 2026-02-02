import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

Item {
    id: rotation2dOverlay
    visible: rotation2dOVM.display

    property var renderer

    Rotation2dOverlayViewModel {
        id: rotation2dOVM
        viewport: renderer
    }
    
        Button {
            visible: rotation2dOVM.isRotated
            x: (parent.width / 2) - (width / 2) - 100
            y: 0
            id: resetId
            state: "icon"
            icon.source: "qrc:/icons/reset.svg"

            onClicked: rotation2dOVM.restartRotation()
        }

    Button {
        x: (parent.width / 2) - (width / 2) - 40
        y: 0
        state: "icon"
        icon.source: "qrc:/images/rotate-around-increment.svg"
        transform: [
            Rotation { origin.x: 24; origin.y: 24; axis { x: 0; y: 0; z: 1 } angle: -90 }
        ]

        autoRepeat: true
        autoRepeatDelay: 250
        autoRepeatInterval: 10

        onClicked: {
            rotation2dOVM.rotateCounterClockwise();
        }
    }

    Button {
        x: (parent.width / 2) - (width / 2) + 40
        y: 0
        state: "icon"
        icon.source: "qrc:/images/rotate-around-increment.svg"
        transform: [
            Rotation { origin.x: 24; origin.y: 24; axis { x: 0; y: 0; z: 1 } angle: -90 },
            Rotation { origin.x: 24; origin.y: 24; axis { x: 0; y: 1; z: 0 } angle: 180 }
        ]

        autoRepeat: true
        autoRepeatDelay: 250
        autoRepeatInterval: 10

        onClicked: {
            rotation2dOVM.rotateClockwise();
        }
    }


    
}
