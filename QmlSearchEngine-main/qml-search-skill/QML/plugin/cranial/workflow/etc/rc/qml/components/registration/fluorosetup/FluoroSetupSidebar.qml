import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import FluoroCtImagePageState 1.0
import GmQml 1.0

import ".."
import "../.."

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    FluoroCtSetupViewModel {
        id: fluoroCtSetupViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            id: sidebarHeader
            state: "Registration Sidebar"
            title: qsTr("Image")
            pageNumber: 1
            maxPageNumber: 4
            description: qsTr("Select the target patient reference array type and merge volume.")

            Label {
                Layout.preferredHeight: 64
                state: "body1"
                verticalAlignment: Label.AlignVCenter
                text: qsTr("PATIENT REFERENCE")
                color: Theme.navyLight
            }

            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: Theme.margin(1.5)

                RadioButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    Layout.bottomMargin: Theme.margin(2)
                    checked: fluoroCtSetupViewModel.isDrb
                    text: qsTr("DRB Array")

                    onClicked: fluoroCtSetupViewModel.setPatRefDrb()
                }

                RadioButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    Layout.bottomMargin: Theme.margin(2)
                    checked: fluoroCtSetupViewModel.isCrw
                    text: qsTr("FRA CRW")

                    onClicked: fluoroCtSetupViewModel.setPatRefCrw()
                }

                RadioButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    Layout.bottomMargin: Theme.margin(2)
                    checked: fluoroCtSetupViewModel.isLeksell
                    text: qsTr("FRA Leksell")

                    onClicked: fluoroCtSetupViewModel.setPatRefLeksell()
                }
            }
        }

        OptionsDropdown {
            id: comboBox
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            Layout.topMargin: Theme.marginSize
            textRole: "role_label"
            currentIndex: fluoroCtSetupViewModel.fluoroVolumeIndex()
            displayText: fluoroCtSetupViewModel.pageState == FluoroCtImagePageState.NothingSelected || fluoroCtSetupViewModel.pageState == FluoroCtImagePageState.PatRefSelected ? qsTr("Select Image") : currentText


            model: fluoroCtSetupViewModel.ctVolumeListModel

            onActivated: {
                var index = fluoroCtSetupViewModel.ctVolumeListModel.index(index, 0)
                fluoroCtSetupViewModel.selectVolume(model.data(index,256))
            }
        }

        LayoutSpacer { }

        PageControls {
            Layout.fillHeight: false

            forwardEnabled: FluoroCtImagePageState.BothSelected == fluoroCtSetupViewModel.pageState

            onBackClicked: sidebarHeader.resetViewModel.displayRegistrationResetAlert()

            onForwardClicked: applicationViewModel.switchToPage(AppPage.FluoroCapture)
        }
    }

    DividerLine { }
}
