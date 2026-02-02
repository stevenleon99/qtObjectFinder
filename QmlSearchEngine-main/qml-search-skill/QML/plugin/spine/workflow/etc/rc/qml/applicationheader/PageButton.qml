import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

import ".."

Rectangle {
    id: pageButton
    implicitWidth: contentItem.width + (Theme.marginSize * 2)
    color: Theme.transparent

    property bool active: false

    property alias source: icon.source
    property alias text: label.text

    signal clicked()

    states: [
        State {
            when: active
            PropertyChanges { target: icon; color: Theme.blue }
            PropertyChanges { target: label; color: Theme.white; font.bold: true }
            PropertyChanges { target: bar; visible: true }
        },
        State {
            when: !enabled
            PropertyChanges { target: pageButton; opacity: 0.25 }
        }
    ]

    Rectangle {
        visible: parent.active
        anchors { fill: parent }
        color: Theme.blue
        opacity: 0.1
    }

    RowLayout {
        id: contentItem
        anchors { centerIn: parent }
        spacing: Theme.marginSize / 2

        IconImage {
            id: icon
            color: Theme.navyLight
            sourceSize: Theme.iconSize
        }

        Label {
            id: label
            state: "subtitle1"
            color: Theme.navyLight
            font.bold: true
        }
    }

    Rectangle {
        id: bar
        visible: false
        width: parent.width
        height: 4
        anchors { bottom: parent.bottom }
        color: Theme.blue
    }

    MouseArea {
        id: mouseArea
        anchors { fill: parent }

        onClicked: parent.clicked()
    }
}
