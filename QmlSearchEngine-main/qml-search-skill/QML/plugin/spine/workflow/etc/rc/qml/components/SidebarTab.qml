import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

Rectangle {
    Layout.fillWidth: true
    Layout.fillHeight: true
    color: active ? Theme.backgroundColor : Theme.slate800

    property bool active: false
    property bool lastTab: false

    property alias source: iconImage.source
    property alias text: label.text

    signal clicked()

    ColumnLayout {
        anchors { centerIn: parent }
        spacing: 3

        IconImage {
            id: iconImage
            Layout.alignment: Qt.AlignHCenter
            sourceSize: Theme.iconSize
            color: active ? Theme.blue : Theme.navyLight
        }

        Label {
            id: label
            state: "body1"
            color: active ? Theme.white : Theme.navyLight
        }
    }

    DividerLine {
        visible: active
        color: Theme.lineColor
    }

    DividerLine {
        visible: active && !lastTab
        anchors { right: parent.right }
        color: Theme.lineColor
    }

    Rectangle {
        width: active ? parent.width - Theme.margin(4) : parent.width
        height: active ? 2 : 1
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
        color: active ? Theme.blue : Theme.lineColor
    }

    MouseArea {
        anchors { fill: parent }

        onClicked: parent.clicked()
    }
}
