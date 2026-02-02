import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

import "../components"

 Item {
    visible: implantDetailsPanelViewModel.implantSelected
    anchors.fill: parent

    ImplantDetailsPanelViewModel {
        id: implantDetailsPanelViewModel

        onImplantPlacedChanged: implantOptionsPopup.setOptionList()
        onDeleteEnabledChanged: implantOptionsPopup.setOptionList()
        onClearEnabledChanged: implantOptionsPopup.setOptionList()
        onMarkPlacedEnabledChanged: implantOptionsPopup.setOptionList()
        onActiveIndependentImplantSystemChanged: comboBox.updateSelection()
    }

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        spacing: 0

        RowLayout {
            width: parent.width
            Layout.fillHeight: false
            Layout.preferredHeight: Theme.margin(8)
            Layout.leftMargin: Theme.margin(2)
            Layout.rightMargin: Theme.margin(1)
            spacing: 0
            
            Label {
                id: label
                Layout.fillWidth: false
                Layout.preferredWidth: Theme.margin(14)
                state: "h5"
                font.bold: true
                text: implantDetailsPanelViewModel.selectedImplantName
            }
            
            LayoutSpacer {}

            OptionsDropdown {
                id: comboBox
                Layout.alignment: Qt.AlignRight
                Layout.minimumWidth: Theme.margin(8)
                Layout.maximumWidth: item.width - label.width - Theme.margin(4) - dotsButton.width
                borderEnabled: false
                model: implantDetailsPanelViewModel.availableImplantSystems
                displayText: implantDetailsPanelViewModel.activeIndependentImplantSystem
                visible: implantDetailsPanelViewModel.indImplantSystemsVisible

                textRole: "role_systemName"

                function updateSelection() {
                    if (implantDetailsPanelViewModel.activeIndependentImplantSystem) {
                        for( var indexVal = 0; indexVal < comboBox.count; indexVal++ ) {
                            var implantItem = delegateModel.items.get(indexVal)
                            if (implantItem.model.role_systemName == implantDetailsPanelViewModel.activeIndependentImplantSystem) {
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
                        implantDetailsPanelViewModel.selectIndImplantSystem(implantItem.model.role_key)
                    }
                }

                Component.onCompleted: comboBox.updateSelection()

                Connections {
                    target: implantDetailsPanelViewModel
                    function onActiveIndependentImplantSystemChanged(activeIndependentImplantSystem) {
                        comboBox.updateSelection()
                    }
                }
            }

            IconButton {
                id: dotsButton
                active: implantOptionsPopup.visible
                rotation: 90
                icon.source: "qrc:/icons/dots"
                Layout.fillWidth: false
                Layout.leftMargin: 0

                onPressed: {
                    if (!implantOptionsPopup.visible)
                        implantOptionsPopup.setup(this)
                }

                OptionsPopup {
                    id: implantOptionsPopup

                    function setOptionList() {
                        optionList.clear()
                        if (implantDetailsPanelViewModel.markPlacedEnabled)
                        {
                            if (implantDetailsPanelViewModel.implantPlaced)
                                optionList.append({role_action: "MARK", role_displayName: "Mark as Not Placed", role_icon: "qrc:/icons/check.svg", role_color: Theme.green.toString()})
                            else
                                optionList.append({role_action: "MARK", role_displayName: "Mark as Placed", role_icon: "qrc:/icons/check.svg", role_color: Theme.green.toString()})
                        }

                        if (implantDetailsPanelViewModel.deleteEnabled)
                            optionList.append({role_action: "DELETE", role_displayName: "Delete", role_icon: "qrc:/icons/trash.svg", role_color: Theme.navyLight.toString()})

                        if (implantDetailsPanelViewModel.clearEnabled)
                            optionList.append({role_action: "CLEAR", role_displayName: "Clear", role_icon: "qrc:/images/clear-list.svg", role_color: Theme.navyLight.toString()})
                    }

                    Component.onCompleted: setOptionList()

                    model: ListModel { id: optionList }

                    optionDelegate: SelectionPopupDelegate {
                        name: qsTr(role_displayName)
                        iconPath: role_icon
                        iconColor: role_color

                        onClicked: {
                            implantOptionsPopup.close()
                            if (role_action === "MARK") {
                                implantDetailsPanelViewModel.toggleImplantPlaced()
                            } else if (role_action === "DELETE") {
                                implantDetailsPanelViewModel.deleteIndependentLevel()
                            } else if (role_action === "CLEAR") {
                                implantDetailsPanelViewModel.clearCurrentImplantAssignment()
                            }
                        }
                    }
                }
            }
        }

        ColumnLayout {
            width: parent.width
            spacing: Theme.margin(1)

            Label {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.margin(2)
                state: "subtitle1"
                color: Theme.navyLight
                font.styleName: Theme.mediumFont.styleName
                font.bold: true
                text: implantDetailsPanelViewModel.selectedImplantSysName
            }

            DriverSelectionDropdown {
                Layout.leftMargin: Theme.margin(2)
                Layout.rightMargin: Theme.margin(2)
                Layout.fillWidth: true
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ImplantPropertiesList {
                    model: implantDetailsPanelViewModel.displayPropertiesList

                    onPropertySelected: implantDetailsPanelViewModel.selectProperty(keyVal, index)
                }
            }
        }

        LayoutSpacer { }
    }
}
