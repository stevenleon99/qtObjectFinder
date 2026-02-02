import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

RowLayout {
    Layout.fillWidth: true
    spacing: Theme.marginSize

    property bool checked: false
    property string text
    property int index

    property alias iconSource: icon.source
    property alias color: icon.color

    states: [
        State {
            name: "info"
            PropertyChanges { target: check; color: Theme.transparent; border.color: Theme.transparent }
            PropertyChanges { target: icon; visible: true }
            PropertyChanges { target: label; state: "body1" }
        }
    ]

    Rectangle {
        id: check
        Layout.preferredWidth: Theme.marginSize * 2
        Layout.preferredHeight: Theme.marginSize * 2
        Layout.alignment: Qt.AlignVCenter
        radius: width / 2
        color: checked ? Theme.green : Theme.transparent
        border { width: 1; color: checked ? Theme.green : Theme.slate200 }

        IconImage {
            id: icon
            visible: checked
            anchors { centerIn: parent }
            sourceSize: Theme.iconSize
            source: "qrc:/icons/check-small.svg";
            color: Theme.black
        }

        Label {
            visible: !icon.visible && index
            anchors { centerIn: parent }
            state: "body1"
            text: index
        }
    }

    Label {
        id: label
        Layout.alignment: Qt.AlignVCenter
        Layout.preferredWidth: 456
        state: "subtitle1"
        wrapMode: Label.Wrap
        text: parent.text
    }
}
