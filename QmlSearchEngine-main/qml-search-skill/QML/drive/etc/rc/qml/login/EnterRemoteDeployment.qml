import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

    Popup {
        id:remDeployPopup
        modal: true
        Overlay.modal: Rectangle { color: Qt.rgba(0, 0, 0, 0.75) }
        closePolicy: Popup.NoAutoClose
        y: Theme.margin(42)
        width: Theme.margin(92)
        height: contentColumn.height + (Theme.marginSize * 4)
        visible: false
        padding: Theme.margin(3)
        contentItem: Rectangle {
            width: remDeployPopup.width
            height: remDeployPopup.height
            color: Theme.backgroundColor
            radius: 8
            ColumnLayout {
                id:contentColumn
                anchors { centerIn: parent }
                anchors.margins: 24
                spacing: Theme.marginSize * 2

                RowLayout{
                    spacing: Theme.marginSize * 2
                    IconImage {
                        sourceSize: Qt.size(64, 64)
                        color: Theme.blue
                        source: "qrc:/icons/info-circle-fill.svg"
                    }
                    
                    Label {
                        Layout.fillWidth: true
                        text: qsTr("Exit to Maintenance?")
                        font.bold: true
                        font.pixelSize: 40
                        color: Theme.white                 
                    }
                }

                Label {
                    id: text
                    visible: false
                    Layout.fillWidth: true
                    state: "body1"
                    color: Theme.white
                    wrapMode: Label.Wrap
                    text: qsTr("Are you sure you want to  restart system to setup screen?")
                }

                RowLayout {
                      id: layout
                      Layout.alignment: Qt.AlignHCenter| Qt.AlignVCenter
                      spacing: Theme.marginSize                      
                      Button {
                        objectName: "exitYesBtn"
                        Layout.preferredWidth: 128
                        state: "active"
                        text: qsTr("Yes")
                        color: Theme.blue
                        onClicked: {
                            applicationViewModel.enterRemoteDeployment() 
                        }
                      }

                      Button {
                        objectName: "exitNoBtn"
                        Layout.preferredWidth: 128
                        state: "available"
                        text: qsTr("No")

                        onClicked: close()
                      }
                }
            }
        }
    }