import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Item {
    width: Theme.margin(17)
    height: Theme.margin(6)

    property bool implantEnabled: false
    property bool assigned: false
    property int assignmentNumber: 0
    property int orientation: ImplantSelection.Orientation.Center

    property alias text: label.text
    property alias color: circle.color

    objectName: "implantSelection_"+label.text

    enum Orientation {
        Left,
        Right,
        Center
    }

    signal clicked()

    MouseArea {
        enabled: implantEnabled
        anchors { fill: parent }

        onClicked: parent.clicked()
    }

    Rectangle {
        id: background
        opacity: implantEnabled ? 1.0 : 0.5
        radius: 4
        anchors { fill: parent }
        border { width: 2; color: implantEnabled && assigned ? Theme.blue : Theme.navyLight }
        color: Theme.slate500
    }

    RowLayout {
        anchors { centerIn: parent }
        layoutDirection: orientation === ImplantSelection.Orientation.Right ? Qt.RightToLeft : Qt.LeftToRight
        spacing: Theme.margin(1)

        IconImage {
            id: icon
            visible: !assigned
            sourceSize: Theme.iconSize
            source: "qrc:/icons/plus.svg"
            color: Theme.white
        }

        Rectangle {
            id: circle
            visible: assigned
            Layout.preferredWidth: Theme.marginSize * 2
            Layout.preferredHeight: Theme.marginSize * 2
            radius: width / 2

            Label {
                state: "h6"
                anchors { centerIn: parent }
                font { bold: true }
                text: assignmentNumber
                color: Theme.black
            }
        }

        Label {
            id: label
            state: "h6"
            font.bold: true
            color: implantEnabled || !assigned ? Theme.white : Theme.navyLight
        }
    }
}
