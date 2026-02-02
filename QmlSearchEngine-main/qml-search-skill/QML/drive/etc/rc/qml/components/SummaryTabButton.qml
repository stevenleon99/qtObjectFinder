import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

TabButton {
    id: tabButton
    
    height: parent.height
    anchors { verticalCenter: parent.verticalCenter }

    property string name: ""
    property int thumbnailCount: 0

    contentItem: Item {
        RowLayout {
            anchors { centerIn: parent }
            spacing: Theme.marginSize
            Label {
                horizontalAlignment: Text.AlignHCenter
                color: tabButton.checked ? Theme.white : Theme.navyLight
                font { pixelSize: 21; bold: true }
                text: name
            }
            Rectangle {
                visible: tabButton.state == "images"
                width: Theme.margin(5)
                height: Theme.margin(4)
                radius: width/2
                color: Theme.slate700

                Label {
                    anchors { centerIn: parent }
                    state: "subtitle1"
                    color: tabButton.checked ? Theme.white : Theme.navyLight
                    text: thumbnailCount
                }
            }
        }
    }
    background: Item {
        Rectangle {
            visible: tabButton.checked
            width: parent.width
            height: 3
            anchors { bottom: parent.bottom }
            color: Theme.blue
        }
    }
}
