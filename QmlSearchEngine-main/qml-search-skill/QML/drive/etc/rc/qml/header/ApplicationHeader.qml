import "../components"
import DriveEnums 1.0
import GmQml 1.0
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Layouts 1.12
import Theme 1.0

Rectangle {
    height: Theme.marginSize * 4
    color: Theme.headerColor
    onVisibleChanged: {
        if (!visible && userDropdown.opened)
            userDropdown.close()

    }

    RowLayout {
        spacing: 14

        anchors {
            fill: parent
            rightMargin: Theme.marginSize / 2
        }

        Image {
            source: "qrc:/icons/icon.png"
        }

        Loader {
            visible: !settingsPluginLoader.active
            active: drivePageViewModel.currentPage === DrivePage.Workflow
            Layout.fillWidth: true
            Layout.fillHeight: true
            source: "qrc:/drive/qml/workflow/WorkflowHeader.qml"
        }

        LayoutSpacer {
            visible: settingsPluginLoader.active
        }

        RowLayout {
            spacing: Theme.marginSize * 0.75

            PatientName {
                visible: patientSelected && drivePageViewModel.currentPage !== DrivePage.Patients
            }

            // display upon active mirroring session
            IconButton {
                id: activeMirroringIconBtn

                visible: driveMirrorViewModel.usingGPS && driveMirrorViewModel.activeMirroring && (connectionsViewModel.connectedPeerType !== ConnectedPeerType.E3d)
                source: "qrc:/icons/mirror-screens.svg"
                sourceSize: Theme.iconSize
                onClicked: driveMirrorViewModel.disconnectConnectedClient()
            }

            // display on active connection and enabled mirroring service
            IconButton {
                id: disconnectedMirroringIconBtn

                visible: ((connectionsViewModel.glinkConnectionState == GLinkConnectionState.Connected) && ((driveMirrorViewModel.usingGPS && userViewModel.activeUser.isMirrorEnabled && !driveMirrorViewModel.activeMirroring) || driveMirrorViewModel.usingLaptop)) || (driveMirrorViewModel.usingGPS && connectionsViewModel.connectedPeerType === ConnectedPeerType.E3d)
                enabled: (driveMirrorViewModel.usingGPS && (connectionsViewModel.connectedPeerType === ConnectedPeerType.E3d && !driveMirrorViewModel.clientConnecting)) || !driveMirrorViewModel.clientConnecting
                source: "qrc:/icons/mirror-screens-disconnect.svg"
                sourceSize: Theme.iconSize
                color: (driveMirrorViewModel.usingGPS && connectionsViewModel.connectedPeerType !== ConnectedPeerType.E3d) ? Theme.disabledColor : Theme.white
                onClicked: {
                    console.log("setting up MirrorClient- enabled=", disconnectedMirroringIconBtn.enabled)
                    console.log("usingGPS? ", driveMirrorViewModel.usingGPS)
                    console.log("setting up MirrorClient - connectedPeer=e3d?", connectionsViewModel.connectedPeerType === ConnectedPeerType.E3d)
                    console.log("client connecting ? ", driveMirrorViewModel.clientConnecting)
                    driveMirrorViewModel.setupMirrorClient()
                }
            }

            IconButton {
                objectName: "applicationHeaderNotificationBtn"
                source: "qrc:/icons/notification.svg"
                sourceSize: Theme.iconSize
                onClicked: alertViewModel.reset()

                Label {
                    visible: alertViewModel.alertCount
                    state: "h6"
                    color: Theme.black
                    text: alertViewModel.alertCount

                    anchors {
                        centerIn: parent
                    }

                    font {
                        bold: true
                    }

                }

            }

            IconButton {
                visible: drivePageViewModel.currentPage === DrivePage.Workflow
                enabled: !flash.visible
                source: "qrc:/icons/screenshot.svg"
                sourceSize: Theme.iconSize
                onClicked: {
                    screenshotsViewModel.saveScreenshot(appWindow)
                    flash.open()
                }

                ScreenshotFlash {
                    id: flash
                }

            }

        }

        IconButton {
            objectName: "autoSettingsBtnObj"
            source: "qrc:/icons/settings.svg"
            sourceSize: Theme.iconSize
            active: settingsPluginLoader.active || (drivePageViewModel.currentPage === DrivePage.Settings)
            onClicked: {
                if (active) {
                    if (drivePageViewModel.currentPage != DrivePage.Settings)
                        settingsPluginLoader.active = false
                    else
                        drivePageViewModel.goToPreviousPage()
                } else {
                    if (drivePageViewModel.currentPage == DrivePage.Workflow)
                        settingsPluginLoader.active = true
                    else
                        drivePageViewModel.currentPage = DrivePage.Settings
                }
            }
        }

        Item {
            objectName: "applicationHeaderUserIconItem"
            width: 80
            height: 48

            RowLayout {
                anchors.fill: parent
                spacing: 0

                UserIcon {
                    objectName: "applicationHeaderUserIcon"
                    Layout.alignment: Qt.AlignVCenter
                    Layout.preferredWidth: 48
                    Layout.preferredHeight: 48
                    iconText: userViewModel.activeUser.initials
                    iconColor: userViewModel.activeUser.iconColor

                    Rectangle {
                        visible: userDropdown.opened
                        radius: width / 2
                        color: Theme.transparent
                        border.color: Theme.blue

                        anchors {
                            fill: parent
                            margins: -1
                        }

                    }

                }

                IconImage {
                    Layout.alignment: Qt.AlignVCenter
                    color: userDropdown.opened ? Theme.blue : Theme.white
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/icons/down.svg"
                    sourceSize: Theme.iconSize
                }

            }

            MouseArea {
                onPressed: userDropdown.visible = !userDropdown.visible

                anchors {
                    fill: parent
                }

            }

        }

    }

    UserDropdown {
        id: userDropdown

        parent: parent
        x: parent.width - width - Theme.marginSize
        y: parent.height
    }

    Connections {
        target: connectionsViewModel
        onConnectedPeerTypeChanged: {
            console.log("Connected Peer Type changed to ", connectionsViewModel.connectedPeerType)
            console.log("disconnected mirroring enabled?", disconnectedMirroringIconBtn.enabled)
            console.log("active mirroring enabled?", activeMirroringIconBtn.enabled)
        }
    }

}
