import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import "../.."

Item {    
    signal thumbClicked(string roleId)

    Rectangle {
        anchors { fill: parent; topMargin: Theme.marginSize; bottomMargin: Theme.marginSize }
        radius: Theme.marginSize / 4
        color: Theme.black

        ImageThumbnail {
            anchors { fill: parent }
            source: "file:///" + encodeURIComponent(role_shotPath)
            fillMode: Image.PreserveAspectFit

            onThumbnailClicked: thumbClicked(role_Id)

            Rectangle {
                anchors { fill: parent }
                radius: 4
                color: Theme.transparent
                border { width: role_isSelected ? 4 : 0;
                    color: Theme.blue }
            }
        }

        Rectangle {
            visible: role_isR1 || role_isR2 || role_isSelected || role_isP1 || role_isP2
            width: label.width
            height: label.height
            radius: Theme.marginSize / 4
            color: Theme.blue

            Label {
                id: label
                state: "h6"
                padding: Theme.marginSize / 4
                color: Theme.black
                font.bold: true
                text: role_label
            }
        }

        Label {
            x: Theme.marginSize / 2
            anchors { bottom: parent.bottom; bottomMargin: Theme.marginSize / 2 }
            state: "h6"
            font.bold: true
            text: role_index.toString()
        }

        IconImage {
            visible: role_isDeleted || !role_isValid
            anchors { right: parent.right; bottom: parent.bottom; margins: Theme.marginSize / 2 }
            source: "qrc:/images/register-off.svg"
            sourceSize: Theme.iconSize
            color: Theme.red
        }
    }
}
