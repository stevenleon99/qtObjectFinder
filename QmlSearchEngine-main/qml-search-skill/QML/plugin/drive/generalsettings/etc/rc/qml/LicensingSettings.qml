import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

ColumnLayout {
    spacing: Theme.marginSize * 2

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("Licensing Configuration")
    }

    RowLayout {
        spacing: Theme.margin(4)

        SettingsDescription {
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: Theme.marginSize * 4
            title: qsTr("Activate Licenses")
            description: qsTr("Enter a code to activate licenses on your system.")
        }

            Button {
                Layout.preferredWidth: Theme.margin(24)
                state: "active"
                text: qsTr("Add License")
                onClicked: licenseCodePopup.open();
            }
    }

    LicenseCodePopup { id: licenseCodePopup }
}
