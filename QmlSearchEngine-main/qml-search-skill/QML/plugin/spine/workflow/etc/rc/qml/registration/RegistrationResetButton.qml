import QtQuick 2.12
import QtQuick.Controls 2.12

import ViewModels 1.0

import "../components"

Button {
    visible: registrationResetViewModel.regResetEnabled
    state: "icon"
    icon.source: "qrc:/icons/life-buoy.svg"
    onClicked: registrationResetPopup.open()

    RegistrationResetViewModel {
        id: registrationResetViewModel
    }

    RegistrationResetPopup {
        id: registrationResetPopup
        regResetViewModel: registrationResetViewModel
    }
}
