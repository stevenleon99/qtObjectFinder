import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0 
import Enums 1.0

import "../components"
import "../plansidebar" 

Item {

   NavigateImplantDetailsViewModel {
       id: navImplantDetailsPanelViewModel

       onImplantPlacedChanged: implantOptionsPopup.setOptionList()
   }

    DescriptiveBackground {
        visible: !columnLayout.visible
        anchors { centerIn: parent }
        source: "qrc:/icons/info-circle-outline.svg"
        text: qsTr("Select any item.")
    }

    ColumnLayout {
        id: columnLayout
        visible: navImplantDetailsPanelViewModel.implantSelected
        anchors.fill: parent
        spacing: 0

        RowLayout {
            Layout.fillHeight: false
            Layout.preferredHeight: Theme.margin(8)
            Layout.leftMargin: Theme.margin(2)
            spacing: Theme.margin(1)
            
            IconImage {
                visible: navImplantDetailsPanelViewModel.implantPlaced
                source: "qrc:/icons/check"
                sourceSize: Theme.iconSize
                color: Theme.green
            }

            Label {
                Layout.preferredWidth: Theme.margin(14)
                Layout.fillWidth: false
                state: "h5"
                font.bold: true
                text: navImplantDetailsPanelViewModel.selectedImplantName
            }

            LayoutSpacer {}

            IconButton {
                Layout.rightMargin: Theme.margin(1)
                active: implantOptionsPopup.visible
                rotation: 90
                icon.source: "qrc:/icons/dots"

                onPressed: {
                    if (!implantOptionsPopup.visible)
                        implantOptionsPopup.setup(this)
                }

                OptionsPopup {
                    id: implantOptionsPopup

                    function setOptionList() {
                        optionList.clear()
                        if (navImplantDetailsPanelViewModel.implantPlaced)
                            optionList.append({role_action: "MARK", role_displayName: "Mark as Not Placed", role_icon: "qrc:/icons/check.svg", role_color: Theme.green.toString()})
                        else
                            optionList.append({role_action: "MARK", role_displayName: "Mark as Placed", role_icon: "qrc:/icons/check.svg", role_color: Theme.green.toString()})

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
                                navImplantDetailsPanelViewModel.toggleImplantPlaced()
                            }
                        }
                    }
                }
            }
        }

        ColumnLayout {
            spacing: 12

            Label {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.margin(2)
                state: "subtitle1"
                color: Theme.navyLight
                font.styleName: Theme.mediumFont.styleName
                font.bold: true
                text: navImplantDetailsPanelViewModel.selectedImplantSysName
            }

            DriverSelectionDropdown {
                Layout.leftMargin: Theme.margin(2)
                Layout.rightMargin: Theme.margin(2)
                Layout.fillWidth: true
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Flickable {
                    anchors.fill: parent
                    bottomMargin: Theme.margin(2)
                    boundsBehavior: Flickable.DragOverBounds
                    flickableDirection: Flickable.VerticalFlick
                    contentHeight: gridLayout.height
                    interactive: contentHeight > height
                    clip: true

                    ScrollBar.vertical: ScrollBar {
                        anchors { right: parent.right }
                        visible: parent.contentHeight > parent.height
                        padding: 4
                    }

                    ColumnLayout {
                        id: gridLayout
                        anchors{ left: parent.left; leftMargin: Theme.margin(2); right: parent.right; rightMargin: Theme.margin(2) }
                        spacing: Theme.margin(2)

                        Repeater {
                            id: repeater
                            model: navImplantDetailsPanelViewModel.displayPropertiesList
                            delegate: Item {
                                Layout.fillWidth: true
                                Layout.preferredHeight: layout.height

                                ColumnLayout {
                                    id: layout

                                    Label {
                                        id: label
                                        state: "body1"
                                        color: Theme.navyLight
                                        text: role_propertyName
                                    }

                                    Label {
                                        state: "h5"
                                        verticalAlignment: Text.AlignVCenter
                                        horizontalAlignment: Text.AlignHCenter
                                        font.bold: true
                                        text: role_values
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        LayoutSpacer { }
    }
}
