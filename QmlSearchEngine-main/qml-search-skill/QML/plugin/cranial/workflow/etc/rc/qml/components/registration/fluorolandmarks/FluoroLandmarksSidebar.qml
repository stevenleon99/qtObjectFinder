import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import FluoroCtLandmarksPageState 1.0
import GmQml 1.0

import ".."
import "../.."

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    FluoroCtLandmarksViewModel {
        id: fluoroCtLandmarksViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            id: sidebarHeader
            state: "Registration Sidebar"
            title: qsTr("Verify")
            pageNumber: 4
            maxPageNumber: 4
            description: qsTr("Check the merge accuracy.")
            Label {
                Layout.preferredHeight: 64
                state: "body1"
                verticalAlignment: Label.AlignVCenter
                text: qsTr("CHECKS")
                color: Theme.navyLight
            }

            ColumnLayout {
                Layout.fillHeight: false
                spacing: Theme.marginSize

                CheckDelegate {
                    enabled: !fluoroCtLandmarksViewModel.areLandmarksChecked
                    Layout.fillWidth: true
                    text: qsTr("Check Anatomical Landmarks")
                    checked: fluoroCtLandmarksViewModel.areLandmarksChecked

                    onToggled: fluoroCtLandmarksViewModel.areLandmarksChecked = !fluoroCtLandmarksViewModel.areLandmarksChecked
                }
            }
        }

        LayoutSpacer { }

        PageControls {
            Layout.fillHeight: false
            forwardEnabled: fluoroCtLandmarksViewModel.pageState == FluoroCtLandmarksPageState.Verified || fluoroCtLandmarksViewModel.pageState == FluoroCtLandmarksPageState.VerifiedTransfered

            onBackClicked: fluoroCtLandmarksViewModel.pageState == FluoroCtLandmarksPageState.Verified || fluoroCtLandmarksViewModel.pageState == FluoroCtLandmarksPageState.VerifiedTransfered ? sidebarHeader.resetViewModel.displayRegistrationResetAlert() : applicationViewModel.switchToPage(AppPage.FluoroRegistration)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.Navigate)
        }
    }

    DividerLine { }
}
