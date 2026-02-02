import QtQuick 2.12
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import GmQml 1.0
import Theme 1.0
import ViewModels 1.0
import Enums 1.0

import "../.."
import "../../.."
import "../../../tracking"

ColumnLayout {

    E3DSetupCheckViewModel {
        id : e3DSetupCheckViewModel
    }

    Layout.fillWidth: false
    spacing: Theme.marginSize

    SetupCheckDelegate {
        isInfo: true
        state: "info"
        text: qsTr("<b>Pre-Capture:</b> ") + qsTr("Insert and register Surveillance Marker")
    }

    SetupCheckDelegate {
        checked: e3DSetupCheckViewModel.isPatRefE3DVisible
        text: qsTr("Ensure patient reference and E3D are visible to the camera.")
    }

    SetupCheckDelegate {
        isAlert: true
        state: "alert"
        text: qsTr("<b>Post-Capture:</b> ") + qsTr("Carefully remove the drape to avoid \n
                    disruption to the patient reference and surveillance marker.")
    }
}
