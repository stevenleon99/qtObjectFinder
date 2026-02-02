import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Shapes 1.12

import Theme 1.0

import Enums 1.0

import ".."

DottedRectangle {
    id: pairingDelegate
    Layout.columnSpan: 1
    Layout.preferredHeight: Theme.margin(6)
    solidBorder: loaded
    borderColor: selected ? Theme.blue : Theme.lineColor

    property bool selected: false
    property bool loaded: false
    property string iconSource: ""
    property color iconColor: Theme.white
    property alias arrayIndex: indexText.text
    property alias displayArrayIndex: indexText.visible
    property alias toolTypeDisplayName: toolTypeText.text

    signal clicked()

    MouseArea {
        anchors { fill: parent }

        onClicked: parent.clicked()
    }

    Rectangle {
        visible: selected
        opacity: 0.16
        anchors { fill: parent }
        radius: 4
        color: Theme.blue
    }

    RowLayout {
        anchors { fill: parent; margins: Theme.margin(1) }
        spacing: Theme.margin(1)

        IconImage {
            id: icon
            visible: iconSource
            Layout.leftMargin: Theme.margin(1)
            sourceSize: Theme.iconSize
            source: iconSource
            color: iconColor

            Label {
                id: indexText
                anchors.centerIn: parent
                state: "button1"
            }
        }

        Label {
            id: toolTypeText
            Layout.fillWidth: true
            state: "body2"
        }
    }
}
