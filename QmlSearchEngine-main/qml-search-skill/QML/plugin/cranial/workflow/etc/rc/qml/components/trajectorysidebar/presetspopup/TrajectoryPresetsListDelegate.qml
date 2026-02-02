import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import "../.."

Rectangle {
    height: Theme.margin(8)
    color: selected ? Theme.foregroundColor : Theme.backgroundColor

    property bool selected: false
    property alias sortListModel: sortList.model

    RowLayout {
        anchors { fill: parent }
        spacing: Theme.margin(2)

        Repeater {
            id: sortList

            Label {
                Layout.fillWidth: true
                Layout.preferredWidth: role_weight
                state: "body1"
                text: switch (role_role) {
                      case "role_name": return role_name
                      case "role_source": return role_source
                      case "role_created": return role_created
                      }
            }
        }
    }

    DividerLine {
        anchors { bottom: parent.bottom }
        orientation: Qt.Horizontal
    }

    MouseArea {
        anchors { fill: parent }

        onClicked: parent.selected ? presetsVM.deselectPreset() : presetsVM.selectPreset(role_uid)
    }
}
