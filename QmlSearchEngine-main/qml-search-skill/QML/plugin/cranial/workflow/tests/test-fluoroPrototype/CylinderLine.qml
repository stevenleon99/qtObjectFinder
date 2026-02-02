import QtQuick 2.4
import Qt3D 2.0
import Qt3D.Shapes 2.0

Item3D {
    property alias color: myEffect.color
    property vector3d p0: Qt.vector3d(0,-1,0)
    property vector3d p1: Qt.vector3d(0, 1,0)
    property bool segment: false
    property bool showEnds: false
    property alias radius: mesh.radius

    onP0Changed: {
        updateDisplay();
    }

    onP1Changed: {
        updateDisplay();
    }
    onSegmentChanged: {
        updateDisplay()
    }

    function updateDisplay()
    {
        trans.translate = p0.plus(p1).times(0.5)
        var lDir = p1.minus(p0)
        var lng = lDir.length()
        lDir = lDir.normalized()
        rot.axis = lDir.crossProduct(Qt.vector3d(0,0,1))
        rot.angle = Math.acos(-lDir.z) * 180 / Math.PI

        if(segment)
        {
            mesh.length = lng
        }
        else
        {
            mesh.length = 500.0
        }
    }

    Effect {
        id: myEffect
    }

    Item3D {
        mesh: CylinderMesh {
            id: mesh
            radius: .5
            length: 1000.0
        }
        transform: [
            Rotation3D { id:rot },
            Translation3D { id: trans }
        ]

        effect: myEffect
    }

    Sphere {
        visible: showEnds
        radius: mesh.radius + 1
        effect: myEffect
        transform: [
            Translation3D { translate: p0 }
        ]
    }

    Sphere {
        visible: showEnds
        radius: mesh.radius + 1
        effect: myEffect
        transform: [
            Translation3D { translate: p1 }
        ]
    }
}

