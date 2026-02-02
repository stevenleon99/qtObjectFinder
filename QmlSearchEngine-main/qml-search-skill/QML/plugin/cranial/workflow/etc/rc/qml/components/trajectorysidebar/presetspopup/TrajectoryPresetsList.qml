import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import "../.."

ListView {
    headerPositioning: ListView.OverlayHeader
    clip: true

    ListModel {
        id: headerModel
        ListElement { role_weight: 8; role_text: "NAME"; role_role: "role_name" }
        ListElement { role_weight: 4; role_text: "SOURCE"; role_role: "role_source" }
        ListElement { role_weight: 5; role_text: "CREATED"; role_role: "role_created" }
    }

    ScrollBar.vertical: ScrollBar {
        id: scrollBar
    }

    header: Rectangle {
        width: parent.width - scrollBar.width
        height: Theme.margin(8)
        color: Theme.backgroundColor

        RowLayout {
            anchors { fill: parent }
            spacing: Theme.margin(2)

            Repeater {
                model: headerModel

                Label {
                    Layout.fillWidth: true
                    Layout.preferredWidth: role_weight
                    state: "body2"
                    font.bold: true
                    color: Theme.navyLight
                    text: role_text
                }
            }
        }

        DividerLine {
            anchors { bottom: parent.bottom }
            orientation: Qt.Horizontal
        }
    }

    delegate: TrajectoryPresetsListDelegate {
        z: -19
        width: parent.width - scrollBar.width
        sortListModel: headerModel
        selected: role_selected
    }
}
