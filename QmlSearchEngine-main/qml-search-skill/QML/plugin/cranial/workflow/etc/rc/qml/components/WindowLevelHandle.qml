import QtQuick 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Rectangle {
    id: handle
    height: Theme.iconSize.height
    width: Theme.iconSize.width
    radius: width / 2
    color: handleMouseArea.pressed ? Theme.blue : Theme. white
    x: position
    y: parent.height / 2 - height / 2

    property alias dragging: handleMouseArea.pressed
    property alias iconSource: icon.source
    property alias iconRotation: icon.rotation
    property alias displayValue: control.text
    property real _startPosition: 0
    property real position: 0
    property real minimumValue: 0
    property real maximumValue: 0

    signal valueChanged(real value)
    signal dragFinished()
    signal dragStarted()
    
    IconImage {
        id: icon
        anchors {fill: parent}
        color: Theme.black
    }

    Label {
        id: control
        state: "subitle1"
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.top; bottomMargin: 8 }
        visible: text
        leftPadding: 8
        rightPadding: 8
        verticalAlignment: Text.AlignVCenter
        height: 25
        color: Theme.white
        background: Rectangle {
            radius: 5
            visible: control.enabled
            color: Theme.black
            opacity: 0.75
        }
    }

    MouseArea {
        id: handleMouseArea
        anchors { fill: handle }
        drag { 
            target: handle 
            axis: Drag.XAxis    
            threshold: 0
            minimumX: minimumValue
            maximumX: maximumValue > minimumValue ? maximumValue : minimumValue
        }

        onPressed: _startPosition = handle.x

        onPositionChanged: valueChanged(handle.x - _startPosition)

        onReleased: {
            handle.positionChanged(handle.position)
            dragFinished();
        }
    }
}