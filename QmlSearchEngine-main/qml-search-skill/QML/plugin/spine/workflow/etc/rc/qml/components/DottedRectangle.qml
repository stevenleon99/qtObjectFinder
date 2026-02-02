import QtQuick 2.12
import QtQuick.Shapes 1.12

import Theme 1.0

Item {
    property bool solidBorder: false
    property alias borderColor: shapePath.strokeColor

    Shape {
        id: shape
        anchors { fill: parent }

        property int radius: 10

        ShapePath {
            id: shapePath
            strokeWidth: 2
            strokeColor: borderColor
            fillColor: Theme.transparent
            strokeStyle: solidBorder ? ShapePath.SolidLine : ShapePath.DashLine
            dashPattern: [4, 4]

            startX: shape.radius; startY: 0
            PathLine { x: shape.width - shape.radius; y: 0 } // top

            PathCubic { control1X: shape.width; control2X: shape.width; control1Y: 0; control2Y: 0; x: shape.width; y: shape.radius } // top right

            PathLine { x: shape.width; y: shape.height - shape.radius } // right

            PathCubic { control1X: shape.width; control2X: shape.width; control1Y: shape.height; control2Y: shape.height; x: shape.width - shape.radius; y: shape.height } // bottom right

            PathLine { x: shape.radius; y: shape.height } // bottom

            PathCubic { control1X: 0; control2X: 0; control1Y: shape.height; control2Y: shape.height; x: 0; y: shape.height - shape.radius } // bottom left

            PathLine { x: 0; y: shape.radius } //left

            PathCubic { control1X: 0; control2X: 0; control1Y: 0; control2Y: 0; x: shape.radius; y: 0 } // top left
        }
    }
}
