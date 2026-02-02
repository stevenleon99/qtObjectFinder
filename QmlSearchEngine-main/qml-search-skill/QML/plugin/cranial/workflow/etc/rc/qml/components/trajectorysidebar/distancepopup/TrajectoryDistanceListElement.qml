import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

Rectangle {
    height: Theme.marginSize * 3
    radius: 4

    color: role_active ? Theme.headerColor : Theme.transparent
    border { width: role_active ? 2 : 1;
             color: role_active ? Theme.blue : Theme.navyLight }

    MouseArea {
        anchors { fill: parent }
        onClicked: trajectoryViewModel.setActiveTrajectory(role_id)
    }

    RowLayout {
        id: elementLayoutId
        anchors { fill: parent }
        spacing: Theme.marginSize / 2

        Item {
            id: trajIcon
            Layout.fillHeight: true
            Layout.preferredWidth: height

            IconImage {
                anchors { centerIn: parent }
                source: "qrc:/icons/laser.svg"
                sourceSize: Qt.size(parent.height / 2, parent.height / 2)
                color: role_cadColor
            }
        }

        Label {
            Layout.preferredWidth: parent.width - trajIcon.width - distanceValues.width - Theme.margin(5)
            state: "h6"
            color: role_active ? Theme.white : Theme.headerTextColor
            text: role_name
            elide: Text.ElideRight
        }

        LayoutSpacer { }

        RowLayout {
            id: distanceValues
            Layout.rightMargin: Theme.marginSize
            spacing: 0

            Label {
                state: "body1"
                font.bold: true
                color: Theme.blue
                text: role_implantLength.toFixed(1)
            }

            Label {
                state: "body1"
                color: Theme.lineColor
                text: " | "
            }

            Label {
                state: "body1"
                font.bold: true
                color: role_eeTopToEntryMm < 0 ? Theme.red : Theme.green
                text: role_eeTopToEntryMm.toFixed(1)
            }

            Label {
                state: "body1"
                color: Theme.lineColor
                text: " | "
            }

            Label {
                state: "body1"
                font.bold: true
                color: role_eeBottomToEntryMm < 0 ? Theme.red : Theme.yellow
                text: role_eeBottomToEntryMm.toFixed(1)
            }
        }
    }
}

