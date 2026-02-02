import QtQuick 2.4
import QtQuick.Window 2.1
import Qt3D 2.0
import Qt3D.Shapes 2.0
import EpicQmlComponents 1.0

Window {
    id: mainUI
    width: 900
    height: 760
    visible: true

    Rectangle {
        anchors.centerIn: parent
        width: height
        height: parent.height - 40
        color: "gray"
        border.width: 2
        border.color: 'black'

        Viewport {
            anchors.fill: parent
            fillColor: "transparent"

            Camera {
                id: myCam
                projectionType: Camera.Orthographic
                eye: Qt.vector3d(-705.813, 1305.29, -1954.13)
                center: Qt.vector3d(-38.9316, 184.064, -1193.72)
                upVector: Qt.vector3d(-0.892987, -0.313318, 0.32312)
                nearPlane: -10000
                farPlane: 10000

                onEyeChanged: {
                    console.log(eye,center,upVector)
                }

                Component.onCompleted: {
                    testManipulator.setViewSize(myCam,Qt.size(5000.0,5000.0))
                }
            }
            scale: 1.0
            camera: myCam

            light: Light {
                id: myLight
                position: myCam.eye //lightProxy.localToWorld()
                // A dimmer ambient light, so it doesn't light up the "wrong"
                // side of the blocks
                ambientColor: "#888888"
                constantAttenuation: 1
                linearAttenuation: 0
                quadraticAttenuation: 0
            }

            Sphere {
                id: camera_model
                radius: 25
                transform: [
                    Translation3D { translate: Qt.vector3d(0,0,0) },
                    Scale3D { scale: Qt.vector3d(1,5,1) }
                ]
                effect: Effect {
                    color: 'white'
                }

            }

            Quad {
                scale: 10000
                transform: [
                    Rotation3D {
                        angle: -90
                        axis: Qt.vector3d(0,0,1)
                    }
                ]
                position: Qt.vector3d(1275, 0,-1500)

                effect: Effect {
                    color: "#aaaaaa"
                }
            }

            Line {
                id: camera_boundary
                vertices: [
                    735,  928, -3000,
                    -735,  928, -3000,
                    -735, -928, -3000,
                    735, -928, -3000,
                    735,  928, -3000,
                    656,  783, -2400,
                    656, -783, -2400,
                    -656, -783, -2400,
                    -656,  783, -2400,
                    656,  783, -2400,
                    260,  310,  -950,
                    -260,  310,  -950,
                    -260, -310,  -950,
                    260, -310,  -950,
                    260,  310,  -950
                ]

                width: 3

                effect: Effect {
                    color: "#aaca00"
                }
            }
            Line {
                vertices: [
                    -735, 928,  -3000,
                    -656, 783,  -2400,
                    -260, 310,  -950
                ]
                width: camera_boundary.width
                effect: camera_boundary.effect
            }
            Line {
                vertices: [
                    735, -928,  -3000,
                    656, -783,  -2400,
                    260, -310,  -950
                ]
                width: camera_boundary.width
                effect: camera_boundary.effect
            }
            Line {
                vertices: [
                    -735, -928,  -3000,
                    -656, -783,  -2400,
                    -260, -310,  -950
                ]
                width: camera_boundary.width
                effect: camera_boundary.effect
            }

            TestManipulator {
                id: testManipulator
            }

            MultiPointTouchArea {
                anchors.fill: parent
                minimumTouchPoints: 1
                maximumTouchPoints: 2
                mouseEnabled: false
                touchPoints: [
                    TouchPoint { id: p1 },
                    TouchPoint { id: p2 }
                ]

                onTouchUpdated: {
                    if(touchPoints.length === 2)
                    {
                       testManipulator.followFingers(Qt.vector2d(p1.previousX,p1.previousY) ,Qt.vector2d(p2.previousX,p2.previousY),
                                               Qt.vector2d(p1.x,p1.y),Qt.vector2d(p2.x,p2.y),myCam)
                    }
                    else if(touchPoints.length === 1)
                    {
                        testManipulator.rotation(Qt.vector2d(touchPoints[0].previousX,touchPoints[0].previousY),
                                                 Qt.vector2d(touchPoints[0].x,touchPoints[0].y),myCam)
                    }
                }
            }
        }
    }
}
