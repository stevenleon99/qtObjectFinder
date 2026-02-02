import QtQuick 2.12

import Theme 1.0
import ViewModels 1.0
import QtQuick.Controls 2.12

Canvas {
    visible: measurementOverlayViewModel.isOverlayVisible &&
             renderer.scanList.length &&
             renderer.viewType !== ImageViewport.ThreeD
    
    property var renderer

    onRendererChanged: measurementOverlayViewModel.setViewport(renderer)

    property bool _autoRepeat: true
    property int _autoRepeatDelay: 250
    property int _autoRepeatInterval: 10

    onAvailableChanged: requestPaint()

    onWidthChanged: requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        ctx.lineWidth = 2
        ctx.strokeStyle = Theme.yellow

        ctx.beginPath()
        ctx.moveTo(measurementOverlayViewModel.startPoint.x, measurementOverlayViewModel.startPoint.y)
        ctx.lineTo(measurementOverlayViewModel.endPoint.x, measurementOverlayViewModel.endPoint.y)
        ctx.stroke()
    }

    MeasurementOverlayViewModel {
        id: measurementOverlayViewModel

        onStartPointChanged: requestPaint()
        onEndPointChanged: requestPaint()
    }

    Rectangle {
        objectName: "MeasurementRectAtStart"
        x: measurementOverlayViewModel.startPoint.x - radius
        y: measurementOverlayViewModel.startPoint.y - radius
        width: Theme.margin(12)
        height: width
        radius: width / 2
        border { width: 2; color: Theme.blue }
        color: Theme.transparent

        Rectangle {
            width: Theme.margin(1)
            height: width
            radius: width / 2
            anchors { centerIn: parent }
            color: Theme.yellow
        }

        MouseArea {
            anchors { fill: parent }
            drag { target: parent; axis: Drag.XAndYAxis; threshold: 0;
                minimumX: 0; maximumX: parent.parent.width - parent.width;
                minimumY: 0; maximumY: parent.parent.height - parent.height }

            onPositionChanged: measurementOverlayViewModel.startPoint = Qt.vector2d(parent.x + parent.radius, parent.y + parent.radius)
        }

        Button {
            objectName: "leftStartButton"
            id: shiftButton
            visible: measurementOverlayViewModel.leftStartButtonVisible
            anchors { right: parent.left; verticalCenter: parent.verticalCenter }
            state: "icon"
            icon.source: "qrc:/icons/arrow.svg"
            autoRepeat: _autoRepeat
            autoRepeatDelay: _autoRepeatDelay
            autoRepeatInterval: _autoRepeatInterval
            color: Theme.blue

            onClicked: measurementOverlayViewModel.shiftLeftStartPoint()
        }

        Button {
            objectName: "rightStartButton"
            visible: measurementOverlayViewModel.rightStartButtonVisible
            anchors { left: parent.right; verticalCenter: parent.verticalCenter }
            state: "icon"
            rotation: 180
            icon.source: "qrc:/icons/arrow.svg"
            autoRepeat: _autoRepeat
            autoRepeatDelay: _autoRepeatDelay
            autoRepeatInterval: _autoRepeatInterval
            color: Theme.blue


            onClicked: measurementOverlayViewModel.shiftRightStartPoint()
        }

        Button {
            objectName: "upStartButton"
            visible: measurementOverlayViewModel.upStartButtonVisible
            anchors { bottom: parent.top; horizontalCenter: parent.horizontalCenter }
            state: "icon"
            rotation: 90
            icon.source: "qrc:/icons/arrow.svg"
            autoRepeat: _autoRepeat
            autoRepeatDelay: _autoRepeatDelay
            autoRepeatInterval: _autoRepeatInterval
            color: Theme.blue

            onClicked: measurementOverlayViewModel.shiftUpStartPoint()
        }

        Button {
            objectName: "downStartButton"
            visible: measurementOverlayViewModel.downStartButtonVisible
            anchors { top: parent.bottom; horizontalCenter: parent.horizontalCenter }
            state: "icon"
            rotation: -90
            icon.source: "qrc:/icons/arrow.svg"
            autoRepeat: _autoRepeat
            autoRepeatDelay: _autoRepeatDelay
            autoRepeatInterval: _autoRepeatInterval
            color: Theme.blue

            onClicked: measurementOverlayViewModel.shiftDownStartPoint()
        }
    }

    Rectangle {
        objectName: "MeasurementRectAtEnd"
        x: measurementOverlayViewModel.endPoint.x - radius
        y: measurementOverlayViewModel.endPoint.y - radius
        width: Theme.margin(12)
        height: width
        radius: width / 2
        border { width: 2; color: Theme.blue }
        color: Theme.transparent

        Rectangle {
            width: Theme.margin(1)
            height: width
            radius: width / 2
            anchors { centerIn: parent }
            color: Theme.yellow
        }

        MouseArea {
            anchors { fill: parent }
            drag { target: parent; axis: Drag.XAndYAxis; threshold: 0;
                minimumX: 0; maximumX: parent.parent.width - parent.width;
                minimumY: 0; maximumY: parent.parent.height - parent.height }

            onPositionChanged: measurementOverlayViewModel.endPoint = Qt.vector2d(parent.x + parent.radius, parent.y + parent.radius)
        }

        Button {
            objectName: "leftEndButton"
            visible: measurementOverlayViewModel.leftEndButtonVisible
            anchors { right: parent.left; verticalCenter: parent.verticalCenter }
            state: "icon"
            icon.source: "qrc:/icons/arrow.svg"
            autoRepeat: _autoRepeat
            autoRepeatDelay: _autoRepeatDelay
            autoRepeatInterval: _autoRepeatInterval
            color: Theme.blue

            onClicked: measurementOverlayViewModel.shiftLeftEndPoint()
        }

        Button {
            objectName: "rightEndButton"
            visible: measurementOverlayViewModel.rightEndButtonVisible
            anchors { left: parent.right; verticalCenter: parent.verticalCenter }
            state: "icon"
            rotation: 180
            icon.source: "qrc:/icons/arrow.svg"
            autoRepeat: _autoRepeat
            autoRepeatDelay: _autoRepeatDelay
            autoRepeatInterval: _autoRepeatInterval
            color: Theme.blue

            onClicked: measurementOverlayViewModel.shiftRightEndPoint()
        }

        Button {
            objectName: "upEndButton"
            visible: measurementOverlayViewModel.upEndButtonVisible
            anchors { bottom: parent.top; horizontalCenter: parent.horizontalCenter }
            state: "icon"
            rotation: 90
            icon.source: "qrc:/icons/arrow.svg"
            autoRepeat: _autoRepeat
            autoRepeatDelay: _autoRepeatDelay
            autoRepeatInterval: _autoRepeatInterval
            color: Theme.blue

            onClicked: measurementOverlayViewModel.shiftUpEndPoint()
        }

        Button {
            objectName: "downEndButton"
            visible: measurementOverlayViewModel.downEndButtonVisible
            anchors { top: parent.bottom; horizontalCenter: parent.horizontalCenter }
            state: "icon"
            rotation: -90
            icon.source: "qrc:/icons/arrow.svg"
            autoRepeat: _autoRepeat
            autoRepeatDelay: _autoRepeatDelay
            autoRepeatInterval: _autoRepeatInterval
            color: Theme.blue

            onClicked: measurementOverlayViewModel.shiftDownEndPoint()
        }
    }

    Rectangle {
        objectName: "MeasurementDistanceLabel"
        x: midPoint.x - (invertX * direction.y) - width/2
        y: midPoint.y + (invertY * direction.x) - height/2
        width: distanceLabel.implicitWidth + Theme.margin(2)
        height: distanceLabel.implicitHeight + Theme.margin(2)
        radius: 4
        opacity: 0.75
        color: Theme.black

        property vector2d midPoint: measurementOverlayViewModel.startPoint.plus(measurementOverlayViewModel.endPoint).times(0.5)
        property vector2d direction: measurementOverlayViewModel.endPoint.minus(measurementOverlayViewModel.startPoint).normalized().times(distanceLabel.implicitHeight * 3)
        property real invert: direction.x <= 0 ? 1.0: -1.0
        property real labelX: midPoint.x - (invert * direction.y) - width/2
        property real labelY: midPoint.y + (invert * direction.x) - height/2
        property real invertX: labelX < 0 || labelX + width > parent.width ? -invert : invert 
        property real invertY: labelY < 0 ? -invert : invert 

        Label {
            id: distanceLabel
            anchors.centerIn: parent
            state: 'subtitle2'
            text: measurementOverlayViewModel.distanceMM.toFixed(2) + "mm"
        }
    }
}
