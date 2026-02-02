import QtQuick 2.0
import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import ".."



    RowLayout {
        id: layout
        spacing: 0

		property alias buttonVisible: algorithmButtonId.visible
        property alias checkedCombo: algorithmComboId.checked
        property alias titleCombo: algorithmComboId.text

        property var buttonEnabled

        signal buttonClicked();
        signal toggleCombo(bool checked);

		CheckBox {
            id: algorithmComboId
            enabled: !algorithmButtonId.visible
			Layout.fillWidth: true  
            Layout.leftMargin:Theme.margin(1) 
            Layout.rightMargin:Theme.margin(1) 
            Layout.topMargin:Theme.margin(1) 
             Layout.bottomMargin:Theme.margin(1)  

			onCheckedChanged: toggleCombo(checked)
        }

        Button {
            id: algorithmButtonId
            Layout.preferredWidth: 100 
	        Layout.leftMargin: Theme.margin(1) 
            Layout.rightMargin: Theme.margin(1) 
            Layout.topMargin:Theme.margin(1) 
            Layout.bottomMargin:Theme.margin(1)  
            state: buttonEnabled?"active":"disabled"
            text: qsTr("Run")

			onClicked: buttonClicked()
         }

    }

