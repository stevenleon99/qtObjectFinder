import QtQuick 2.12
import QtQuick.Controls 2.12

import ViewModels 1.0


Button {
    property alias resetViewModel: regResetViewModel
    state: "icon"
    icon.source: "qrc:/icons/life-buoy.svg"
    onClicked: regResetViewModel.displayRegistrationResetAlert()

    RegistrationResetViewModel {
        id: regResetViewModel
    }
}
