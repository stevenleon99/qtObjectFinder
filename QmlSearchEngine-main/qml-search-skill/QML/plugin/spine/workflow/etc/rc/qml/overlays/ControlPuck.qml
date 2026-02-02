import QtQuick 2.12
import QtQuick.Controls 2.12

import Theme 1.0

Rectangle {
    x: (parent.width / 2) - (width / 2)
    y: (parent.height / 2) - (height / 2)
    width: height
    height: 98
    radius: width/2
    border { width: 2; color: Theme.blue }
    color: 'transparent'

    property point centerPoint: Qt.point(x + width / 2, y + height / 2)

    signal pressed()
    signal positionChanged()
    signal released()

    signal shiftLeftClicked()
    signal shiftRightClicked()
    signal shiftUpClicked()
    signal shiftDownClicked()

    Rectangle {
        height: parent.border.width * 2
        width: height
        radius: width / 2
        anchors { centerIn: parent }
        color: Theme.blue
    }

    Rectangle {
        height: (parent.width + parent.border.width) / 4
        width: parent.border.width
        anchors { horizontalCenter: parent.horizontalCenter; top: parent.top }
        color: Theme.blue
    }

    Rectangle {
        height: (parent.width + parent.border.width) / 4
        width: parent.border.width
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
        color: Theme.blue
    }

    Rectangle {
        width: (parent.width + parent.border.width) / 4
        height: parent.border.width
        anchors { verticalCenter: parent.verticalCenter; left: parent.left }
        color: Theme.blue
    }

    Rectangle {
        width: (parent.width + parent.border.width) / 4
        height: parent.border.width
        anchors { verticalCenter: parent.verticalCenter; right: parent.right }
        color: Theme.blue
    }

    Button {
        id: shiftButton
        anchors { right: parent.left; verticalCenter: parent.verticalCenter }
        state: "icon"
        color: Theme.blue
        icon.source: "qrc:/icons/arrow.svg"
        autoRepeat: true
        autoRepeatDelay: 250
        autoRepeatInterval: 10

        onClicked: shiftLeftClicked()
    }

    Button {
        anchors { left: parent.right; verticalCenter: parent.verticalCenter }
        state: "icon"
        rotation: 180
        color: Theme.blue
        icon.source: "qrc:/icons/arrow.svg"
        autoRepeat: shiftButton.autoRepeat
        autoRepeatDelay: shiftButton.autoRepeatDelay
        autoRepeatInterval: shiftButton.autoRepeatInterval

        onClicked: shiftRightClicked()
    }

    Button {
        anchors { bottom: parent.top; horizontalCenter: parent.horizontalCenter }
        state: "icon"
        rotation: 90
        color: Theme.blue
        icon.source: "qrc:/icons/arrow.svg"
        autoRepeat: shiftButton.autoRepeat
        autoRepeatDelay: shiftButton.autoRepeatDelay
        autoRepeatInterval: shiftButton.autoRepeatInterval

        onClicked: shiftUpClicked()
    }

    Button {
        anchors { top: parent.bottom; horizontalCenter: parent.horizontalCenter }
        state: "icon"
        rotation: -90
        color: Theme.blue
        icon.source: "qrc:/icons/arrow.svg"
        autoRepeat: shiftButton.autoRepeat
        autoRepeatDelay: shiftButton.autoRepeatDelay
        autoRepeatInterval: shiftButton.autoRepeatInterval

        onClicked: shiftDownClicked()
    }

    MouseArea {
        anchors { fill: parent }
        drag { target: parent; axis: Drag.XAndYAxis; threshold: 0;
            minimumX: 0; maximumX: parent.parent.width - parent.width;
            minimumY: 0; maximumY: parent.parent.height - parent.height }

        onPressed: parent.pressed()

        onPositionChanged: parent.positionChanged()

        onReleased: parent.released()
    }
}


