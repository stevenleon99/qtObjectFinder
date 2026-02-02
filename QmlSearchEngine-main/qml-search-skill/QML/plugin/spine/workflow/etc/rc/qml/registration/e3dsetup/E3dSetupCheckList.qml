import QtQuick 2.12
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import Enums 1.0

import "../../components"

ColumnLayout {

    E3dSetupViewModel {
        id: e3dSetupViewModel
    }

    Layout.fillWidth: false
    spacing: Theme.margin(4)

    RegistrationSetupCheckDelegate {
        state: "info"
        text: qsTr("<b>Pre-Capture</b>") + qsTr(": Place the DRB and surveillance marker. Activate the surveillance marker.​​")
        iconSource: "qrc:/icons/case-info.svg"
        color: Theme.blue
    }

    RegistrationSetupCheckDelegate {
        checked: e3dSetupViewModel.isDrbE3dVisible
        text: qsTr("Ensure DRB and E3D are visible to the camera.")
    }

    RegistrationSetupCheckDelegate {
        state: "info"
        text: qsTr("<b>Post-Capture</b>") + qsTr(": Carefully remove the drape to avoid disruption to the DRB and surveillance marker.​​")
        iconSource: "qrc:/icons/alert-caution.svg"
        color: Theme.yellow
    }
}
