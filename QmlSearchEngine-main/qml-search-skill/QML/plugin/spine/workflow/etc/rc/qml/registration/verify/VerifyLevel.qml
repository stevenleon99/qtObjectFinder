import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

Rectangle {
    color: Theme.transparent
    radius: 4
    border {
        width: selected ? 2 : 1
        color: selected ? Theme.blue : Theme.navyLight
    }

    property alias scoreDisplayed: regScore.visible
    property bool selected: false

    signal levelClicked()

    Rectangle { visible: selected; anchors.fill: parent; opacity: 0.16; color: Theme.blue }

    RowLayout {
        anchors { fill: parent; leftMargin: Theme.marginSize; rightMargin: Theme.margin(1) }
        spacing: Theme.marginSize

        Label {
            Layout.fillWidth: true
            state: "h6"
            font { bold: true }
            text: role_anatomyName
            horizontalAlignment: Label.AlignLeft
        }

        LayoutSpacer {}

        IconImage {
            sourceSize: Theme.iconSize
            color: role_verified ? Theme.green : Theme.slate400
            source: "qrc:/icons/check.svg"
        }

        RegistrationScore {
            id: regScore
            score: role_regScore
        }
    }

    MouseArea {
        anchors { fill: parent }
        onClicked: parent.levelClicked()
    }
}
