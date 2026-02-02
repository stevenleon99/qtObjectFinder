import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

import ".."


Item {
    id: item
    Layout.fillWidth: true
    Layout.fillHeight: true

    IndependentTrajectoryControlsViewModel {
        id: independentTrajectoryControlsViewModel

        onActiveImplantSystemChanged: comboBox.updateSelection()
    }

    ColumnLayout {
        anchors { fill: parent }

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.preferredHeight: Theme.margin(8)
            Layout.leftMargin: Theme.margin(2)
            Layout.rightMargin: Theme.margin(1)
            spacing: 0

            Label {
                id: label
                visible: text
                Layout.alignment: Qt.AlignLeft
                state: "subtitle2"
                color: Theme.navyLight
                font { bold: true; capitalization: Font.AllUppercase }
                text: qsTr("Trajectory")
            }

            LayoutSpacer {}

            OptionsDropdown {
                id: comboBox
                Layout.alignment: Qt.AlignRight
                Layout.minimumWidth: Theme.margin(8)
                Layout.maximumWidth: item.width - label.width - Theme.margin(4)
                borderEnabled: false
                model: independentTrajectoryControlsViewModel.availableImplantSystems
                displayText: independentTrajectoryControlsViewModel.activeImplantSystem

                textRole: "role_systemName"

                function updateSelection() {
                    if (independentTrajectoryControlsViewModel.activeImplantSystem) {
                        for( var indexVal = 0; indexVal < comboBox.count; indexVal++ ) {
                            var implantItem = delegateModel.items.get(indexVal)
                            if (implantItem.model.role_systemName == independentTrajectoryControlsViewModel.activeImplantSystem) {
                                currentIndex = indexVal
                                break;
                            }
                        }
                    }
                }

                onModelChanged: comboBox.updateSelection()

                onActivated: {
                    var implantItem = delegateModel.items.get(index)
                    if (implantItem.model.role_key) {
                        independentTrajectoryControlsViewModel.setActiveImplantSystem(implantItem.model.role_key)
                    }
                }

                Component.onCompleted: comboBox.updateSelection()

                Connections {
                    target: independentTrajectoryControlsViewModel
                    function onActiveImplantSystemChanged(activeImplantSystem) {
                        comboBox.updateSelection()
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            ImplantPropertiesList {
                model: independentTrajectoryControlsViewModel.displayPropertiesList

                onPropertySelected: independentTrajectoryControlsViewModel.selectProperty(keyVal, index)
            }
        }
    }
}
