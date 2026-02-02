import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import GmQml 1.0
import Theme 1.0

import ViewModels 1.0

import "../instrumentverification"

Popup {
    width: control.width
    height: control.height
    dim: false

    background: Rectangle { radius: 8; color: Theme.slate800 }

    function setup(positionItem) {
        var position = positionItem.mapToItem(null, 0, 0)
        var newX = position.x
        var newY = position.y - (height + Theme.margin(1))

        x = newX
        y = newY

        visible = true;
    }

    Rectangle {
        y: parent.height - height / 2
        x: Theme.margin(2)
        width: Theme.margin(2)
        height: width
        rotation: 45
        color: Theme.slate800
    }

    ColumnLayout {
        id: control
        spacing: 0

        Layout.preferredWidth: Theme.margin(45)

        InstrumentVerification {
            id: instrumentVerification
            width: 360
            height: 400
            switchOption:false
            toolOption: false
        }
    }
}
