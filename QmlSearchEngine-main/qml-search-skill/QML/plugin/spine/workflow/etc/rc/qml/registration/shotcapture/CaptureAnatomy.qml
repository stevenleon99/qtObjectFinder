import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import "../../components/centroid"

Rectangle {
    color: Theme.transparent
    radius: 4
    border {
        width: selected ? 2 : 1
        color: selected ? Theme.blue : Theme.navyLight
    }

    property bool selected: false

    signal anatomyClicked()

    Rectangle { visible: selected; anchors.fill: parent; opacity: 0.16; color: Theme.blue }

    RowLayout {
        anchors { fill: parent; leftMargin: Theme.marginSize; rightMargin: Theme.margin(1) }
        spacing: 0

        Label {
            Layout.fillWidth: true
            state: "h6"
            font { bold: true }
            text: role_anatomyName
            horizontalAlignment: Label.AlignLeft
        }

        RowLayout {
            Layout.fillHeight: true
            spacing: Theme.margin(1)

            Label {
                Layout.minimumWidth: label.width
                state: "subtitle1"
                color: Theme.green
                text: role_apShotIndex
                horizontalAlignment: Label.AlignRight

                IconImage {
                    visible: !role_apShotIndex
                    anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: -4 }
                    sourceSize: Theme.iconSize
                    color: Theme.red
                    source: "qrc:/icons/x.svg"
                }
            }

            Label {
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                state: "subtitle1"
                color: Theme.navy
                font { bold: true }
                text: qsTr("AP")
            }
        }

        RowLayout {
            Layout.fillHeight: true
            Layout.leftMargin: Theme.margin(1)
            spacing: Theme.margin(1)

            Label {
                Layout.minimumWidth: label.width
                state: "subtitle1"
                color: Theme.green
                text: role_latShotIndex
                horizontalAlignment: Label.AlignRight

                IconImage {
                    visible: !role_latShotIndex
                    anchors { right: parent.right; verticalCenter: parent.verticalCenter; rightMargin: -4 }
                    sourceSize: Theme.iconSize
                    color: Theme.red
                    source: "qrc:/icons/x.svg"
                }
            }

            Label {
                id: label
                state: "subtitle1"
                color: Theme.navy
                font { bold: true }
                text: qsTr("LAT")
            }
        }

        RowLayout {
            visible: role_displayCentroidPlaced
            Layout.leftMargin: Theme.marginSize
            spacing: 0

            IconImage {
                sourceSize: Theme.iconSize
                color: role_centroidPlaced ? Theme.green : Theme.red
                source: role_centroidPlaced ? "qrc:/icons/check.svg" : "qrc:/icons/x.svg"
            }

            IconImage {
                sourceSize: Theme.iconSize
                color: Theme.navy
                source: "qrc:/icons/register.svg"
            }
        }
    }

    DraggedCentroidMouseArea {
        anchors { fill: parent }
        anatomy: role_key
        dragEnabled: role_dragEnabled
        anatomyName: role_anatomyName

        onClicked: parent.anatomyClicked()
    }
}
