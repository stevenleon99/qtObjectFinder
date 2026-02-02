import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

Item {
    id: pairingPopupHeader
    property PairingPopupHeaderViewModel pairingPopupHeaderViewModel

    RowLayout {
        spacing: 0
        height: parent.height

        PairingSets {
            pairingPopupHeaderViewModel: pairingPopupHeader.pairingPopupHeaderViewModel
            Layout.fillWidth: true
            Layout.rightMargin: Theme.margin(5)
        }

        Rectangle {      
            id: bigRect 
            Layout.preferredWidth: rowLayout.width
            Layout.preferredHeight: parent.height * 0.6
            radius: 5
            color: Theme.transparent
            border.color: Theme.disabledColor
            border.width: 1  

            RowLayout {
                id: rowLayout
                spacing: 0

                Repeater {
                    model: pairingPopupHeaderViewModel.pairingTypeList
                
                    delegate: HeaderSelectionRectangle {
                        Layout.preferredHeight: bigRect.height
                        active: role_selected
                        text: role_name
                        icon.source: role_iconPath
                        label.font.capitalization: Font.AllUppercase
                        onSelected: pairingPopupHeaderViewModel.selectPairingType(role_name)
                    }

                    
                }
            }
        }
        LayoutSpacer{}
    }
}
