import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Rectangle {
    opacity: enabled ? 1 : 0.25
    width: Theme.margin(8)
    height: Theme.margin(8)
    radius: Theme.margin(1)
    border.color: mouseArea.pressed ? Theme.blue : borderColor

    property alias text: label.text
    property alias icon: image.source
    property color borderColor: Theme.transparent
    property color pressedColor: Theme.blue

    signal clicked()

    Label {
        id: label
        anchors { centerIn: parent }
        state: "h6"
        color: mouseArea.pressed ? pressedColor : borderColor
    }

    IconImage {
        id: image
        anchors { centerIn: parent }
        sourceSize: Theme.iconSize
        color: mouseArea.pressed ? pressedColor : borderColor
    }

    MouseArea {
        id: mouseArea
        anchors { fill: parent }

        onClicked: parent.clicked()
    }
}
