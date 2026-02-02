import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

Item {
    width: Theme.margin(40)
    height: Theme.margin(8)

    property string iconSource
    property bool selected: false

    property alias text: label.text

    signal itemSelected()

    Rectangle { visible: selected; anchors.fill: parent; radius: 4; color: Theme.blue; opacity: 0.16 }

    RowLayout {
        anchors {
            fill: parent
            leftMargin: Theme.margin(2)
            rightMargin: Theme.margin(2)
        }
        spacing: Theme.margin(1)

        Item {
            Layout.preferredHeight: Theme.margin(4)
            Layout.preferredWidth: Theme.margin(4)
            IconImage {
                visible: iconSource
                anchors { centerIn: parent }
                sourceSize: Theme.iconSize
                source: iconSource
                color: selected ? Theme.blue : Theme.navy
            }
        }

        Label {
            id: label
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: true
            state: "button1"
            elide: Text.ElideRight
            verticalAlignment: Label.AlignVCenter
        }

        LayoutSpacer {}
    }

    MouseArea {
        anchors.fill: parent
        onClicked: parent.itemSelected()
    }
}
