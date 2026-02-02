import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

Popup {
    id: popup

    width: 640
    height: 272

    property string itemName: ""
    property string state: "patient"

    signal deleteClicked

    modal: true
    Overlay.modal: Rectangle { color: Qt.rgba(0, 0, 0, 0.75) }

    contentItem: Rectangle {
        id: cantainer
        width: popup.width
        height: popup.height
        color: Theme.backgroundColor
        radius: 8

        state: popup.state

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: Theme.marginSize * 1.5
            spacing: Theme.marginSize * 2

            Label {
                id: header
                Layout.fillWidth: true
                font.bold: true
                font.pixelSize: 40
                color: Theme.white
            }

            Label {
                id: text
                Layout.fillWidth: true
                state: "body1"
                color: Theme.white
                wrapMode: Label.Wrap
                text: qsTr("Are you sure you want to delete \"") +
                      itemName +
                      qsTr("\"? It will delete all associated images and cases.")
            }

            RowLayout {
                id: layout
                Layout.alignment: Qt.AlignRight
                spacing: Theme.marginSize

                Button {
                    objectName: "cancelPopupBtn"
                    Layout.preferredWidth: 128
                    state: "available"
                    text: qsTr("Cancel")

                    onClicked: close()
                }

                Button {
                    objectName: "deleteItemPopupBtn"
                    Layout.preferredWidth: 128
                    state: "warning"
                    text: qsTr("Delete")

                    onClicked: {
                        deleteClicked();
                        close();
                    }
                }
            }
        }

        states: [
            State {
                name: "patient"
                PropertyChanges {
                    target: header
                    text: qsTr("Delete Patient")
                }
            },
            State {
                name: "case"
                PropertyChanges {
                    target: header
                    text: qsTr("Delete Case")
                }
                PropertyChanges {
                    target: text
                    text: qsTr("Are you sure you want to delete \"") +
                          itemName +
                          qsTr("\" and its images?")
                }
            },
            State {
                name: "study"
                PropertyChanges {
                    target: header
                    text: qsTr("Delete Study")
                }
                PropertyChanges {
                    target: text
                    text: qsTr("Are you sure you want to permanently delete \"") +
                          itemName + qsTr("\"?")
                }
            },
            State {
                name: "account"
                PropertyChanges {
                    target: header
                    text: qsTr("Delete Account")
                }
                PropertyChanges {
                    target: text
                    text: qsTr("Are you sure you want to delete \"") +
                          itemName + qsTr("\"? You can re-activate this account with your email and activation key.")
                }
            }
        ]
    }
}
