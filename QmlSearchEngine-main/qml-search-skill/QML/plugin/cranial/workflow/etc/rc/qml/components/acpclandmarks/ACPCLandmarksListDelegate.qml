import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import ".."

RowLayout {
    spacing: Theme.marginSize

    property bool set: false
    property bool selected: false

    property alias text: label.text
    property alias icon: icon.source

    signal landmarkClicked()
    signal resetClicked()
    signal setClicked()

    states: [
        State {
            name: "set"
            when: set && !selected
            PropertyChanges { target: landmark; enabled: true; opacity: 1 }
            PropertyChanges { target: icon; color: Theme.blue }
        },
        State {
            extend: "set"
            when: set && selected
            PropertyChanges { target: landmark; border.color: Theme.blue; color: Theme.foregroundColor }
        }
    ]

    Rectangle {
        id: landmark
        enabled: false
        opacity: 0.25
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.marginSize * 3
        radius: 4
        border { width: 1; color: Theme.navyLight }
        color: Theme.transparent

        MouseArea {
            anchors { fill: parent }

            onClicked: landmarkClicked()
        }

        RowLayout {
            anchors { fill: parent }
            spacing: Theme.marginSize / 4

            Item {
                Layout.fillHeight: true
                Layout.preferredWidth: height

                IconImage {
                    id: icon
                    anchors { centerIn: parent }
                    source: role_source
                    sourceSize: Theme.iconSize
                    color: Theme.navyLight
                }
            }

            Label {
                id: label
                Layout.fillWidth: true
                state: "subtitle1"
                font.bold: true
            }

            Button {
                state: "icon"
                icon.source: "qrc:/icons/trash.svg"

                onClicked: resetClicked()
            }
        }
    }

    Button {
        state: "active"
        text: "Set"
        font.bold: true

        onClicked: setClicked()
    }
}
