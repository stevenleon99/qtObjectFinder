import QtQuick 2.12
import QtQuick.Controls 2.12

Popup {
    id: flash

    width: parent.width
    height: parent.height
    modal: false
    enter: null
    exit: null
    background: Rectangle {}

    NumberAnimation on opacity {
        running: flash.visible
        from: 0.5
        to: 0
        duration: 250
        onStopped: flash.visible = false
    }
}
