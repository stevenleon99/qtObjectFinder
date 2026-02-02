import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

Item {
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.margin(8)

    property string name
    property string iconPath
    property bool selected: false
    property bool displayIcon: true
    property color iconColor: Theme.navyLight

    signal clicked()

    RowLayout {
        anchors { fill: parent }
        spacing: 0

        Item {
            Layout.preferredWidth: height
            Layout.fillHeight: true

            IconImage {
                visible: displayIcon
                anchors { centerIn: parent }
                sourceSize: Theme.iconSize
                color: selected || mouseArea.pressed ? Theme.blue : iconColor
                source: iconPath
            }
        }

        Label {
            Layout.fillWidth: true
            state: "body1"
            font.bold: true
            text: name
            color: mouseArea.pressed ? Theme.blue : Theme.white
        }
    }

    MouseArea {
        id: mouseArea
        anchors { fill: parent }

        onClicked: parent.clicked()
    }

    Rectangle {
        id: selectedRect
        visible: selected
        color: Theme.blue
        opacity: 0.16
        anchors { fill: parent }
        z: -1
    }
}
