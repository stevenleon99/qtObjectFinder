import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import FiducialSetupPageState 1.0
import GmQml 1.0

import "../.."
import "../../.."
import "../../../tracking"
import "../../../imagesidebar"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    FiducialSetupViewModel {
        id: fiducialSetupViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            id: sidebarHeader
            state: "Registration Sidebar"
            title: qsTr("Image")
            pageNumber: 1
            maxPageNumber: 3
            description: qsTr("Select the target patient reference array type.")
		}

            Label {
                Layout.preferredHeight: 64
                Layout.leftMargin: Theme.marginSize
                state: "body1"
                verticalAlignment: Label.AlignVCenter
                text: qsTr("PATIENT REFERENCE")
                color: Theme.navyLight
            }

            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: Theme.marginSize + Theme.margin(1.5)

                RadioButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    Layout.bottomMargin: Theme.margin(2)
                    checked: fiducialSetupViewModel.isDrb
                    text: qsTr("DRB Array")

                    onClicked: fiducialSetupViewModel.setPatRefDrb()
                }

                RadioButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    Layout.bottomMargin: Theme.margin(2)
                    checked: fiducialSetupViewModel.isCrw
                    text: qsTr("FRA CRW")

                    onClicked: fiducialSetupViewModel.setPatRefCrw()
                }

                RadioButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    Layout.bottomMargin: Theme.margin(2)
                    checked: fiducialSetupViewModel.isLeksell
                    text: qsTr("FRA Leksell")

                    onClicked: fiducialSetupViewModel.setPatRefLeksell()
                }
            }
        

        Button {
            enabled: !fiducialSetupViewModel.hasNewVolume
            Layout.fillWidth: true
            Layout.topMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            Layout.leftMargin: Theme.marginSize
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: 21
            icon.source: "qrc:/icons/plus.svg"
            state: "available"
            text: qsTr("Import Image")

            onClicked: {
                if (enabled)
                    importPopupLoader.item.open()
            }
        }

        ImportPopupLoader {
            id: importPopupLoader
        }
    
        LayoutSpacer { }


        PageControls {
            Layout.fillHeight: false

            forwardEnabled: FiducialSetupPageState.VolumeImported == fiducialSetupViewModel.pageState
            || FiducialSetupPageState.PatRefSelected == fiducialSetupViewModel.pageState

            onBackClicked: sidebarHeader.resetViewModel.displayRegistrationResetAlert()

            onForwardClicked: {
                if (FiducialSetupPageState.VolumeImported == fiducialSetupViewModel.pageState)
                    return applicationViewModel.switchToPage(AppPage.FiducialMerge)
                else
                    return applicationViewModel.switchToPage(AppPage.FiducialRegistration)
            }
        }
    }

    DividerLine { }
}
