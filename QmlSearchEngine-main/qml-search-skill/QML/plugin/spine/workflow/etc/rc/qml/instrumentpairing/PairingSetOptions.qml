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

        var leftX = position.x - positionItem.width
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
            model: ListModel {
                ListElement { role_setName: "Add Set"; role_icon: "qrc:/icons/plus.svg"; role_action: "ADD" }
                ListElement { role_setName: "Rename Set"; role_icon: "qrc:/icons/pencil.svg"; role_action: "RENAME" }
                ListElement { role_setName: "Duplicate Set"; role_icon: "qrc:/icons/copy-above.svg"; role_action: "DUPLICATE" }
                ListElement { role_setName: "Clear Set"; role_icon: "qrc:/icons/clear-list.svg"; role_action: "CLEAR" }
                ListElement { role_setName: "Delete Set"; role_icon: "qrc:/icons/trash.svg"; role_action: "DELETE" }
            }

            SelectionPopupDelegate {
                name: qsTr(role_setName)
                iconPath: role_icon

                onClicked: {
                    close()

                    if (role_action === "ADD") {
                        actionPopup.titleText = "Add Pairing Set"
                        actionPopup.actionType = role_action
                        actionPopup.viewmodel = pairingPopupHeaderViewModel
                        actionPopup.initialText = "Pairing Set " + (pairingPopupHeaderViewModel.pairingSetList.rowCount() + 1)
                        actionPopup.open()
                    }
                    else if (role_action === "RENAME")
                    {
                        actionPopup.titleText = "Rename Pairing Set"
                        actionPopup.actionType = role_action
                        actionPopup.viewmodel = pairingPopupHeaderViewModel
                        actionPopup.initialText = pairingPopupHeaderViewModel.selectedPairingSetName
                        actionPopup.open()

                    } else if (role_action === "DUPLICATE") {
                        actionPopup.titleText = "Duplicate Pairing Set"
                        actionPopup.actionType = role_action
                        actionPopup.viewmodel = pairingPopupHeaderViewModel
                        actionPopup.initialText = pairingPopupHeaderViewModel.selectedPairingSetName + " Copy"
                        actionPopup.open()
                    }
                    else if (role_action === "CLEAR") {
                        pairingPopupHeaderViewModel.clearSelectedPairingSet()
                    }
                    else if (role_action === "DELETE") {
                        pairingPopupHeaderViewModel.removeSelectedPairingSet()
                    }
                }
            }
        }
    }

    TextFieldPopup {
        id: actionPopup
        property var viewmodel
        property string actionType
        property string titleText
        errorText : (confirmButtonEnabled || currentText.length == 0) ? "" : qsTr("Name already exists")
        
        popupTitle: titleText

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
            if(actionType === "ADD")
            {
                viewmodel.addPairingSet(confirmedText)
            }
            else if(actionType === "RENAME")
            {
                viewmodel.renameSelectedPairingSet(confirmedText)
            }
            else if(actionType === "DUPLICATE")
            {
                viewmodel.duplicateSelectedPairingSet(confirmedText)
            }
        }

        onTextEditChanged: {
            confirmButtonEnabled = (viewmodel.pairingSetNameAvailable(currentText) && currentText.length > 0)
        }

        onVisibleChanged:
        {
            confirmButtonEnabled = viewmodel.pairingSetNameAvailable(initialText)
        }
    }
}
