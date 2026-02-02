import DriveEnums 1.0
import GmQml 1.0
import NetworkSettingsViewModel 1.0
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Theme 1.0

RowLayout {
    id: nwStatusRow

    spacing: Theme.margin(8)

    Label {
        state: "subtitle1"
        verticalAlignment: "AlignVCenter"
        Layout.preferredHeight: Theme.margin(6)
        text: qsTr("Status:")
    }

    Label {
        id: statusText

        state: "subtitle1"
        color: NwModel.nwStatusColor
        verticalAlignment: "AlignVCenter"
        Layout.preferredHeight: Theme.margin(6)
        text: NwModel.networkStatus + " " + NwModel.glinkLabel
    }

}
