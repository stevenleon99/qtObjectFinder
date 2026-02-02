import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0

Rectangle {
    width: ListView.view.width
    height: Theme.margin(6)
    radius: Theme.margin(.5)
    color: Theme.transparent
    border { width: 1; color: selected ? Theme.blue : Theme.lineColor }

    property bool selected: false
    property alias verifiedIconVisible: verifiedIcon.visible
    property alias verifiedIconColor: verifiedIcon.color

    property alias text: label.text

    signal select()
    signal deletClicked()

    Rectangle {
        anchors { fill: parent }
        color: Theme.blue
        opacity: selected ? 0.16 : 0
        radius: Theme.margin(1)
    }

    MouseArea {
        anchors { fill: parent }
        onClicked: select()
    }

    RowLayout {
        anchors { fill: parent; leftMargin: Theme.marginSize }
        spacing: Theme.margin(1)

        Label {
            id: label
            Layout.fillWidth: true
            state: "subtitle2"
        }

        IconImage {
            id: verifiedIcon
            source: "qrc:/icons/register.svg"
            sourceSize: Theme.iconSize
        }

        Button {
            state: "icon"
            icon.source: "qrc:/icons/trash.svg"
            onClicked: deletClicked()
        }
    }
}
