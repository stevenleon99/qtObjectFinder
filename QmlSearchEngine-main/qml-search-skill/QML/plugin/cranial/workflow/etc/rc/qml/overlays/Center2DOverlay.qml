import QtQuick 2.12
import ViewModels 1.0

Canvas {
    visible: renderer.viewType !== ImageViewport.ThreeD
    
    property var renderer

    property variant colorCenter: center2DOverlayViewModel.center2DColor
    property int sizeCenter: center2DOverlayViewModel.center2DSize
    property variant textCenter: center2DOverlayViewModel.center2DText
    
    Center2DOverlayViewModel {
        id: center2DOverlayViewModel
    }

    onPaint: {
        var ctx = getContext("2d")
        ctx.reset()
        ctx.beginPath()
        ctx.fillStyle = colorCenter

        var centerX = width / 2
        var centerY = height / 2
        ctx.moveTo(centerX, centerY)
        ctx.arc(centerX, centerY, sizeCenter, 0, Math.PI * 2, false)
        ctx.font = "16px sans-serif"
        ctx.fillText(qsTr(center2DOverlayViewModel.center2DText), centerX+5, centerY + 5)
        ctx.fill()
        ctx.closePath()
    }

    onSizeCenterChanged: requestPaint()

    onColorCenterChanged: requestPaint()

    onAvailableChanged: requestPaint()

    onWidthChanged: requestPaint()

    onTextCenterChanged: requestPaint()

    PinchArea {
        anchors { fill: parent }

        onPinchStarted: { 
            center2DOverlayViewModel.pinchStarted(renderer);
            center2DOverlayViewModel.mousePressed(renderer, Qt.LeftButton, pinch.startCenter.x, pinch.startCenter.y)
        }

        onPinchUpdated: {
            center2DOverlayViewModel.pinchUpdated(renderer,pinch.scale);
            center2DOverlayViewModel.mousePositionChanged(renderer, Qt.LeftButton, pinch.center.x, pinch.center.y)
        }

        MouseArea {
            anchors { fill: parent }
            acceptedButtons: Qt.AllButtons
            hoverEnabled: false 
            property bool clickValid: false

            onPressed: {
                center2DOverlayViewModel.mousePressed(renderer, mouse.buttons, mouse.x, mouse.y)
                clickValid = true
            }
            
            onPositionChanged: {
                center2DOverlayViewModel.mousePositionChanged(renderer, mouse.buttons, mouse.x, mouse.y)
                clickValid = false
            }
            
            onReleased: center2DOverlayViewModel.mouseReleased(renderer, mouse.buttons, mouse.x, mouse.y)
            
            onWheel: center2DOverlayViewModel.mouseWheel(renderer, wheel.angleDelta.y / 120)

            onClicked: if(clickValid) center2DOverlayViewModel.mouseClicked(renderer, mouse.x, mouse.y)

            MultiPointTouchArea {
                anchors { fill: parent }
                mouseEnabled: false
                touchPoints: [
                    TouchPoint {
                        id: touchpoint
                        onPressedChanged: {
                            if (pressed)
                            {
                                center2DOverlayViewModel.mousePressed(renderer, Qt.LeftButton, x, y);
                            }
                            else
                            {
                                center2DOverlayViewModel.mouseReleased(renderer, Qt.LeftButton, x, y);
                            }
                        }
                        onXChanged: {
                            if (pressed)
                            {
                                center2DOverlayViewModel.mousePositionChanged(renderer, Qt.LeftButton, x, y);
                            }
                        }
                        onYChanged: {
                            if (pressed)
                            {
                                center2DOverlayViewModel.mousePositionChanged(renderer, Qt.LeftButton, x, y);
                            }
                        }
                    }
                ]
            }
        }
    }
}


