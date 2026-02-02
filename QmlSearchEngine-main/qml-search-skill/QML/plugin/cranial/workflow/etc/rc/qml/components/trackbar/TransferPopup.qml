import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import RegTransferState 1.0
import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

Popup {
    parent: Overlay.overlay
    x: Math.round((parent.width - width) / 2)
    y: Math.round((parent.height - height) / 2)
    width: 700
    height: 300

    RegTransferViewModel {
        id: regTransferVM
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: Theme.marginSize * 2

        Label {
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: Theme.marginSize
            state: "h3"
            text: "Registration Transfer"
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            enabled: regTransferVM.transferState == RegTransferState.Transferrable
            state: "active"
            leftPadding: regTransferVM.transferState == RegTransferState.Transferred ? Theme.margin(7) : Theme.margin(3)
            text: regTransferVM.transferState == RegTransferState.Transferred ? "Transferred"
                                                                              : iconStable.visible?"Transfer registration from FRA to DRB       "
                                                                                                  :"Transfer registration from FRA to DRB"
            onClicked: regTransferVM.transferFraToDrb()

            IconImage {
                visible: regTransferVM.transferState == RegTransferState.Transferred
                anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: Theme.margin(2) }
                sourceSize: Theme.iconSize
                source: "qrc:/icons/check.svg"
                color: Theme.green
            }

            IconImage {
                id: iconStable
                visible: parent.enabled && !regTransferVM.regTransferStable
                anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: Theme.marginSize }
                sourceSize: Theme.iconSize
                source: "qrc:/images/motion2.svg"
                color: Theme.yellow
                rotation: -90
            }
        }

        Button {
            Layout.alignment: Qt.AlignHCenter
            enabled: regTransferVM.transferState == RegTransferState.Transferred
            state: "active"
            text: "Discard FRA to DRB registration transfer"
            onClicked: regTransferVM.discardFraToDrbTransfer()
        }

        LayoutSpacer { }
    }
}
