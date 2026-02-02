import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

import "../../instrumentpairing"
import ".."

ColumnLayout {
    id: toolsPanel

    Layout.preferredWidth: Theme.margin(45)
    spacing: 0

    ToolsListViewModel{
        id: toolsListViewModel
        onSelectedPairingSetChanged: comboBox.updateSelection()
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.preferredHeight: Theme.margin(8)
        Layout.leftMargin: Theme.margin(1)
        Layout.rightMargin: Theme.margin(1)
        spacing: 0

        OptionsDropdown {
            id: comboBox
            Layout.alignment: Qt.AlignLeft
            Layout.maximumWidth: toolsPanel.width - editButton.width - Theme.margin(2)
            Layout.preferredHeight: Theme.margin(5)
            borderEnabled: false
            model: toolsListViewModel.pairingSets

            function updateSelection() {
                if (toolsListViewModel.selectedPairingSet)
                    currentIndex = comboBox.find(toolsListViewModel.selectedPairingSet)
            }

            onModelChanged: comboBox.updateSelection()

            onActivated: toolsListViewModel.selectPairingSet(comboBox.currentText)

            Component.onCompleted: comboBox.updateSelection()

            Connections {
                target: toolsListViewModel
                function selectedRefElementIdChanged() { comboBox.updateSelection() }
            }
        }

        LayoutSpacer {}

        Button {
            id: editButton
            Layout.alignment: Qt.AlignRight
            state: "icon"
            icon.source: "qrc:/icons/pencil.svg"

            onClicked: {
                pairingsPopup.open()
            }

            PairingsPopup {
                id: pairingsPopup
            }
        }
    }

    PairingList {
        toolsListVM: toolsListViewModel
    }

    DividerLine { }

    PairingDetails {
        visible: !powerToolDetails.visible
    }

    PowerToolDetails {
        id: powerToolDetails
        Layout.leftMargin: Theme.margin(2)
        Layout.rightMargin: Theme.margin(1)
        Layout.bottomMargin: Theme.margin(2)

        onEditClicked: pairingsPopup.open()
    }
    
    DividerLine { }

    IndependentTrajectoryDetailsPanel {}

    InstrumentPlanningControlsPanel {}
}
