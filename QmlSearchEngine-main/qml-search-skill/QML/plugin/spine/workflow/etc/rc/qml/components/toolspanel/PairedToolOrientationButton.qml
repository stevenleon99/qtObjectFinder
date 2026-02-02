import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import "../../components"

Rectangle {
    Layout.preferredWidth: Theme.margin(14.5)
    Layout.preferredHeight: Theme.margin(6)
    color: Theme.transparent
    border.color: Theme.navyLight
    radius: 4

    property string positionIcon
    property alias positionText: orientationText.text
    property alias positionRotation: orientationIcon.rotation

    signal clicked()

    RowLayout {
        anchors { centerIn: parent }
        spacing: 4

        Label {
            id: orientationText
            Layout.preferredWidth: Theme.margin(2)
            state: "body1"
        }

        IconImage {
            id: orientationIcon
            visible: positionIcon
            source: positionIcon
            sourceSize: Theme.iconSize
            color: Theme.transparent
        }

        IconImage {
            source: "qrc:/icons/rotate-around-cw.svg"
            sourceSize: Theme.iconSize
            color: Theme.white
        }
    }

    MouseArea {
        anchors { fill: parent }
        onClicked: parent.clicked()
    }
}

