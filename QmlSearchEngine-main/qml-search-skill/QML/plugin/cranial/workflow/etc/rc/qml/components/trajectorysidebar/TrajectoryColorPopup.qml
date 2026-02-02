import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import ".."

Popup {
    width: layout.width
    height: layout.height

    background: Rectangle { radius: Theme.margin(1); color: Theme.backgroundColor }

    property color selectedColor

    signal colorSelected(color color)

    function setup(positionItem) {
        var bottomRight = positionItem.mapToItem(null, positionItem.width, positionItem.height)
        x = bottomRight.x - width
        y = bottomRight.y
        open()
    }

    ColumnLayout {
        id: layout
        spacing: 0

        RowLayout {
            Layout.margins: spacing
            spacing: Theme.margin(2)

            Label {
                Layout.fillWidth: true
                state: "subtitle1"
                text: qsTr("Trajectory Color")
            }

            Button {
                state: "icon"
                icon.source: "qrc:/icons/x.svg"
                color: Theme.navyLight

                onClicked: close()
            }
        }

        DividerLine { }

        GridLayout {
            Layout.margins: rowSpacing
            columns: Theme.trajectoriesColorList.length / 3
            rowSpacing: Theme.margin(2)
            columnSpacing: rowSpacing

            Repeater {
                model: Theme.trajectoriesColorList

                Rectangle {
                    id: colorOption
                    width: Theme.margin(6)
                    height: width
                    radius: Theme.margin(0.5)
                    border { width: 4 * colorOption.selected; color: colorOption.selected ? Theme.blue : Theme.white }
                    color: modelData

                    property bool selected: selectedColor === modelData

                    MouseArea {
                        anchors { fill: parent }

                        onClicked: colorSelected(modelData)
                    }
                }
            }
        }
    }
}
