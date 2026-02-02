import QtQuick 2.11
import QtQuick.Controls 2.5

import Theme 1.0

Item {
    height: width / 2
    clip: true

    property alias text: label.text
    property alias value: rotatedItem.rotation

    Rectangle {
        width: parent.width
        height: width
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.bottom }
        radius: width / 2
        color: Theme.backgroundColor
    }

    Rectangle {
        id: midCircle
        width: parent.width * 0.90
        height: width
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.bottom }
        radius: width / 2
        color: Theme.foregroundColor
    }

    Item {
        id: rotatedItem
        height: midCircle.height / 2
        width: midCircle.width + 1
        anchors { horizontalCenter: parent.horizontalCenter; top: parent.bottom }
        transformOrigin: Item.Top
        clip: true

        Rectangle {
            id: rotatedCircle
            width: parent.width
            height: width
            anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.top }
            radius: width / 2
            color: "transparent"
            states: [
                State {
                    name: "good"
                    when: rotatedItem.rotation <= 60
                    PropertyChanges { target: rotatedCircle; color: Theme.green }
                },
                State {
                    name: "caution"
                    when: rotatedItem.rotation <= 120
                    PropertyChanges { target: rotatedCircle; color: Theme.yellow }
                },
                State {
                    name: "bad"
                    when: rotatedItem.rotation <= 180
                    PropertyChanges { target: rotatedCircle; color: Theme.red }
                }
            ]
        }
    }

    Rectangle {
        width: parent.width * 0.80
        height: width
        anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.bottom }
        radius: width / 2
        color: Theme.backgroundColor

        Label {
            id: label
            font { pixelSize: 20; bold: true }
            anchors { bottom: parent.verticalCenter; horizontalCenter: parent.horizontalCenter; bottomMargin: 20 }
        }
    }
}
