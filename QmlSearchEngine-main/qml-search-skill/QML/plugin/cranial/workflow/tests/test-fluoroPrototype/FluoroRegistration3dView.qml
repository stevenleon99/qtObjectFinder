import QtQuick 2.4
import Qt3D 2.0
import Qt3D.Shapes 2.0

Viewport {
    fillColor: "black"
    camera: ccc
    light: Light {
        id: myLight
        position: ccc.eye //lightProxy.localToWorld()
        ambientColor: "#888888"
        linearAttenuation: 0
        constantAttenuation: 1
        quadraticAttenuation: 0
    }

    property var regData

    Connections {
        target: fluoroMgr
        onRegistrationChanged: {
            regData = regList
//            console.log(regData)
//            console.log(regData.length)
//            console.log(regData[0])
        }
    }

    function createLongLine(p1,p2)
    {
        var lDir = p2.minus(p1)
        lDir = lDir.normalized()
        var midPt = p1.plus(p2).times(0.5)

        var pn = midPt.plus(lDir.times(-5));
        var pp = midPt.plus(lDir.times(5));

        var verts = [];
        verts.push(pn.x)
        verts.push(pn.y)
        verts.push(pn.z)
        verts.push(midPt.x)
        verts.push(midPt.y)
        verts.push(midPt.z+0.001)
        verts.push(pp.x)
        verts.push(pp.y)
        verts.push(pp.z)

        return verts
    }

    function createLineSegment(p1,p2)
    {
        var midPt = p1.plus(p2).times(0.5)
        var verts = [];
        verts.push(p1.x)
        verts.push(p1.y)
        verts.push(p1.z)
        verts.push(midPt.x)
        verts.push(midPt.y)
        verts.push(midPt.z+0.001)
        verts.push(p2.x)
        verts.push(p2.y)
        verts.push(p2.z)

        return verts
    }

    Connections {
        target: fluoroMgr
        onPointsChanged: {
            var pts = fluoroMgr.image("LatImage").imgToFixture(fluoroMgr.bodyPosteriorLatImg)
            latLineA.p0 = pts[0]
            latLineA.p1 = pts[1]

            pts = fluoroMgr.image("LatImage").imgToFixture(fluoroMgr.bodyAnteriorLatImg)
            latLineB.p0 = pts[0]
            latLineB.p1 = pts[1]


            pts = fluoroMgr.image("APImage").imgToFixture( fluoroMgr.pedicleAinside)
            apLineA.p0 = pts[0]
            apLineA.p1 = pts[1]

            pts = fluoroMgr.image("APImage").imgToFixture( fluoroMgr.pedicleBinside)
            apLineB.p0 = pts[0]
            apLineB.p1 = pts[1]
        }
    }

    Camera {
        id: ccc
//        eye: Qt.vector3d(0, 0, 10)
//        center: Qt.vector3d(1.08964, -180.691, -9.72872)
        projectionType: Camera.Orthographic
        nearPlane: -20000
        farPlane: 20000

        center: Qt.vector3d(7.62939e-06, -182.839, 5.10848).times(0.05)
        //center: Qt.vector3d(1.08964, -180.691, -9.72872)

        Component.onCompleted: {
            eye = ((myEye.minus(center)).times(10)).plus(center)
//            console.log("Eye",eye)
        }

        //viewSize: Qt.size(2,2)


        property vector3d myEye: Qt.vector3d(797.59, -191.577, 32.8907).times(0.05)

       // eye: ((myEye.minus(center)).times(2.0)).plus(center)
    }

    Item3D
    {
        scale: 0.05

//        CylinderLine {
//            enabled: fluoroMgr.cursor
//            p0: fluoroMgr.cursorPntA
//            p1: fluoroMgr.cursorPntB
//            color: "green"
//            radius: 1
//            showEnds: false
//            segment: false
//        }

        CylinderLine {
            enabled: planningMode
            p0: fluoroMgr.headA
            p1: fluoroMgr.tipA
            color: "yellow"
            radius: 1
            showEnds: true
            segment: true
        }

        CylinderLine {
            id: latLineA
            color: "orange"
            radius: 1
            showEnds: false
            segment: false
        }

        CylinderLine {
            id: latLineB
            color: "orange"
            radius: 1
            showEnds: false
            segment: false
        }

        CylinderLine {
            id: apLineA
            color: "blue"
            radius: 1
            showEnds: false
            segment: false
        }

        CylinderLine {
            id: apLineB
            color: "blue"
            radius: 1
            showEnds: false
            segment: false
        }

        // AP Box
        CylinderLine {
            property var dataP: fluoroMgr.image("APImage").imgToFixture(Qt.vector2d(-512,-512))
            showEnds: false
            segment: false
            color: "red"
            p0: dataP[0]
            p1: dataP[1]
            radius: 2
            onDataPChanged: {
//                console.log("AP",-512,-512,dataP)
            }
        }
        CylinderLine {
            property var dataP: fluoroMgr.image("APImage").imgToFixture(Qt.vector2d(512,512))
            showEnds: false
            segment: false
            color: "red"
            p0: dataP[0]
            p1: dataP[1]
            radius: 2
            onDataPChanged: {
//                console.log("AP",512,512,dataP)
            }
        }
        CylinderLine {
            property var dataP: fluoroMgr.image("APImage").imgToFixture(Qt.vector2d(512,-512))
            showEnds: false
            segment: false
            color: "red"
            p0: dataP[0]
            p1: dataP[1]
            radius: 2
            onDataPChanged: {
//                console.log("AP",512,-512,dataP)
            }
        }
        CylinderLine {
            property var dataP: fluoroMgr.image("APImage").imgToFixture(Qt.vector2d(-512,512))
            showEnds: false
            segment: false
            color: "red"
            p0: dataP[0]
            p1: dataP[1]
            radius: 2
            onDataPChanged: {
 //               console.log("AP",-512,512,dataP)
            }
        }
        CylinderLine {
            property var dataP: fluoroMgr.image("APImage").imgToFixture(Qt.vector2d(0,0))
            showEnds: false
            segment: false
            color: "red"
            p0: dataP[0]
            p1: dataP[1]
            radius: 5
            onDataPChanged: {
//                console.log("AP",0,0,dataP)
            }
        }
        // Lat Box
        CylinderLine {
            property var dataP: fluoroMgr.image("LatImage").imgToFixture(Qt.vector2d(-512,-512))
            showEnds: false
            segment: false
            color: "green"
            p0: dataP[0]
            p1: dataP[1]
            radius: 2
            onDataPChanged: {
 //               console.log("Lat",-512,-512,dataP)
            }
        }
        CylinderLine {
            property var dataP: fluoroMgr.image("LatImage").imgToFixture(Qt.vector2d(512,512))
            showEnds: false
            segment: false
            color: "green"
            p0: dataP[0]
            p1: dataP[1]
            radius: 2
            onDataPChanged: {
 //               console.log("Lat",512,512,dataP)
            }
        }
        CylinderLine {
            property var dataP: fluoroMgr.image("LatImage").imgToFixture(Qt.vector2d(512,-512))
            showEnds: false
            segment: false
            color: "green"
            p0: dataP[0]
            p1: dataP[1]
            radius: 2
            onDataPChanged: {
 //               console.log("Lat",512,-512,dataP)
            }
        }
        CylinderLine {
            property var dataP: fluoroMgr.image("LatImage").imgToFixture(Qt.vector2d(-512,512))
            showEnds: false
            segment: false
            color: "green"
            p0: dataP[0]
            p1: dataP[1]
            radius: 2
            onDataPChanged: {
//                console.log("Lat",-512,512,dataP)
            }
        }
        CylinderLine {
            property var dataP: fluoroMgr.image("LatImage").imgToFixture(Qt.vector2d(0,0))
            showEnds: false
            segment: false
            color: "green"
            p0: dataP[0]
            p1: dataP[1]
            radius: 5
            onDataPChanged: {
 //               console.log("Lat",0,0,dataP)

                var ppA = fluoroMgr.image("LatImage").imgToFixture(Qt.vector2d(0,0))
                var ppB = fluoroMgr.image("APImage").imgToFixture( Qt.vector2d(0,0))
                var ppC = fluoroMgr.image("LatImage").imgToFixture(Qt.vector2d(512,512))

                var aa = fluoroMgr.closestPointOnLineAfromLineB(ppA[0],ppA[1],ppB[0],ppB[1])
                var bb = fluoroMgr.closestPointOnLineAfromLineB(ppB[0],ppB[1],ppA[0],ppA[1])

                var eye = fluoroMgr.closestPointOnLineAfromLineB(ppA[0],ppA[1],ppC[0],ppC[1])

                var cc = aa.plus(bb).times(0.5)
                var dd = ppA[0].plus(ppA[1]).times(0.5)

//                console.log(aa,dd,cc,eye)
            }
        }

        Repeater {
            id: spheres
            model: regData.length

            Sphere {
                    visible: true
                    radius: 4
                    effect: Effect {
                        color: "purple"
                    }
                    transform: [
                        Translation3D { translate: regData[index] }
                    ]
                }
        }





//        Cube {
//            effect: Effect {
//                color: "#111111"
//            }
//            transform: [
//                Scale3D { scale: Qt.vector3d(500,500,3) }
//            ]
//        }
    }

}

