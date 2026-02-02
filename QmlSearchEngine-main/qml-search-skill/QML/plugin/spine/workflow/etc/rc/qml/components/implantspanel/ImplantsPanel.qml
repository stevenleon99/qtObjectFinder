import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

import ".."
import "../toolspanel"
import "../../instrumentpairing"

ColumnLayout {
    Layout.preferredWidth: Theme.margin(45)
    spacing: 0

    property alias implantDetails: details.contentItem

    ImplantListViewModel {
        id: implantPlanNavListViewModel
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.preferredHeight: Theme.margin(8)
        Layout.leftMargin: Theme.margin(2)
        Layout.rightMargin: Theme.margin(1)
        spacing: Theme.margin(1)

        LayoutSpacer {}

        IconButton {
            icon.source: "qrc:/icons/measure-angle.svg"
            active: implantPlanNavListViewModel.constructMeasuresEnabled
            color: Theme.white

            onClicked: implantPlanNavListViewModel.toggleConstructMeasures()
        }

        Button {
            state: "icon"
            icon.source: "qrc:/icons/plus.svg"
            visible: implantPlanNavListViewModel.addIndImplantsVisible

            onClicked: implantPlanNavListViewModel.addIndependentImplant()
        }

        IconButton {
            visible: implantPlanNavListViewModel.reachabilityToggleEnabled
            icon.source: "qrc:/icons/measure-line.svg"
            active: implantPlanNavListViewModel.reachabilityEnabled
            color: Theme.white

            onClicked: implantPlanNavListViewModel.toggleReachability()
        }
    }

    Item {
        id: implantToggle
        visible: implantPlanNavListViewModel.implantToggleEnabled
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.preferredHeight: Theme.margin(6)
        Layout.leftMargin: Theme.margin(2)
        Layout.rightMargin: Theme.margin(2)
        Layout.bottomMargin: Theme.margin(2)

        RowLayout {
            anchors { fill: parent }
            spacing: 0

            HeaderSelectionRectangle {
                Layout.preferredWidth: parent.width / 2
                active: implantPlanNavListViewModel.selectedHeaderType == ImplantTypes.Fixation
                icon.source: "qrc:/icons/screw-planned.svg"
                borderEnabled: false
                onSelected: implantPlanNavListViewModel.setSelectedImplantHeader(ImplantTypes.Fixation)
            }

            HeaderSelectionRectangle {
                Layout.preferredWidth: parent.width / 2
                active: implantPlanNavListViewModel.selectedHeaderType == ImplantTypes.Interbody
                icon.source: "qrc:/icons/interbody-planned.svg"
                borderEnabled: false
                onSelected: implantPlanNavListViewModel.setSelectedImplantHeader(ImplantTypes.Interbody)
            }
        }

        DividerLine { anchors.bottom: parent.bottom; orientation: Qt.Horizontal }
    }

    ImplantList {
        Layout.preferredHeight: implantToggle.visible ? Theme.margin(26) : Theme.margin(34)
        implantPlanNavListVM: implantPlanNavListViewModel
    }

    InterbodyPlacementPopup {
        id: interbodyPlacementPopup
        closePolicy: Popup.NoAutoClose
        onResetRegistration: registrationResetPopup.open()
    }

    RegistrationResetPopup {
        id: registrationResetPopup
        closePolicy: Popup.NoAutoClose
        regResetViewModel: RegistrationResetViewModel {}
    }

    Connections {
        target: implantPlanNavListViewModel
        onInterbodyToFixation: interbodyPlacementPopup.open()
    }

    DividerLine { }

    Control {
        id: details
        Layout.fillWidth: true
        Layout.fillHeight: true
    }

    InstrumentPlanningControlsPanel {
        Layout.fillWidth: true
        Layout.fillHeight: false
    }
}

