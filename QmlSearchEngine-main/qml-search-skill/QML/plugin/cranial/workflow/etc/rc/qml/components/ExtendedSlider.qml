import QtQuick 2.12

import Theme 1.0

// This component is a Slider similar to the built in QML Slider except it has both
// "inner" and "outer" minimum and maxium values.
// If outerMin and innerMin are both set to the "from" value
// and innerMax and outerMax are both set to the "to" value,
// this slider will work just the same as the built in Slider.
// The additional ability provided here is to provide outerMin that is less than the
// innerMin and outerMax that is greater than the innerMax. These areas will be visible
// along the slider in a different color. The handle will extend out to those areas if
// the value dictates, but the click and drag interaction of the handle will be limited
// to the "inner" range.
// Behavior is undefined if outerMin > innerMin, innerMin > innerMax, or innerMax > outerMax.
Item {
    id: extendedSlider
    height: 32

    property real outerMin: 0
    property real innerMin: 0
    property real innerMax: 0
    property real outerMax: 0

    property real value: 0
    property bool active: false
    property bool handleActive: false

    property real position: Math.max(Math.min((value - outerMin) / (outerMax - outerMin), 1), 0)

    signal valueChangeRequested(real newValue)

    property real _rangeWidth: extendedSlider.width - handle.width
    property real _outerMinWidth: _rangeWidth * (innerMin - outerMin) / (outerMax - outerMin) + handle.width / 2
    property real _outerMaxWidth: _rangeWidth * (outerMax - innerMax) / (outerMax - outerMin) + handle.width / 2

    Rectangle {
        id: outerMinRange
        height: 4
        width: extendedSlider._outerMinWidth
        anchors { left: extendedSlider.left; verticalCenter: extendedSlider.verticalCenter; }
        color: extendedSlider.active ? Theme.lineColor: Theme.slate300
    }

    Rectangle {
        id: innerRange
        height: 4
        anchors { left: outerMinRange.right; right: outerMaxRange.left; verticalCenter: extendedSlider.verticalCenter; }
        color: extendedSlider.active ? Theme.navyLight : Theme.slate300
    }

    Rectangle {
        id: outerMaxRange
        height: 4
        width: extendedSlider._outerMaxWidth
        anchors { right: extendedSlider.right; verticalCenter: extendedSlider.verticalCenter; }
        color: extendedSlider.active ? Theme.lineColor: Theme.slate300
    }

    // Fill bar
    Rectangle {
        height: 4
        anchors { left: outerMinRange.right; right: handle.horizontalCenter; verticalCenter: extendedSlider.verticalCenter; }
        color: extendedSlider.active ? Theme.white : Theme.slate300
    }

    // Negative fill bar
    Rectangle {
        height: 4
        anchors { left: handle.horizontalCenter; right: outerMinRange.right; verticalCenter: extendedSlider.verticalCenter; }
        color: extendedSlider.active ? Theme.red : Theme.slate300
    }

    Rectangle {
        id: handle
        height: 32
        width: height
        radius: width / 2

        color: {
            if (handleMouseArea.pressed) { Theme.blue }
            else if (extendedSlider.active || extendedSlider.handleActive) { Theme. white }
            else { Theme.slate300 }
        }

        y: extendedSlider.height / 2 - height / 2
        x: extendedSlider.position * (extendedSlider.width - width)

        MouseArea {
            id: handleMouseArea
            anchors { fill: handle }
            drag { target: handle; axis: Drag.XAxis; threshold: 0;
                   minimumX: extendedSlider._outerMinWidth - handle.width / 2;
                   maximumX: extendedSlider.width - extendedSlider._outerMaxWidth - handle.width / 2; }

            onPositionChanged: {
                var newPos = handle.x / (extendedSlider.width - handle.width);
                valueChangeRequested(outerMin + newPos * (outerMax - outerMin));
            }

            onReleased: {                
                // Reset the handle position in case the value change request was denied
                extendedSlider.positionChanged(extendedSlider.position)
            }
        }
    }
}

