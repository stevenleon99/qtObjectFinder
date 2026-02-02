import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

import "cranialheader"

Rectangle {
    height: Theme.marginSize * 4
    color: Theme.headerColor

    RowLayout {
        height: parent.height
        anchors { left: parent.left }
        spacing: Theme.marginSize

        Image {
            source: "qrc:/icons/icon.png"
        }

        CranialHeader { }
    }

    RowLayout {
        height: parent.height
        anchors { right: parent.right }
        spacing: 0

        Button {
            icon.source: "qrc:/icons/battery/battery.svg"
            state: "icon"
        }

        Button {
            icon.source: "qrc:/icons/notification.svg"
            state: "icon"
        }

        Button {
            icon.source: "qrc:/icons/screenshot.svg"
            state: "icon"
        }

        Button {
            icon.source: "qrc:/icons/settings.svg"
            state: "icon"
        }

        Button {
            icon.source: "qrc:/icons/exit.svg"
            state: "icon"

            onClicked: Qt.quit()
        }
    }
}
