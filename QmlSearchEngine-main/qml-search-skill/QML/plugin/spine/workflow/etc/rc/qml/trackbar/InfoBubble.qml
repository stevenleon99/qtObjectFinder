import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

Popup {
    width: labelLayout.width
    height: Theme.margin(8)
    modal: false

    property alias text: label.text

    background: Rectangle { radius: 4; color: Theme.slate900 }

    function setup(positionItem) {
        var topRight = positionItem.mapToItem(null, positionItem.width, 0)
        x = topRight.x - width
        y =  topRight.y - height

        visible = true
    }

    RowLayout {
        id: labelLayout
        height: parent.height

        Label {
            id: label
            Layout.leftMargin: Theme.margin(2)
            Layout.rightMargin: Theme.margin(2)
            state: "body1"
        }
    }
}
