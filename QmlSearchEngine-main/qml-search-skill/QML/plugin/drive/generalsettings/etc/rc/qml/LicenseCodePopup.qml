import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

Popup {
    width: Theme.margin(55)
    height: layout.height + Theme.margin(8)
    closePolicy: Popup.NoAutoClose

    ColumnLayout {
        id: layout
        width: parent.width - Theme.margin(8)
        anchors { centerIn: parent }
        spacing: Theme.margin(4)

        ColumnLayout {
            Layout.topMargin: Theme.margin(1)
            spacing: Theme.margin(2)

            Label {
                id: title
                Layout.fillWidth: true
                state: "h4"
                text: qsTr("Add License")
            } 

            TitledTextField {
                id: licenseCodeEntry
                Layout.preferredWidth: 1
                inputMethod: TitledTextField.InputMethod.ActivationKey
                title: qsTr("License Code")
                text: settingsPlugin.licenseCode
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: Theme.marginSize

            Button {
                state: "available"
                text: qsTr("Cancel")
                onClicked: close()
            }

            Button {
                id: confirmButton
                state: "active"
                text: qsTr("Confirm")
                onClicked: {
                    settingsPlugin.applyLicenseCode(licenseCodeEntry.text)
                    close()
                }
            }
        }
    }

    onVisibleChanged: {
        if(visible) {
            licenseCodeEntry.textField.cursorPosition = 1
            licenseCodeEntry.textField.forceActiveFocus()
        }
    }
}
