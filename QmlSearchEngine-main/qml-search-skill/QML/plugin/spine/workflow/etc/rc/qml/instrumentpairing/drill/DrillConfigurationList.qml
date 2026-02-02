import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import Enums 1.0

ListView {
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: Theme.marginSize

    property var powerToolsPairingsViewModel

    model: powerToolsPairingsViewModel.powerToolConfigurations

    delegate: DrillConfigurationItem {
        selected: role_key === powerToolsPairingsViewModel.selectedConfigurationId
        verifiedIconVisible: role_verificationStatus != ToolVerifiedStatus.NotRequired
        verifiedIconColor: {
            if (role_verificationStatus == ToolVerifiedStatus.Passed) { return Theme.green }
            else if (role_verificationStatus == ToolVerifiedStatus.Failed) { return Theme.red }
            else if (role_verificationStatus == ToolVerifiedStatus.ToolLengthUnverified) {return Theme.yellow}
            else { return Theme.disabledColor }
        }

        text: {
            if (role_attachmentName)
            {
                if (role_burrName)
                    return role_attachmentName + " / " + role_burrName

                return role_attachmentName
            }
            else
            {
                return qsTr("No Configuration")
            }
        }

        onSelect: powerToolsPairingsViewModel.selectedConfigurationId = role_key
        onDeletClicked: powerToolsPairingsViewModel.deletePowerToolConfiguration(role_key)
    }
}
