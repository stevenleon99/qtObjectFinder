import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import "../components"

Popup {
    width: layout.width
    height: layout.height
    x: parentRight.x - width - Theme.margin(1)
    y: parentRight.y
    dim: false

    background: Rectangle { radius: Theme.margin(1); color: Theme.slate900 }

    property var parentRight

    function setup(positionItem, volumeUid) {
        parentRight = positionItem.mapToItem(null, positionItem.width, 0)

        imageDetailsVM.setVolume(volumeUid)

        open()
    }

    ImageDetailsViewModel {
        id: imageDetailsVM
    }

    ColumnLayout {
        id: layout
        spacing: 0

        RowLayout {
            Layout.margins: spacing
            spacing: Theme.margin(2)

            Label {
                Layout.fillWidth: true
                state: "subtitle1"
                color: Theme.white
                text: qsTr("Image Details")
            }

            Button {
                state: "icon"
                icon.source: "qrc:/icons/trash.svg"
                color: Theme.red

                onClicked: {
                    imageDetailsVM.deleteVolume();
                    close();
                }
            }

            Button {
                state: "icon"
                icon.source: "qrc:/icons/x.svg"
                color: Theme.navyLight

                onClicked: close()
            }
        }

        DividerLine { }

        ColumnLayout {
            Layout.margins: spacing
            spacing: Theme.margin(2)

            ColumnLayout {
                spacing: Theme.margin(1)

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(7)
                    radius: 4
                    color: Theme.slate900
                    border.color: Theme.blue
                    border.width: 2

                    ColumnLayout {
                        anchors { fill: parent; margins: Theme.margin(1) }
                        spacing: 0

                        Label {
                            id: label
                            state: "body1"
                            color: Theme.navyLight
                            text: qsTr("Label")
                        }

                        Label {
                            Layout.preferredWidth: parent.width
                            state: "body1"
                            color: Theme.white
                            font.bold: true
                            elide: Text.ElideRight
                            text: imageDetailsVM.label
                        }
                    }

                    MouseArea {
                        anchors { fill: parent }

                        onClicked: volumeRenamePopup.open()
                    }

                    TextFieldPopup {
                        id: volumeRenamePopup
                        initialText: imageDetailsVM.label
                        popupTitle: qsTr("Rename Volume")

                        onConfirmClicked: imageDetailsVM.setLabel(confirmedText)
                    }
                }

                RowLayout {

                    Label {
                        Layout.fillWidth: false
                        state: "caption"
                        color: Theme.navyLight
                        font.bold: true
                        text: qsTr("Details")
                    }

                    LayoutSpacer {}
                }

                Repeater {
                    model: ListModel {
                        ListElement { role_text: qsTr("Patient") }
                        ListElement { role_text: qsTr("Modality") }
                        ListElement { role_text: qsTr("Series") }
                        ListElement { role_text: qsTr("Scan Date") }
                    }

                    RowLayout {
                        spacing: Theme.margin(2)

                        Label {
                            Layout.fillWidth: true
                            state: "caption"
                            color: Theme.disabledColor
                            text: role_text
                        }

                        Label {
                            state: "body1"
                            color: Theme.white
                            font { bold: true }
                            elide: Text.ElideRight
                            text: switch (index) {
                                  case 0: return imageDetailsVM.patient
                                  case 1: return imageDetailsVM.modality
                                  case 2: return imageDetailsVM.series
                                  case 3: return imageDetailsVM.scanDate
                                  default: return "---"
                                  }
                        }
                    }
                }
            }
        }

        // WindowLevelPopupControls {}
    }
}
