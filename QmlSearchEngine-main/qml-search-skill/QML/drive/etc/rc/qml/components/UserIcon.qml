import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

Item {

    property string iconText
    property string iconColor
    property string textColor

    Rectangle {
        radius: height / 2
        anchors { fill: parent }
        color: iconColor ? iconColor : Theme.black

        Label {
            id: label
            anchors { centerIn: parent }
            state: "h6"
            font.bold: true
            color: textColor ? textColor : Theme.white
            text: iconText
        }
    }

    Image {
        visible: !iconText
        anchors { centerIn: parent }
        source: "qrc:/icons/man.svg"
    }

    states: [
        State {
            name: "login"
            PropertyChanges { target: label; state: "h3" }
        },
        State {
            name: "user"
            PropertyChanges { target: label; state: "h5" }
        }
    ]
}
