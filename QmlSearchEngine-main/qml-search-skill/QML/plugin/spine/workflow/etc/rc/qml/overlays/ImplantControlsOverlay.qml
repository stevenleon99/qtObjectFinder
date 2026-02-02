import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import ViewModels 1.0

import Theme 1.0

Item {
    id: overlayRoot
    visible: renderer.scanList.length && 
             renderer.viewType === ImageViewport.Traj_1
    clip: true

    property var renderer
    property bool viewPE: implantControlsOverlayViewModel.probeEyeView
    property bool activeDrag: false

    ImplantControlsOverlayViewModel {
        id: implantControlsOverlayViewModel
        viewport: renderer
    }
    MouseArea {
        anchors { fill: parent }
        acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
        onPressed:  implantControlsOverlayViewModel.mousePressed(mouse.x,mouse.y)
        onPositionChanged: implantControlsOverlayViewModel.mousePosition(mouse.x,mouse.y)
        onWheel: implantControlsOverlayViewModel.mouseWheel(wheel.angleDelta.y / 120)
    }

    MultiPointTouchArea {
        id: viewTouchArea
        enabled: true
        anchors { fill: parent }
        minimumTouchPoints: 2
        maximumTouchPoints: 2
        mouseEnabled: false
        touchPoints: [
            TouchPoint { id: p1 },
            TouchPoint { id: p2 }
        ]
              
        property bool pressed: p1.pressed || p2.pressed

        function validPosition() {
            return validWidth(p1.x) &&
                    validWidth(p2.x) &&
                    validHeight(p1.y) &&
                    validHeight(p2.y)
        }
        function validWidth(pos) {
            return (pos > 0) && (pos < width)
        }
        function validHeight(pos) {
            return (pos > 0) && (pos < height)
        }

        onTouchUpdated: {
            if (validPosition()) {
                var previousPos1 = Qt.vector2d(p1.previousX, p1.previousY)
                var previousPos2 = Qt.vector2d(p2.previousX, p2.previousY)
                var pos1 = Qt.vector2d(p1.x, p1.y)
                var pos2 = Qt.vector2d(p2.x, p2.y)
                implantControlsOverlayViewModel.touchEvent(previousPos1, previousPos2, pos1, pos2)
            }
        }
    }

    Item {
        id: implantControl
        x: implantControlsOverlayViewModel.overlayCenter.x -  (width / 2)
        y: implantControlsOverlayViewModel.overlayCenter.y -  (height / 2)
        height: viewPE ? 140 : (implantControlsOverlayViewModel.overlayLength + headZone.height + tipZone.height)
        visible: implantControlsOverlayViewModel.active

        rotation: implantControlsOverlayViewModel.overlayRotation

        /* property point centerPoint: Qt.point(x + width / 2, y + height / 2) */
        property real centerX: x + width / 2
        property real centerY: y + height / 2

        Item {
            id: moveZone
            objectName: "Body"
            height: viewPE ? tipZone.width : implantControlsOverlayViewModel.overlayLength
            width: tipZone.width
            anchors { centerIn: parent }

            MouseArea {
                property real startX
                property real startY

                anchors { fill: parent }

                onPressed: {
                    var orMpos = mapToItem(overlayRoot, mouse.x, mouse.y);
                    implantControlsOverlayViewModel.startDrag(orMpos.x, orMpos.y)
                    activeDrag = true
                }

                onPositionChanged: {
                    var orMpos = mapToItem(overlayRoot, mouse.x, mouse.y);
                    implantControlsOverlayViewModel.dragPosition(orMpos.x, orMpos.y)
                }

                onReleased: {
                    implantControlsOverlayViewModel.endDrag()
                    activeDrag = false
                }
            }
        }

        Image {
            id: twistZoneLeft
            objectName: "TwistIncrementLeft"
            visible: !viewPE && !activeDrag
            anchors { verticalCenter: twistZone.verticalCenter; right: twistZone.left; rightMargin: Theme.marginSize }
            source: "qrc:/icons/implant-control/rotate-around-increment.png"

            MouseArea {
                anchors { fill: parent }
                onClicked: implantControlsOverlayViewModel.twist(-1)
            }
        }

        Image {
            id: twistZone
            objectName: "Twist"
            visible: !viewPE && (!activeDrag || twistZoneMouseArea.pressed )
            anchors { bottom: headZone.top; bottomMargin: Theme.marginSize; horizontalCenter: parent.horizontalCenter }
            source: "qrc:/icons/implant-control/rotate-around.png"
            MouseArea {
                id: twistZoneMouseArea
                anchors { fill: parent }
                onPressed: {
                    activeDrag = true
                    var orMpos = mapToItem(overlayRoot, mouse.x, mouse.y);
                    implantControlsOverlayViewModel.startDrag(orMpos.x, orMpos.y)
                    renderer.autoTransformUpdatesEnabled = true
                }
                onPositionChanged: {
                    var orMpos = mapToItem(overlayRoot, mouse.x, mouse.y);
                    implantControlsOverlayViewModel.dragTwist(orMpos.x, orMpos.y)
                }
                onReleased: {
                    activeDrag = false
                }
            }

        }

        Image {
            id: twistZoneRight
            mirror: true
            objectName: "TwistIncrementRight"
            visible: !viewPE && !activeDrag

            anchors { verticalCenter: twistZone.verticalCenter; left: twistZone.right; leftMargin: Theme.marginSize }
            source: "qrc:/icons/implant-control/rotate-around-increment.png"
               MouseArea {
                anchors { fill: parent }
                onClicked: implantControlsOverlayViewModel.twist(1)
            }
        }

        Image {
            id: headZone
            objectName: "Head"
            visible: !viewPE && (!activeDrag || headZoneMouseArea.pressed )

            anchors { bottom: fineHeadElongateZone.top; bottomMargin: Theme.marginSize; horizontalCenter: parent.horizontalCenter }
            source: "qrc:/icons/implant-control/rotate-topoint.png"
            MouseArea {
                id: headZoneMouseArea
                anchors { fill: parent }
                onPressed: {
                    activeDrag = true
                    var orMpos = mapToItem(overlayRoot, mouse.x, mouse.y);
                    implantControlsOverlayViewModel.startDrag(orMpos.x, orMpos.y)
                }
                onPositionChanged: {
                    var orMpos = mapToItem(overlayRoot, mouse.x, mouse.y);
                    implantControlsOverlayViewModel.dragHead(orMpos.x, orMpos.y)
                }
                onReleased: {
                    activeDrag = false
                    implantControlsOverlayViewModel.endDrag()
                }
            }
        }

        Image {
            id: tipZone
            objectName: "Tip"
            visible: !viewPE && (!activeDrag || tipZoneMouseArea.pressed )
            rotation: 180
            anchors { top: fineTipElongateZone.bottom; topMargin: Theme.marginSize; horizontalCenter: parent.horizontalCenter }
            source: "qrc:/icons/implant-control/rotate-topoint.png"
            MouseArea {
                id: tipZoneMouseArea
                anchors { fill: parent }
                onPressed: {
                    activeDrag = true
                    var orMpos = mapToItem(overlayRoot, mouse.x, mouse.y);
                    implantControlsOverlayViewModel.startDrag(orMpos.x, orMpos.y)
                }
                onPositionChanged: {
                    var orMpos = mapToItem(overlayRoot, mouse.x, mouse.y);
                    implantControlsOverlayViewModel.dragTip(orMpos.x, orMpos.y)
                }
                onReleased: {
                    activeDrag = false
                    implantControlsOverlayViewModel.endDrag()
                }
            }
        }

        Image {
            id: fineHeadCCWZone
            objectName: "FineHeadCCW"
            visible: !viewPE && !activeDrag
            mirror: true
            rotation: -90
            anchors { bottom: moveZone.top; right: moveZone.left; rightMargin: Theme.marginSize }
            source: "qrc:/icons/implant-control/rotate90-increment.png"
            MouseArea {
                anchors { fill: parent }
                onClicked: implantControlsOverlayViewModel.rotateHead(1)
            }
        }

        Image {
            id: fineHeadElongateZone
            objectName: "FineHeadElongate"
            visible: !activeDrag
            rotation: 90
            anchors { bottom: moveZone.top; bottomMargin: Theme.marginSize; horizontalCenter: parent.horizontalCenter }
            source: "qrc:/icons/implant-control/arrow-increment.png"
            MouseArea {
                anchors { fill: parent }
                onClicked: implantControlsOverlayViewModel.shiftPosition(0, -1)
            }
        }

        Image {
            id: fineHeadCWZone
            objectName: "FineHeadCW"
            visible: !viewPE && !activeDrag
            rotation: 90
            anchors { bottom: moveZone.top; left: moveZone.right; leftMargin: Theme.marginSize }
            source: "qrc:/icons/implant-control/rotate90-increment.png"
            MouseArea {
                anchors { fill: parent }
                onClicked: implantControlsOverlayViewModel.rotateHead(-1)
            }
        }

        Image {
            id: fineMoveLeftZone
            objectName: "FineBodyLeft"
            visible: !activeDrag
            anchors { verticalCenter: parent.verticalCenter; right: moveZone.left; rightMargin: Theme.marginSize }
            source: "qrc:/icons/implant-control/arrow-increment.png"
            MouseArea {
                anchors { fill: parent }
                onClicked: implantControlsOverlayViewModel.shiftPosition(-1, 0)
            }
        }

        Image {
            id: fineMoveRightZone
            objectName: "FineBodyRight"
            visible: !activeDrag
            rotation: 180
            anchors { verticalCenter: parent.verticalCenter; left: moveZone.right; leftMargin: Theme.marginSize }
            source: "qrc:/icons/implant-control/arrow-increment.png"
            MouseArea {
                anchors { fill: parent }
                onClicked: implantControlsOverlayViewModel.shiftPosition(1, 0)
            }
        }

        Image {
            id: fineTipCWZone
            objectName: "FineTipCW"
            visible: !viewPE && !activeDrag
            rotation: -90
            anchors { top: moveZone.bottom; right: moveZone.left; rightMargin: Theme.marginSize }
            source: "qrc:/icons/implant-control/rotate90-increment.png"
            MouseArea {
                anchors { fill: parent }
                onClicked: implantControlsOverlayViewModel.rotateTip(-1)
            }
        }

        Image {
            id: fineTipElongateZone
            objectName: "FineTipElongate"
            visible: !activeDrag
            rotation: -90
            anchors { top: moveZone.bottom; topMargin: Theme.marginSize; horizontalCenter: parent.horizontalCenter }
            source: "qrc:/icons/implant-control/arrow-increment.png"
            MouseArea {
                anchors { fill: parent }
                onClicked: implantControlsOverlayViewModel.shiftPosition(0, 1)
            }
        }

        Image {
            id: fineTipCCWZone
            objectName: "FineTipCCW"
            visible: !viewPE && !activeDrag
            mirror: true
            rotation: 90
            anchors { top: moveZone.bottom; left: moveZone.right; leftMargin: Theme.marginSize }
            source: "qrc:/icons/implant-control/rotate90-increment.png"
            MouseArea {
                anchors { fill: parent }
                onClicked: implantControlsOverlayViewModel.rotateTip(1)
            }
        }
    }
}


