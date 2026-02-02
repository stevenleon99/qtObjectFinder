import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0

import Enums 1.0
import ViewModels 1.0

import "array"
import "drill"
import "../components"

GmPopup {
    id: popup
    width: Theme.margin(234)
    height: Theme.margin(129)
    screenshotVisible: false
    text: "Pairings"

    PairingPopupHeaderViewModel {
        id: pairingPopupHeaderVM
    }

    headerContentItem: PairingPopupHeader {
       pairingPopupHeaderViewModel: pairingPopupHeaderVM
    }

    popupContentItem: Loader {
        anchors.fill: parent
        sourceComponent: pairingPopupHeaderVM.drillSelected ? drillPairingPanel
                                                            : arrayPairingPanel
    }

    Component {
        id: arrayPairingPanel
        ArrayPairingPanel {}
    }

    Component {
        id: drillPairingPanel
        DrillPairingPanel {}
    }
}

