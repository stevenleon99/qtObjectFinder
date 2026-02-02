import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

Rectangle {
    id: viewRectangle
    radius: Theme.margin(1)
    color: Theme.black
    clip: true

    property alias markerModel: repeater.model
    property alias crosshairVisible: crosshair.visible

    CameraCrosshair {
        id: crosshair
        anchors { fill: parent }
    }

    Repeater {
        id: repeater
        anchors { fill: parent }
        model: cameraViewViewModel.cameraViewListModel

        delegate: Rectangle {
            id: strayMarker
            x: (viewRectangle.width - (role_xRatio * viewRectangle.width)) - (width / 2)
            y: (role_yRatio * viewRectangle.height) - (height / 2)
            
            // (Bounded) non-linear scaling using polynomial expression: -0.01x^2 + 3x
            width: Math.max(10, Math.min(20, (-0.01 * (viewRectangle.width / 70) ** 2) + (3 * (viewRectangle.width / 70)))) * role_scaleRatio
            height: width
            radius: width / 2
            border.width: 2
            border.color: {
                if (role_visible)
                {
                    if (Qt.colorEqual(strayMarker.color, "black"))
                        return Theme.lineColor
                    else
                        return role_iconColor
                }

                return Theme.transparent
            }
            color: role_visible ? role_iconColor : Theme.transparent
            Label {
                state: "body1"
                text: role_toolDescription
                x: 20
                y: -20
                color: role_visible ? role_iconColor : Theme.transparent
            }
        }
    }
}


