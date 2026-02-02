import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import DriveEnums 1.0
import ViewModels 1.0

import "../components"

Popup {
    id: serviceUserPopup

    width: parent.width - Theme.margin(180)
    height: parent.height - Theme.margin(82)
    closePolicy: Popup.NoAutoClose

    modal: true
    Overlay.modal: Rectangle { color: Qt.rgba(0, 0, 0, 0.75) }

    contentItem: Rectangle {
        width: serviceUserPopup.width
        height: serviceUserPopup.height
        color: Theme.backgroundColor
        radius: Theme.margin(1)
        ColumnLayout {
            anchors {
                fill: parent
                margins: Theme.margin(4)
            }
            spacing: Theme.marginSize


            IconImage {
                Layout.alignment: Qt.AlignHCenter
                source: "qrc:/icons/tools.svg"
                sourceSize: Qt.size(106, 106)
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Service Login")
                state: "h4"
            }

            Label {
                Layout.alignment: Qt.AlignHCenter
                text: qsTr("Service login confirmed.")
                state: "h6"
                color: Theme.navyLight
            }
            
            RowLayout {
                id: layout
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.marginSize

                Button {
                    Layout.preferredWidth: 128
                    state: "available"
                    text: qsTr("Cancel")

                    onClicked: close()
                }
                
                Button {
                    Layout.preferredWidth: 128
                    state: "active"
                    text: qsTr("Login")
                    onClicked:  {
                        drivePageViewModel.currentPage = DrivePage.Patients;
                        if (driveMirrorViewModel.usingGPS && userViewModel.activeUser.isMirrorEnabled &&
                        (connectionsViewModel.connectedPeerType !== ConnectedPeerType.E3d))
                        {
                            console.log("Starting Mirror Server");
                            driveMirrorViewModel.startMirrorServer();
                        }
                        close();
                    }
                }

                Button {
                    Layout.preferredWidth: 128
                    leftPadding: Theme.margin(1)
                    rightPadding: Theme.margin(1)
                    state: "active"
                    text: qsTr("Exit Client")

                    onClicked: applicationViewModel.quitToAdmin()
                }
            }
        }
    }
}
