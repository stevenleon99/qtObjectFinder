import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

Item {
    id: orientationOverlay
    visible: orientationOVM.display

    property var renderer

    OrientationOverlayViewModel {
        id: orientationOVM
        viewport: renderer
    }
    
    Item {
        anchors { fill: parent }

        Repeater {
            model: orientationOVM

            Label {
                id: axisLabel
                x: switch (role_position) {
                   case "top": return (parent.width / 2) - (width / 2)
                   case "right": return parent.width - width - 2
                   case "bottom": return (parent.width / 2) - (width / 2)
                   case "left": return 2
                   default: return 0
                   }
                y: switch (role_position) {
                   case "top": return 0
                   case "right": return (parent.height / 2) - (height / 2)
                   case "bottom": return parent.height - height
                   case "left": return (parent.height / 2) - (height / 2)
                   default: return 0
                   }
                state: "subtitle1"
                color: role_color
                text: role_label
                style: Text.Outline
                styleColor: role_styleColor
            }
        }
    }
}
