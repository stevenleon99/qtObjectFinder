import QtQuick 2.12

import Theme 1.0

Item {
    id: windowLevelSlider
    implicitHeight: leftHandle.width

    property real minValue: 0
    property real maxValue: 1
    property bool dragging: leftHandle.dragging || rightHandle.dragging || centerHandle.dragging

    signal minShift(real shift);
    signal maxShift(real shift);
    signal minMaxShift(real shift);

    property real _sliderWidth: width - leftHandle.width
    property real _posLeftHandle:  _sliderWidth * 0.25 
    property real _posRightHandle: _sliderWidth * 0.75

    Rectangle {
        height: 4
        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter; leftMargin: leftHandle.width/2; rightMargin: leftHandle.width/2 }
        color: Theme.white
        opacity: .25
    }

    Rectangle {
        height: 4
        anchors { left: leftHandle.right; right: rightHandle.left; verticalCenter: parent.verticalCenter; }
        color: Theme.white
    }

    WindowLevelHandle {
        id: leftHandle
        iconSource: "qrc:/images/arrow-end.svg"
        iconRotation: 180
        minimumValue: 0;
        maximumValue: _posRightHandle - 2.0 * leftHandle.width;
        displayValue: Math.round(minValue)
        position: _posLeftHandle

        onValueChanged: minShift(value/_sliderWidth)
    }

    WindowLevelHandle {
        id: rightHandle
        iconSource: "qrc:/images/arrow-end.svg"
        minimumValue: _posLeftHandle + 2.0 * leftHandle.width
        maximumValue: _sliderWidth
        displayValue: Math.round(maxValue)
        position: _posRightHandle

        onValueChanged: maxShift(value/_sliderWidth)
    }

    WindowLevelHandle {
        id: centerHandle
        iconSource: "qrc:/images/arrow-mid-point.svg"
        minimumValue: _sliderWidth / 2 - _posLeftHandle
        maximumValue: _sliderWidth / 2 + _posLeftHandle
        position: (leftHandle.x + rightHandle.x)/2

        onValueChanged: {
            leftHandle.position = centerHandle.x - _posLeftHandle
            rightHandle.position = centerHandle.x + _posLeftHandle
            minMaxShift(value/_sliderWidth)
        }

        onDragFinished: {
            leftHandle.position = _posLeftHandle
            rightHandle.position = _posRightHandle
        }
    }
}
