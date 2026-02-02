import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Item {
    id: header
    opacity: enabled ? 1 : 0.25
    Layout.fillHeight: true
    Layout.preferredWidth: rowLayout.width

    property alias text: label.text
    property alias icon: icon
    property alias label: label

    property bool active: false
    property bool borderEnabled: true

    signal selected()
    
    Rectangle
    {
        visible: borderEnabled && active
        anchors { fill: rect }
        color: Theme.transparent
        border.color: Theme.blueLight500 
        border.width: 2
        radius: 5
    }

    Rectangle
    {
        visible: !borderEnabled && active
        anchors { bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
        width: parent.width
        height: 4
        color: Theme.blue
    }

    Rectangle {
        id: rect
        anchors { centerIn: parent }
        width: parent.width
        height: parent.height
        radius: 5
        opacity: 0.15
        color: active ? Theme.blue : Theme.transparent
    }


    RowLayout {
        id: rowLayout
        anchors { centerIn: parent }
        spacing: Theme.margin(1)

        IconImage {
            id: icon
            Layout.leftMargin: Theme.margin(2)
            sourceSize: Theme.iconSize
            color: active ? Theme.blue : Theme.navyLight
        }

        Label {
            id: label
            Layout.topMargin: 2
            Layout.rightMargin: Theme.margin(2)
            Layout.maximumWidth: header.width - icon.width - Theme.marginSize
            color: active ? Theme.white : Theme.navyLight
            state: "subtitle2"
        }
    }
    
    MouseArea {
        anchors { fill: parent }

        onClicked: selected()
    }
}
