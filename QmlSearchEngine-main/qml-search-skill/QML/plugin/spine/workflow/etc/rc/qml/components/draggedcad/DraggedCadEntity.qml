import Qt3D.Core 2.0
import Qt3D.Render 2.15
import Qt3D.Input 2.0
import Qt3D.Extras 2.15

import ViewModels 1.0
import Enums 1.0

Entity {
    id: entity
    components: [
        RenderSettings {
            activeFrameGraph: ForwardRenderer {
                camera: camera
                clearColor: "transparent"
            }
        }
    ]

    property string source

    property alias color: material.diffuse

    property alias scale: transform.scale

    property int orientation: DraggedCadOrientation.Front

    Camera {
        id: camera
        projectionType: CameraLens.OrthographicProjection
        nearPlane: 0.1
        farPlane: 1000.0
        position: Qt.vector3d(0, 0, 10)
        upVector: Qt.vector3d(0, 1, 0)
        viewCenter: Qt.vector3d(0, 0, 0)
    }

    Mesh {
        id: mesh
        source: "file:///" + parent.source
    }

    GoochMaterial {
        id: material
        specular: Qt.rgba(1, 1, 1, 1)
        cool: diffuse
        warm: Qt.rgba(1, 1, 1, 1)
    }

    Transform {
        id: transform
        rotation: switch(orientation) {
                  case DraggedCadOrientation.Front: return fromEulerAngles(0, 0, 0)
                  case DraggedCadOrientation.Side: return fromEulerAngles(0, 90, 0)
                  case DraggedCadOrientation.Top: return fromEulerAngles(90, 0, 0)
                  default: return fromAxisAndAngle(Qt.vector3d(0, 0, 0), 90)
                  }
    }

    Entity {
        components: [ mesh, material, transform ]
    }
}