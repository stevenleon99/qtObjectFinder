import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import DriveEnums 1.0
import Theme 1.0
import GmQml 1.0

Popup {
    width: Theme.margin(40)
    height: layout.height
    modal: false
    dim: false

    background: Rectangle { radius: 4; color: "#0E161B" }

    function switchToPage(page) {
        if (settingsPluginLoader.active) {
            settingsPluginLoader.active = false
        }

        if (page === DrivePage.Login)
        {
            userViewModel.updateLastUsedDate();
            if (driveMirrorViewModel.usingGPS && driveMirrorViewModel.serverSetup
            && (connectionsViewModel.connectedPeerType !== ConnectedPeerType.E3d))
            {
                console.log("Stopping Mirror Server")
                driveMirrorViewModel.stopMirrorServer();
            }

            console.log("Logging out user " + userViewModel.loggedInUserName);
        }

        drivePageViewModel.currentPage = page
        close()
    }

    ColumnLayout {
        id: layout
        width: parent.width
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize

            ColumnLayout {
                width: parent.width
                anchors { verticalCenter: parent.verticalCenter }
                spacing: 0

                Label {
                    Layout.fillWidth: true
                    state: "body1"
                    color: Theme.navyLight
                    text: qsTr("User")
                }

                Label {
                    Layout.fillWidth: true
                    state: "h6"
                    text: userViewModel.loggedInUserName
                }
            }
        }

        DividerLine { color: Theme.slate600 }

        Repeater {
            model: ListModel {
                ListElement { role_page: DrivePage.Cases; role_icon: "qrc:/icons/x.svg"; role_text: "Exit Case" }
                ListElement { role_page: DrivePage.Login; role_icon: "qrc:/icons/exit-left.svg"; role_text: "Log Out" }
            }

            Item {
                objectName: "userDropDownItem_"+role_text
                visible: index || drivePageViewModel.currentPage === DrivePage.Workflow
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(7)

                RowLayout {
                    anchors { fill: parent }
                    spacing: 0

                    Item {
                        Layout.preferredWidth: height
                        Layout.fillHeight: true

                        IconImage {
                            anchors { centerIn: parent }
                            source: role_icon
                            sourceSize: Theme.iconSize
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        state: "body1"
                        font.bold: true
                        text: role_text
                    }
                }

                MouseArea {
                    objectName: role_text === "Exit Case" ? "exitCaseButton" : "logOutButton" 
                    anchors { fill: parent }

                    onClicked: switchToPage(role_page)
                }
            }
        }
    }
}
