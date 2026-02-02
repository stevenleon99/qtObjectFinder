import QtQuick 2.12
import Theme 1.0

Rectangle {
    opacity: 0.5
    x: position.x - radius
    y: position.y - radius
    width: scale * Theme.marginSize
    height: width
    radius: height / 2
    color: Theme.blue

    property bool is2d: false
    property real scale: 1
    property vector2d position
}