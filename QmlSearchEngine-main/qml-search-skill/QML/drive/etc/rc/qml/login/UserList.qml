import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import "../components"

Flow {
    Layout.preferredWidth: Theme.margin(218)
    spacing: Theme.margin(4)

    property alias model: repeater.model
    readonly property alias count: repeater.count

    Repeater {
        id: repeater

        delegate: Rectangle {
            objectName: "autoUserItem_" + index
            radius: 8
            width: Theme.margin(70)
            height: Theme.margin(18)
            border {
                width: (userViewModel.activeUser.uuid === role_uuid) ? 4 : 1;
                color: (userViewModel.activeUser.uuid === role_uuid) ? Theme.blue : Theme.white
            }
            color: Theme.transparent

            MouseArea {
                objectName: "autoUserItemMouseArea"
                anchors { fill: parent }
                onClicked: {
                    userViewModel.setActiveUser(role_uuid);
                    loader.state = "pinpad";
                }
            }

            RowLayout {
                anchors { fill: parent }
                spacing: 0

                Item {
                    Layout.fillHeight: true
                    Layout.preferredWidth: height

                    UserIcon {
                        width: 80
                        height: 80
                        anchors { centerIn: parent }
                        iconColor: role_color
                        iconText: role_initials
                        textColor: role_serviceAccess ? Theme.white : Theme.black
                    }
                }

                RowLayout {
                    Layout.rightMargin: Theme.marginSize
                    spacing: 0

                    ColumnLayout {
                        Label {
                            objectName: "autoUserItemUserName"
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            state: "h5"
                            font.bold: true
                            text: role_name
                        }
                        Label {
                            objectName: "autoUserItemDate"
                            property var lastUsedDate: Date.fromLocaleString(Qt.locale(), role_lastUsed, "yyyy-MM-dd_HH:mm:ss")
                            property var lastUsedVal: qsTr("Last Used: ") + lastUsedDate.toLocaleString(Qt.locale(), "dd-MMM-yyyy").toUpperCase()
                            property var expirationVal: qsTr("Expires: ") + role_expiration
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                            font.pixelSize: 21
                            text: role_serviceAccess ? expirationVal : lastUsedVal
                        }
                    }
                }
            }
        }
    }
}
