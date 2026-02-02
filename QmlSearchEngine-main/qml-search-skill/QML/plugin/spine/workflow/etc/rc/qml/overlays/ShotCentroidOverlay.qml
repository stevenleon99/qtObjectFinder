import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import Enums 1.0

import "../components/centroid"

Item {
    id: centroidOverlay
    visible: renderer.scanList.length
    anchors { fill: parent }
    clip: true

    property var renderer

    ShotCentroidOverlayViewModel {
        id: shotCentroidOverlayViewModel
        viewport: renderer
    }

    Repeater {
        model: shotCentroidOverlayViewModel.centroidInfoList

        Centroid {
            id: centroid
            locX: centerPoint.x
            locY: centerPoint.y
            text: role_anatomyName
            selected: role_selected

            property var shotCentroid: role_centroid_screen
            property point centerPoint: Qt.point(shotCentroid.x, shotCentroid.y)

            MouseArea {
                enabled: shotCentroidOverlayViewModel.isEnabled
                anchors { fill: parent }

                onPositionChanged: {
                    var p = parent.mapToItem(centroidOverlay, mouse.x, mouse.y)

                    if (p.x > 0 && p.x <= centroidOverlay.width
                            && p.y > 0 && p.y <= centroidOverlay.height) {
                        shotCentroidOverlayViewModel.setAnatomyCentroid(role_anatomy, Qt.vector2d(p.x, p.y))
                     } else {
                        shotCentroidOverlayViewModel.clearAnatomyCentroid(role_anatomy)
                    }
                }
            }
        }
    }

    DropArea {
        anchors { fill: parent }
        keys: ["centroid"]

        onDropped: shotCentroidOverlayViewModel.dropAnatomyCentroid(drop.source.anatomy, Qt.vector2d(drop.x, drop.y))
    }
}
