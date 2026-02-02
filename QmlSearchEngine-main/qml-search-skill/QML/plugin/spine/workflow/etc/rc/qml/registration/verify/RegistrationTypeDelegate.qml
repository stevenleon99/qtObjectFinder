import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

Item {
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.margin(8)

    property alias name: label.text
    property alias score: regScore.score
    property alias scoreVisible: regScore.visible

    signal clicked()

    RowLayout {
        anchors { fill: parent; leftMargin: Theme.margin(2); rightMargin: Theme.margin(2) }
        spacing: 0

        Label {
            id: label
            Layout.fillWidth: true
            state: "body1"
            font.bold: true
            text: name
            color: mouseArea.pressed ? Theme.blue : Theme.white
        }

        RegistrationScore {
            id: regScore
            visible: scoreVisible
        }
    }

    MouseArea {
        id: mouseArea
        anchors { fill: parent }

        onClicked: parent.clicked()
    }
}
