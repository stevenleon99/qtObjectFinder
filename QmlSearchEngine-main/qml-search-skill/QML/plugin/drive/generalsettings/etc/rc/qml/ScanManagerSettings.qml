import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

ColumnLayout {
    spacing: Theme.marginSize * 1.5

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text: qsTr("PACS Configuration")
    }

    RowLayout {
        spacing: Theme.margin(4)

        SettingsDescription {
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: Theme.marginSize * 4
            title: qsTr("AE Title")
            description: qsTr("Change the AE title used to identify this system on DICOM networks.")
        }

        ColumnLayout {
            spacing: Theme.marginSize

            TitledTextField {
                id: aetitle
                Layout.preferredWidth: Theme.margin(58)
                validator: RegExpValidator { regExp: /^[\w\-.]+$/ }
                title: qsTr("AE Title")
                text: settingsPlugin.aeTitle
            }

            Button {
                enabled: aetitle.text !== settingsPlugin.aeTitle
                Layout.preferredWidth: Theme.margin(20)
                state: "active"
                text: qsTr("Apply")

                onClicked: settingsPlugin.aeTitle = aetitle.text;
            }

        }
    }
}
