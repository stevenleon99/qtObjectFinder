import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import SurfaceSetupPageState 1.0
import GmQml 1.0

import "../.."
import "../../.."
import "../../../tracking"
import "../../../imagesidebar"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    SurfaceSetupViewModel {
        id: surfaceSetupViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            id: sidebarHeader
            state: "Registration Sidebar"
            title: qsTr("Image")
            pageNumber: 1
            maxPageNumber: 5
            description: qsTr("Select the target patient reference array type. Select image for surface mapping.")


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
                spacing: Theme.margin(2)

                RadioButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)    
                    checked: surfaceSetupViewModel.isDrb
                    text: qsTr("DRB Array")

                    onClicked: surfaceSetupViewModel.setPatRefDrb()
                }

                RadioButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    checked: surfaceSetupViewModel.isCrw
                    text: qsTr("FRA CRW")

                    onClicked: surfaceSetupViewModel.setPatRefCrw()
                }

                RadioButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    checked: surfaceSetupViewModel.isLeksell
                    text: qsTr("FRA Leksell")

                    onClicked: surfaceSetupViewModel.setPatRefLeksell()
                }
            }

            ColumnLayout {
                Layout.topMargin: Theme.margin(2)
                Layout.fillHeight: false
                Layout.fillWidth: true
                spacing: Theme.margin(1)

                Label {
                    id: label
                    Layout.fillWidth: true
                    state: "body1"
                    color: Theme.navyLight
                    text: qsTr("Image Name")
                    // Layout.leftMargin: Theme.marginSize
                    Layout.topMargin: Theme.marginSize/2
                }

                OptionsDropdown {
                    id: comboBox
                    Layout.preferredWidth: Theme.margin(41)
                    Layout.preferredHeight: Theme.margin(6)
                    textRole: "role_label"
                    currentIndex: surfaceSetupViewModel.surfaceVolumeIndex()
                    displayText: surfaceSetupViewModel.pageState == SurfaceSetupPageState.NothingSelected || surfaceSetupViewModel.pageState == SurfaceSetupPageState.PatRefSelected ? qsTr("Select Image") : currentText

                    model: surfaceSetupViewModel.ctVolumeListModel

                    onActivated: {
                        var index = surfaceSetupViewModel.ctVolumeListModel.index(index, 0)
                        surfaceSetupViewModel.selectVolume(model.data(index,256))
                    }

                }

            }
        }

        LayoutSpacer { }


        PageControls {
            Layout.fillHeight: false

            forwardEnabled: SurfaceSetupPageState.BothSelected == surfaceSetupViewModel.pageState

            onBackClicked: sidebarHeader.resetViewModel.displayRegistrationResetAlert()

            onForwardClicked: applicationViewModel.switchToPage(AppPage.SurfaceFiducial)
        }
    }

    DividerLine { }
}
