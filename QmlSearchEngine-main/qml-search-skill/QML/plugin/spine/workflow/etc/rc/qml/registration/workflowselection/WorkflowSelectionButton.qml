import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Rectangle {
    Layout.preferredWidth: Theme.margin(25)
    Layout.preferredHeight: Theme.margin(25)
    radius: 4
    border { width: selected ? 2 : 1; color: selected ? Theme.blue : Theme.navyLight }
    color: Theme.transparent

    property bool selected: false

    property alias text: label.text
    property alias icon: image.source

    signal clicked()
    signal infoPressed()

    Rectangle {
        anchors { fill: parent }
        color: selected ? Theme.blue : Theme.backgroundColor
        opacity: .16
    }

    ColumnLayout {
        anchors { centerIn: parent; verticalCenterOffset: Theme.margin(2) }
        spacing: Theme.margin(2)

        IconImage {
            id: image
            Layout.alignment: Qt.AlignHCenter
            sourceSize.width: Theme.margin(10)
            sourceSize.height: Theme.margin(10)
            color: {
                if(enabled)
                {
                    if(selected)
                    {
                        return Theme.blue
                    }
                    else
                    {
                        return Theme.white
                    }
                }
                else
                {
                    return Theme.disabledColor
                }
            }
        }

        Label {
            id: label
            Layout.alignment: Qt.AlignHCenter
            font { bold: true }
            state: "subtitle1"
            color: {
                if(enabled)
                {
                    return Theme.white
                }
                else
                {
                    return Theme.disabledColor
                }
            }
        }
    }

    MouseArea {
        anchors { fill: parent }

        onClicked: parent.clicked()
    }

    Button {
        anchors { top: parent.top; right: parent.right; topMargin: Theme.margin(1); rightMargin: Theme.margin(1)}
        state: "icon"
        icon.source: "qrc:/icons/info-circle-fill.svg"

        onClicked: parent.infoPressed()
    }
}
