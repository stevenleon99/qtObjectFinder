import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

TabBar {
    id: detailsTabBar
    Layout.fillWidth: true

    property int thumbnailCount: 0

    TabButton {
        id: detailsTab
        objectName: "detailsTabBtn"
        height: detailsTabBar.height
        anchors { verticalCenter: parent.verticalCenter }
        contentItem: Label {
            anchors { centerIn: parent }
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            color: detailsTab.checked ? Theme.white : Theme.navyLight
            font { pixelSize: 21; bold: true }
            text: qsTr("Details")
        }
        background: Item {
            height: detailsTabBar.height
            Rectangle {
                visible: detailsTab.checked
                width: parent.width
                height: 3
                anchors { bottom: parent.bottom }
                color: Theme.blue
            }
        }
    }

    TabButton {
        id: thumbnailsTab
        objectName: "thumbnailsTabBtn"
        enabled: thumbnailCount > 0
        opacity: enabled ? 1 : 0.5
        height: detailsTabBar.height
        anchors { verticalCenter: parent.verticalCenter }
        contentItem: Item {
            RowLayout {
                anchors { centerIn: parent }
                spacing: Theme.marginSize
                Label {
                    horizontalAlignment: Text.AlignHCenter
                    color: thumbnailsTab.checked ? Theme.white : Theme.navyLight
                    font { pixelSize: 21; bold: true }
                    text: qsTr("Images")
                }
                Rectangle {
                    width: 40; height: 32; radius: width/2; color: Theme.slate700;

                    Label {
                        anchors { centerIn: parent }
                        color: thumbnailsTab.checked ? Theme.white : Theme.navyLight
                        font.pixelSize: 21
                        text: thumbnailCount
                    }
                }
            }
        }
        background: Item {
            Rectangle {
                visible: thumbnailsTab.checked
                width: parent.width
                height: 3
                anchors { bottom: parent.bottom }
                color: Theme.blue
            }
        }
    }

    background: Item {
        Rectangle {
            width: parent.width
            height: 1
            anchors { bottom: parent.bottom }
            color: Theme.navyLight
        }
    }
}
