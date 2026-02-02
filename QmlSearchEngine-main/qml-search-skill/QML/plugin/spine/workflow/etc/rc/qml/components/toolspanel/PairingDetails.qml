import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import "../../components"

ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: 0

    ToolsListDetailsViewModel {
        id: toolsListDetailsViewModel
    }

    DescriptiveBackground {
        visible: toolsListDetailsViewModel.displayDefaultText
        Layout.topMargin: Theme.margin(2)
        Layout.bottomMargin: Theme.margin(2)
        source: "qrc:/icons/info-circle-outline.svg"
        text: qsTr("Select any item.")
    }

    RowLayout {
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.margin(8)
        spacing: Theme.margin(2)
        visible: !toolsListDetailsViewModel.displayDefaultText

        IconImage {
            id: icon
            visible: toolsListDetailsViewModel.selectedRefIcon
            Layout.leftMargin: Theme.margin(2)
            sourceSize: Theme.iconSize
            source: toolsListDetailsViewModel.selectedRefIcon
            color: toolsListDetailsViewModel.selectedRefColor

            Label {
                id: indexText
                visible: toolsListDetailsViewModel.displaySelectedArrayIndex
                anchors.centerIn: parent
                state: "button1"
                text: toolsListDetailsViewModel.selectedArrayIndex
            }
        }

        Label {
            Layout.fillWidth: true
            state: "h5"
            font.bold: true
            text: toolsListDetailsViewModel.selectedRefDisplayName
        }

        IconImage {
            visible: !toolsListDetailsViewModel.loaded
            Layout.rightMargin: Theme.margin(2)
            sourceSize: Theme.iconSize
            source: "qrc:/images/navigation-disabled.svg"
            color: Theme.navyLight
        }
    }

    ColumnLayout {
        visible: !toolsListDetailsViewModel.displayDefaultText
        Layout.fillWidth: true
        Layout.fillHeight: false
        Layout.leftMargin: Theme.margin(2)
        Layout.rightMargin: Theme.margin(1)
        Layout.bottomMargin: Theme.margin(2)

        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.margin(1)

            Label {
                Layout.fillWidth: true
                state: "h6"
                font.bold: true
                text: toolsListDetailsViewModel.pairedToolPartNumber
            }

            LayoutSpacer {}

            Button {
                state: "icon"
                icon.source: "qrc:/icons/minus.svg"

                onClicked: toolsListDetailsViewModel.decrementTool()
            }

            Button {
                state: "icon"
                icon.source: "qrc:/icons/plus.svg"

                onClicked: toolsListDetailsViewModel.incrementTool()
            }

            Button {
                state: "icon"
                icon.source: "qrc:/icons/zoom.svg"
                color: searchPopup.opened ? Theme.blue : Theme.white

                onClicked: searchPopup.setup(this)

                PartNumberSearchPopup {
                    id: searchPopup

                    content: PartNumberSearchPanel {
                        id: partNumSearchPanel
                        searchResult: toolsListDetailsViewModel.searchResultText
                        enterEnabled: toolsListDetailsViewModel.setPartNumEnabled


                        onEnterPressed: {
                            toolsListDetailsViewModel.setPartNum(partNumber)
                            searchPopup.close()
                        }

                        onSearchTextChanged: toolsListDetailsViewModel.setSearchPartNum(partNumber)
                    }

                    onClosed: {
                        partNumSearchPanel.clearPressed()
                    }
                }
            }
        }

        Label {
            Layout.fillWidth: true
            Layout.rightMargin: Theme.margin(2)
            state: "body1"
            color: Theme.navyLight
            text: toolsListDetailsViewModel.pairedToolDisplayName
        }
    }

    RowLayout {
        visible: toolsListDetailsViewModel.refPosDisplayEnabled && !toolsListDetailsViewModel.displayDefaultText
        Layout.fillWidth: true
        Layout.leftMargin: Theme.margin(2)
        Layout.rightMargin: Theme.margin(2)
        Layout.bottomMargin: Theme.margin(2)

        Label {
            Layout.fillWidth: true
            state: "body1"
            color: Theme.navyLight
            text: "Position"
        }

        PairedToolOrientationButton {
            positionText: toolsListDetailsViewModel.selectedRefPosition
            positionIcon: toolsListDetailsViewModel.refPositionIcon
            positionRotation: toolsListDetailsViewModel.refPositionIconRotation

            onClicked: toolsListDetailsViewModel.incrementRefPosition()
        }
    }
}
