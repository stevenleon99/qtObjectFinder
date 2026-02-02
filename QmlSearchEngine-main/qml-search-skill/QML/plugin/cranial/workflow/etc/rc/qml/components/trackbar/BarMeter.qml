import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0

Rectangle {
    //visible: text
    Layout.preferredWidth: Theme.margin(20)
    Layout.preferredHeight: Theme.margin(4)
    radius: 4
    color: Theme.slate900

    opacity: enabled? 1 : .32

    property double value: 0.0
    property alias text: label.text
    property bool clearable: false
    property bool plusButtonEnabled: false
    property bool enabled: true

    signal cleared()
    signal plusButtonClicked()

    Label {
        id: label
        x: Theme.margin(1)
        anchors { verticalCenter: parent.verticalCenter }
        state: "body1"
        font.bold: true
    }

    Rectangle {
        width: Math.min(parent.width * value, parent.width)
        height: parent.height
        radius: 4
        clip: true
        color: width > parent.width * (2 / 3) ? Theme.red
                                              : width > parent.width * (1 / 3) ? Theme.yellow
                                                                               : Theme.green

        Label {
            x: Theme.margin(1)
            anchors { verticalCenter: parent.verticalCenter }
            state: "body1"
            color: Theme.black
            font.bold: true
            text: label.text
        }
    }

    Button {
        visible: clearable
        anchors { right: parent.right; rightMargin: -Theme.margin(1); verticalCenter: parent.verticalCenter }
        state: "icon"
        icon.source: "qrc:/icons/x"

        onClicked: cleared()
    }

    Button {
        visible: plusButtonEnabled && !clearable
        anchors { right: parent.right; rightMargin: -Theme.margin(1); verticalCenter: parent.verticalCenter }
        state: "icon"
        icon.source: "qrc:/icons/plus"

        onClicked: plusButtonClicked()
    }
}
