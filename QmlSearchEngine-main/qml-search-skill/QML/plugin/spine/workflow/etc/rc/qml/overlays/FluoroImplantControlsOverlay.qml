import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import "../components"

Canvas {
    id: canvas
    visible: fluoroImplantControlsOVM.isEnabled

    anchors { fill: parent }
    clip: true

    property var renderer

    FluoroImplantControlsOverlayViewModel {
        id: fluoroImplantControlsOVM
        viewport: renderer
    }

    property vector2d handleTip
    property vector2d handleHead
    property real handleRotation
    property vector2d shaftDirection: Qt.vector2d(0,0)
    property real fineIncrement: 2.0

    onPaint: {
        var context = getContext("2d")
        context.clearRect(0,0, width, height)

        var tip_scr  = fluoroImplantControlsOVM.tip_screen
        var head_scr = fluoroImplantControlsOVM.hind_screen
        var scDir = head_scr.minus(tip_scr).normalized()

        handleRotation = Math.atan2(scDir.y,scDir.x) * 180/Math.PI

        if (fluoroImplantControlsOVM.simplePlanning) {
            handleTip = tip_scr.minus(scDir.times(45))
            handleHead = head_scr.plus(scDir.times(45))

            drawImplant(tip_scr,head_scr)
        }
        else {
            handleTip = tip_scr.minus(scDir.times(60))
            handleHead = head_scr.plus(scDir.times(60))
            shaftDirection = handleTip.minus(handleHead).normalized()
        }

        renderer.update()
    }

    function drawCirle(pt,radius,colorName) {
        context.beginPath()
        context.strokeStyle = colorName
        context.arc(pt.x, pt.y, radius, 0, 2*Math.PI, true)
        context.stroke()
    }

    function drawImplant(pTip,pHead) {
        var sDir = pHead.minus(pTip).normalized()
        var nDir = Qt.vector2d(sDir.y,-sDir.x)

        context.beginPath()
        context.lineWidth = 2
        context.strokeStyle = Theme.blue

        var rad = 3
        var p1 = pHead.minus(sDir.times(rad))
        var p2 = pTip.plus(sDir.times(rad))
        var p3 = pTip.plus(sDir.times(3*rad)).plus(nDir.times(2*rad))
        var p4 = pTip.plus(sDir.times(3*rad)).minus(nDir.times(2*rad))

        context.moveTo(p1.x, p1.y)
        context.lineTo(p2.x,p2.y)
        context.moveTo(p3.x, p3.y)
        context.lineTo(p2.x,p2.y)
        context.lineTo(p4.x,p4.y)
        context.stroke()

        // Head
        context.beginPath()
        context.fillStyle = Theme.blue
        context.arc(pHead.x, pHead.y, rad, 0, 2*Math.PI, true)
        context.fill()
        context.stroke()

        // Tip
        context.beginPath()
        context.fillStyle = Theme.blue
        context.arc(pTip.x, pTip.y, rad, 0, 2*Math.PI, true)
        context.fill()
        context.stroke()
    }

    Connections {
        target: fluoroImplantControlsOVM

        function onSimplePlanningChanged() { requestPaint() }
        function onIsInterbodyObjectChanged() { requestPaint() }
        function onPositionChanged() { requestPaint() }
    }

    IconButton {
        anchors { right: parent.right; top: parent.top; topMargin: Theme.margin(1); rightMargin: Theme.margin(1) }
        icon.source: "qrc:/icons/screw.svg"
        color: Theme.white
        active: !fluoroImplantControlsOVM.simplePlanning

        onClicked: fluoroImplantControlsOVM.toggleSimplePlanning()
    }

    Rectangle {
        visible: fluoroImplantControlsOVM.isInterbodyObject 
        height: 3
        radius: height / 2
        width: parent.width / 3
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter; margins: Theme.marginSize * 2.5 }

        property real twistPosition: (twistSlider.x - (width / 2)) / (width / 2)

        Rectangle {
            visible: twistMA.pressed
            opacity: 0.5
            width: Theme.marginSize * 3
            height: width
            radius: width / 2
            anchors { centerIn: twistSlider }
            color: Theme.blue
        }

        Rectangle {
            width: 36
            height: width
            radius: width / 2
            anchors { centerIn: twistSlider }

            IconImage {
                id: rotateIcon
                sourceSize: Theme.iconSize
                anchors { centerIn: parent }
                source: "qrc:/icons/rotate.svg"
                color: Theme.black
                rotation: 45
            }
        }

        Rectangle {
            id: twistSlider
            width: 1
            height: 2
            x: (parent.width / 2) - (width / 2)
            anchors { verticalCenter: parent.verticalCenter }
            color: Theme.transparent
        }

        MouseArea {
            id: twistMA
            width: 100
            height: 100
            anchors { centerIn: twistSlider }
            drag { target: twistSlider; axis: Drag.XAxis; minimumX: 0; maximumX: parent.width }

            property real lastPosition: 0

            onPressed: lastPosition = parent.twistPosition

            onPositionChanged: {
                fluoroImplantControlsOVM.twistImplant(lastPosition - parent.twistPosition)
                rotateIcon.rotation += (parent.twistPosition - lastPosition) * 360
                lastPosition = parent.twistPosition
            }
        }
    }

    Rectangle {
        visible: !fluoroImplantControlsOVM.simplePlanning
        height: 3
        radius: height / 2
        width: parent.width / 3
        anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter; margins: Theme.marginSize * 2.5 }

        property real trajectoryPosition: (trajectorySlider.x - (width / 2)) / (width / 2)

        Rectangle {
            visible: trajectorySliderMA.pressed
            opacity: 0.5
            width: Theme.marginSize * 3
            height: width
            radius: width / 2
            anchors { centerIn: trajectorySlider }
            color: Theme.blue
        }

        Rectangle {
            width: 36
            height: width
            radius: width / 2
            anchors { centerIn: trajectorySlider }

            IconImage {
                anchors { fill: parent; margins: Theme.marginSize / 4 }
                source: "qrc:/icons/move-vector.svg"
                color: Theme.black
            }
        }

        Rectangle {
            id: trajectorySlider
            width: 1
            height: 2
            x: (parent.width / 2) - (width / 2)
            anchors { verticalCenter: parent.verticalCenter }
            color: Theme.transparent
        }

        MouseArea {
            id: trajectorySliderMA
            width: 100
            height: 100
            anchors { centerIn: trajectorySlider }
            drag { target: trajectorySlider; axis: Drag.XAxis; minimumX: 0; maximumX: parent.width }

            property real lastPosition: 0

            onPressed: lastPosition = parent.trajectoryPosition

            onPositionChanged: {
                fluoroImplantControlsOVM.screwSlider((lastPosition - parent.trajectoryPosition) * 200)
                lastPosition = parent.trajectoryPosition
            }
        }
    }

    Image {
        visible: true
        x: handleHead.x - (width / 2)
        y: handleHead.y - (height / 2)
        rotation: handleRotation
        source: "qrc:/icons/implant-control/movement-control.png"

        MouseArea {
            anchors { fill: parent }

            property vector2d lastMousePnt: Qt.vector2d(0, 0)

            onPressed: {
                var p = mapToItem(canvas, mouse.x, mouse.y)
                lastMousePnt = renderer.screenToImage(Qt.vector2d(p.x, p.y)).toVector2d()
            }

            onPositionChanged: {
                var p = mapToItem(canvas, mouse.x, mouse.y)
                var currentPos = renderer.screenToImage(Qt.vector2d(p.x, p.y)).toVector2d()
                fluoroImplantControlsOVM.moveHead(currentPos.minus(lastMousePnt));
                lastMousePnt = currentPos
            }
        }
    }

    Image {
        visible: true
        x: handleTip.x - (width / 2)
        y: handleTip.y - (height / 2)
        rotation: handleRotation - 90
        source: "qrc:/icons/implant-control/rotate-topoint.png"

        MouseArea {
            anchors { fill: parent }

            property vector2d lastMousePnt: Qt.vector2d(0, 0)

            onPressed: {
                var p = mapToItem(canvas, mouse.x, mouse.y)
                lastMousePnt = renderer.screenToImage(Qt.vector2d(p.x, p.y)).toVector2d()
            }

            onPositionChanged: {
                var p = mapToItem(canvas, mouse.x, mouse.y)
                var currentPos = renderer.screenToImage(Qt.vector2d(p.x, p.y)).toVector2d()
                fluoroImplantControlsOVM.moveTip(currentPos.minus(lastMousePnt));
                lastMousePnt = currentPos
            }
        }
    }

    Image {
        visible: !fluoroImplantControlsOVM.simplePlanning
        x: handleHead.x - (width / 2) - (shaftDirection.y * 45)
        y: handleHead.y - (height / 2) + (shaftDirection.x * 45)
        rotation: handleRotation + 90
        source: "qrc:/icons/implant-control/arrow-increment.png"

        MouseArea {
            anchors { fill: parent }

            onClicked: {
                var dir = Qt.vector2d(shaftDirection.y, -shaftDirection.x)
                fluoroImplantControlsOVM.moveHead(dir.times(-fineIncrement));
            }
        }
    }

    Image {
        visible: !fluoroImplantControlsOVM.simplePlanning
        x: handleHead.x - (width / 2) + (shaftDirection.y * 45)
        y: handleHead.y - (height / 2) - (shaftDirection.x * 45)
        rotation: handleRotation - 90
        source: "qrc:/icons/implant-control/arrow-increment.png"

        MouseArea {
            anchors { fill: parent }

            onClicked: {
                var dir = Qt.vector2d(shaftDirection.y, -shaftDirection.x)
                fluoroImplantControlsOVM.moveHead(dir.times(fineIncrement));
            }
        }
    }

    Image {
        visible: !fluoroImplantControlsOVM.simplePlanning
        x: handleHead.x - (width / 2) + (shaftDirection.x * 45)
        y: handleHead.y - (height / 2) + (shaftDirection.y * 45)
        rotation: handleRotation
        source: "qrc:/icons/implant-control/arrow-increment.png"

        MouseArea {
            anchors { fill: parent }

            onClicked: {
                fluoroImplantControlsOVM.moveHead(shaftDirection.times(fineIncrement));
            }
        }
    }

    Image {
        visible: !fluoroImplantControlsOVM.simplePlanning
        x: handleHead.x - (width / 2) - (shaftDirection.x * 45)
        y: handleHead.y - (height / 2) - (shaftDirection.y * 45)
        rotation: handleRotation - 180
        source: "qrc:/icons/implant-control/arrow-increment.png"

        MouseArea {
            anchors { fill: parent }

            onClicked: {
                fluoroImplantControlsOVM.moveHead(shaftDirection.times(-fineIncrement));
            }
        }
    }

    Image {
        visible: !fluoroImplantControlsOVM.simplePlanning
        x: handleTip.x - (width / 2) - (shaftDirection.y * 45)
        y: handleTip.y - (height / 2) + (shaftDirection.x * 45)
        rotation: handleRotation
        source: "qrc:/icons/implant-control/rotate90-increment.png"

        MouseArea {
            anchors { fill: parent }

            onClicked: {
                var dir = Qt.vector2d(shaftDirection.y, -shaftDirection.x)
                fluoroImplantControlsOVM.moveTip(dir.times(-fineIncrement));
            }
        }
    }

    Image {
        visible: !fluoroImplantControlsOVM.simplePlanning
        x: handleTip.x - (width / 2) + (shaftDirection.y * 45)
        y: handleTip.y - (height / 2) - (shaftDirection.x * 45)
        rotation: handleRotation + 180
        mirror: true
        source: "qrc:/icons/implant-control/rotate90-increment.png"

        MouseArea {
            anchors { fill: parent }

            onClicked: {
                var dir = Qt.vector2d(shaftDirection.y, -shaftDirection.x)
                fluoroImplantControlsOVM.moveTip(dir.times(fineIncrement));
            }
        }
    }

    Image {
        visible: !fluoroImplantControlsOVM.simplePlanning
        x: handleTip.x - (width / 2) - (shaftDirection.x * 45)
        y: handleTip.y - (height / 2) - (shaftDirection.y * 45)
        rotation: handleRotation - 180
        source: "qrc:/icons/implant-control/arrow-increment.png"

        MouseArea {
            anchors { fill: parent }

            onClicked: {
                fluoroImplantControlsOVM.moveTip(shaftDirection.times(-fineIncrement));
            }
        }
    }

    Image {
        visible: !fluoroImplantControlsOVM.simplePlanning
        x: handleTip.x - (width / 2) + (shaftDirection.x * 45)
        y: handleTip.y - (height / 2) + (shaftDirection.y * 45)
        rotation: handleRotation
        source: "qrc:/icons/implant-control/arrow-increment.png"

        MouseArea {
            anchors { fill: parent }

            onClicked: {
                fluoroImplantControlsOVM.moveTip(shaftDirection.times(fineIncrement));
            }
        }
    }
}
