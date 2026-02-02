import QtQuick 2.11

import Theme 1.0

Rectangle {
    opacity: 0.75
    x: position.x - radius
    y: position.y - radius
    width: Theme.marginSize
    height: width
    radius: height / 2
    color: Theme.blue

    property vector2d position : fluoroRegistrationOverlay.imageToScreen(modelData)
}
