import QtQuick 2.12
import QtQuick.Controls 2.12

import Theme 1.0

Rectangle {
    opacity: enabled ? 1 : 0.25
    width: Theme.margin(8)
    height: Theme.margin(8)
    radius: Theme.margin(1)

    property alias text: label.text
    property alias icon: image.source

    signal clicked()

    Label {
        id: label
        anchors { centerIn: parent }
        state: "h6"
    }

    Image {
        id: image
        anchors { centerIn: parent }
        sourceSize: Theme.iconSize
    }

    MouseArea {
        anchors { fill: parent }

        onClicked: parent.clicked()
    }
}
