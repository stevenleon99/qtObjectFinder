import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0

import "../components"

ColumnLayout {
    id: arrayPairingSets
    spacing: 0

    property PairingPopupHeaderViewModel pairingPopupHeaderViewModel

    Layout.preferredWidth: pairingSet.width + Theme.margin(3)

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.margin(8)
        RowLayout {
            anchors { fill: parent }
            spacing: 0

            Item {
                Layout.preferredWidth: pairingSet.width
                height: pairingSet.height

                Rectangle {
                    opacity: 0.16
                    radius: 4
                    anchors { fill: parent }
                    color: pairingSetSelection.opened ? Theme.blue : Theme.transparent
                }

                RowLayout {
                    id: pairingSet
                    spacing: 0

                    Label {
                        Layout.preferredHeight: Theme.margin(5)
                        Layout.leftMargin: Theme.margin(1)
                        state: "h6"
                        verticalAlignment : Text.AlignVCenter
                        text: pairingPopupHeaderViewModel.selectedPairingSetName
                    }

                    IconImage {
                        Layout.alignment: Qt.AlignVCenter
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/icons/caret-down.svg"
                        sourceSize: Theme.iconSize
                        color: pairingSetSelection.opened ? Theme.blue : Theme.white
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    onPressed: {
                        if (!pairingSetSelection.visible)
                            pairingSetSelection.setup(this)
                    }
                }
            }

            LayoutSpacer {}

            IconButton {
                active: pairingSetOptions.visible
                rotation: 90
                icon.source: "qrc:/icons/dots"
                onPressed: {
                    if (!pairingSetOptions.visible)
                        pairingSetOptions.setup(this)
                }
            }
        }

        PairingSetSelection {
            id: pairingSetSelection
            pairingPopupHeaderViewModel: arrayPairingSets.pairingPopupHeaderViewModel
        }

        PairingSetOptions {
            id: pairingSetOptions
            pairingPopupHeaderViewModel: arrayPairingSets.pairingPopupHeaderViewModel
        }
    }
}
