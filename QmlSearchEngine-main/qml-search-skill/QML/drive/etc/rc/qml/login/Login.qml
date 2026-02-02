import QtQuick 2.12
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.5

import DriveEnums 1.0
import Theme 1.0
import ViewModels 1.0

import "../components"

Item {
    objectName: "loginPage"
    property bool serviceMode: false

    Image {
        anchors { fill: parent }
        source: "qrc:/images/login.png"
        fillMode: Image.PreserveAspectFit
    } 
      
    Button {
        id: shutdownBtn
        visible: userViewModel.platformType === PlatformType.Laptop
        anchors { right: parent.right; top: parent.top; margins: 36 }
        state: "icon"
        icon.source: "qrc:/icons/power.svg"
        icon.width: Theme.iconSize.width * 2
        icon.height: Theme.iconSize.height * 2

        onClicked: applicationViewModel.shutdownSystem()
    }    

    Item {
        anchors { fill: parent; margins: Theme.margin(4) }

        ColumnLayout {
            spacing: Theme.margin(2)

            Image {
                source: userViewModel.logoSource
                sourceSize: Qt.size(Theme.margin(50), Theme.margin(6))
                fillMode: Image.PreserveAspectFit
            }
        }

        ColumnLayout {
            SystemInfoViewModel { id: systemInfoViewModel }
            anchors { centerIn: parent; verticalCenterOffset: Theme.margin(5) }
            spacing: Theme.margin(4)

            Loader {
                id: loader
                Layout.alignment: Qt.AlignHCenter

                Component.onCompleted: state = "pinpad"

                states: [
                    State {
                        name: "pinpad";
                        PropertyChanges { target: loader; source: "Pinpad.qml" }
                    },
                    State {
                        name: "userSelector";
                        PropertyChanges { target: loader; source: "UserSelector.qml" }
                    }
                ]
            }
        }

        Image {
            anchors { bottom: parent.bottom }
            source: "qrc:/images/globusLogo.png"
            fillMode: Image.PreserveAspectFit
        }

    EnterRemoteDeployment {
        id: remDeployConfirmationPopup
        visible: false         
        }

    RowLayout {
            spacing: Theme.margin(4)
            anchors { right: parent.right ; bottom: parent.bottom;  }
           
            Label {
              //  anchors { right: parent.right; bottom: parent.bottom }
                text: systemInfoViewModel.systemInfo["build_version"]
                state: "button2"
            }
                         
            Button {
                objectName: "loginPageExitBtn"
                visible: true         
                state: "icon"
                icon.source: "qrc:/icons/exit.svg"
                icon.width: Theme.iconSize.width * 2
                icon.height: Theme.iconSize.height * 2
                onClicked: { remDeployConfirmationPopup.visible = true }
            }

        }
    }
}
