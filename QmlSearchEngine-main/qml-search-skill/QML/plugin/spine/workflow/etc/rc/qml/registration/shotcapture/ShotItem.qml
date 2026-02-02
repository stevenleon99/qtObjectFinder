import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import Enums 1.0

Rectangle {
    radius: 4
    color: selected ? Theme.blue : Theme.transparent

    property bool selected: false

    signal thumbClicked()

    Rectangle {
        anchors { fill: parent; margins: 4 }
        radius: Theme.marginSize / 4
        color: Theme.black

        MouseArea {
            anchors.fill: parent
            onClicked: thumbClicked()
        }

        Image {
            anchors { fill: parent }
            source: "file:///" + encodeURIComponent(role_shotPath)
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            visible: role_shotDirectionLabel
            anchors { left: parent.left; top: parent.top; margins: 4 }
            width: label.width
            height: label.height
            radius: Theme.marginSize / 4
            color: Theme.blue

            Label {
                id: label
                state: "button1"
                padding: Theme.marginSize / 4
                font.bold: true
                text: role_shotDirectionLabel
            }
        }

        Item {
            width: infoRow.width
            height: infoRow.height
            anchors { left: parent.left; bottom: parent.bottom }

            Rectangle { anchors.fill: parent; radius: 4; color: Theme.black; opacity: 0.64 }

            RowLayout {
                id: infoRow
                spacing: 0
                Label {
                    state: "h5"
                    leftPadding: 6
                    rightPadding: 6
                    font.bold: true
                    text: role_captureIndex
                }

                IconImage {
                    visible: role_refresh
                    Layout.alignment: Qt.AlignBottom
                    Layout.rightMargin: 6
                    Layout.bottomMargin: 6
                    color: Theme.navyLight
                    source: "qrc:/icons/refresh.svg"
                    sourceSize: Qt.size(24, 24)
                }

                IconImage {
                    visible: role_movement
                    Layout.alignment: Qt.AlignBottom
                    Layout.rightMargin: 6
                    Layout.bottomMargin: 6
                    color: Theme.yellow
                    source: "qrc:/images/motion2.svg"
                    rotation: -90
                    sourceSize: Qt.size(24, 24)
                }
            }
        }

        Item {
            visible: (role_shotStatusSeverity == ShotStatusSeverity.Failure)
            width: Theme.margin(4)
            height: width
            anchors { right: parent.right; bottom: parent.bottom }

            Rectangle { anchors.fill: parent; radius: 4; color: Theme.black; opacity: 0.64 }

            IconImage {
                anchors { centerIn: parent }
                color: Theme.red
                source: "qrc:/icons/image-multiple"
                sourceSize: Qt.size(24, 24)
            }
        }
    }
}
