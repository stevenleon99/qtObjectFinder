import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import GmQml 1.0
import Theme 1.0

Popup {
    width: contentLoader.width
    height: contentLoader.height
    dim: false

    property alias content: contentLoader.sourceComponent

    background: Rectangle { radius: 8; color: Theme.slate900 }

    function setup(positionItem) {
        var position = positionItem.mapToItem(null, 0, 0)
        var newX = position.x - (width - positionItem.width)
        var newY = position.y + positionItem.height + Theme.margin(1)

        x = newX
        y = newY

        visible = true;
    }

    Rectangle {
        z: 1000
        y: - height / 2
        x: parent.width - (width + Theme.margin(2))
        width: Theme.margin(2)
        height: width
        rotation: 45
        color: Theme.slate900
    }

    Button {
        anchors.right: parent.right
        icon.source: "qrc:/images/x.svg"
        state: "icon"

        onClicked: close()
    }

    Loader {
        id: contentLoader
        visible: sourceComponent
    }
}
