import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0


ColumnLayout {
    id: workflowSelectionButton
    spacing: Theme.marginSize

    property bool showInfoButton: true
    property alias text: label.text
    property alias imageIcon: image.source
    property bool isCompleted: false
    property bool isCurrent: false
    property bool isSelected: false

    signal clicked()
    signal infoPressed()

    Item {
        Layout.preferredHeight: Theme.margin(25)
        Layout.preferredWidth: Theme.margin(25)

        Rectangle {
                id: mainArea
                anchors.fill: parent

                radius: 4
                border.width: isSelected? 2 : 1
                border.color: isSelected? Theme.blue : Theme.navyLight
                color: isSelected? Theme.blue: Theme.transparent
                opacity: isSelected? 0.16 : 1

                MouseArea {
                    id: mainMouseArea
                    anchors { fill: parent }
                    onClicked:
                        workflowSelectionButton.clicked()
                }
        }

        ColumnLayout {
                anchors { centerIn: parent; verticalCenterOffset: Theme.margin(2) }
                spacing: Theme.marginSize

                IconImage {
                    id: image
                    Layout.alignment: Qt.AlignHCenter
                    sourceSize.width: Theme.margin(10)
                    sourceSize.height: Theme.margin(10)
                    color: isSelected ? Theme.blue : Theme.white
                }

                Label {
                    id: label
                    Layout.alignment: Qt.AlignHCenter
                    font { bold: true }
                    state: "subtitle1"
                }
            }

            Button {
                anchors { top: parent.top; right: parent.right; topMargin: Theme.margin(1); rightMargin: Theme.margin(1)}
                state: "icon"
                icon.source: "qrc:/icons/info-circle-fill.svg"

                onClicked: workflowSelectionButton.infoPressed()
                visible: workflowSelectionButton.showInfoButton
            }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: 10

        Rectangle
        {
            visible: isCurrent
            width: 76
            height: 32

            color: Qt.rgba(Theme.blue.r,Theme.blue.g,Theme.blue.b,0.16)
            radius: 4

            Label
            {
                anchors { centerIn: parent }
                state: "subtitle2"
                font.bold: true
                text: qsTr("Current")
                color: Theme.blue
            }
        }

        Rectangle
        {
            visible: isCompleted
            width: 94
            height: 32

            color: Qt.rgba(Theme.green.r,Theme.green.g,Theme.green.b,0.16)
            radius: 4

            Label
            {
                anchors { centerIn: parent }
                state: "subtitle2"
                font.bold: true
                text: qsTr("Complete")
                color: Theme.green
            }
        }

    }
}
            

        
