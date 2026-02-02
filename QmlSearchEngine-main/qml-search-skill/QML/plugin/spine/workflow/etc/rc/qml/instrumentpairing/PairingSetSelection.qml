import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import "../components"

Popup {
    visible: false
    width: Theme.margin(40)
    height: layout.height
    modal: false
    dim: false

    property PairingPopupHeaderViewModel pairingPopupHeaderViewModel

    background: Rectangle { radius: 4; color: Theme.slate900 }

    function setup(positionItem)
    {
        var position = positionItem.mapToItem(null, 0, 0)

        var leftX = position.x
        var bottomY =  position.y + positionItem.height
        if (bottomY > 1080) {
            bottomY = position.y - height - Theme.margin(1)
        }

        x = leftX
        y = bottomY

        visible = true;
    }

    ColumnLayout {
        id: layout
        width: parent.width
        spacing: 0

        Repeater {
            model: pairingPopupHeaderViewModel.pairingSetList

            SelectionPopupDelegate {
                name: role_name
                iconPath: "qrc:/icons/check.svg"
                selected: role_pairingSetId === pairingPopupHeaderViewModel.selectedPairingSet
                displayIcon: selected

                onClicked:  {
                    pairingPopupHeaderViewModel.selectedPairingSet = role_pairingSetId 
                    close()
                }
            }
        }

        DividerLine { color: Theme.slate600 }

        SelectionPopupDelegate {
            name: qsTr("New Set")
            iconPath: "qrc:/icons/plus.svg"

            onClicked: {
                addSetPopup.initialText = "Pairing Set " + (pairingPopupHeaderViewModel.pairingSetList.rowCount() + 1)
                addSetPopup.open()
                close()
            }
        }
    }

    TextFieldPopup {
        id: addSetPopup
        popupTitle: qsTr("Add Set")
        errorText : (confirmButtonEnabled || currentText.length == 0) ? "" : qsTr("Name already exists")
        /**
             * Regular expression to validate pairing set names can
             * include up to 50 characters with acceptable characters
             *
             * A-B
             * a-b
             * 0-9
             * <space>, dash, <underscore>, colon
             */
        textValidator: RegExpValidator { regExp: /^[0-9a-zA-Z _:\-]{,50}/ }

        onConfirmClicked: {
            pairingPopupHeaderViewModel.addPairingSet(confirmedText)
        }

        onTextEditChanged: {
            confirmButtonEnabled = (pairingPopupHeaderViewModel.pairingSetNameAvailable(currentText) && currentText.length > 0)
        }

        onVisibleChanged:
        {
            confirmButtonEnabled = pairingPopupHeaderViewModel.pairingSetNameAvailable(initialText)
        }
    }
}
