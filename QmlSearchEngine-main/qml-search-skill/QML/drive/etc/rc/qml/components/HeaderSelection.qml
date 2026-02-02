import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4

import Theme 1.0

Item {
    id: header
    objectName: "autoHeader_"+label.text
    opacity: enabled ? 1 : 0.25
    Layout.fillHeight: true
    Layout.preferredWidth: label.implicitWidth + icon.implicitWidth + Theme.marginSize * 3

    property alias bar: bar
    property alias text: label.text
    property alias icon: icon
    property alias label: label

    property bool active: false

    signal selected()

    RowLayout {
        anchors { centerIn: parent }
        spacing: Theme.margin(1)

        IconImage {
            id: icon
            sourceSize: Theme.iconSize
            color: active ? Theme.blue : Theme.navyLight
        }

        Label {
            id: label
            Layout.topMargin: 2
            Layout.maximumWidth: header.width - icon.width - Theme.marginSize
            color: active ? Theme.white : Theme.navyLight
            state: "body1"
            font.styleName: Theme.mediumFont.styleName
        }
    }

    Rectangle {
        id: bar
        visible: active
        width: parent.width
        height: 4
        color: Theme.blue
        anchors { bottom: parent.bottom }
    }

    MouseArea {
        anchors { fill: parent }

        onClicked: selected()
    }
}
