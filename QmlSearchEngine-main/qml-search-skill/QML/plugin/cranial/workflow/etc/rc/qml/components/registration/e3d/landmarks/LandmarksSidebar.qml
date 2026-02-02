import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import E3DLandmarksStatesPage 1.0
import GmQml 1.0

import "../.."
import "../../.."
import "../../../tracking"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    E3DLandmarksViewModel {
        id: e3DLandmarksViewModel
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

            CheckDelegate {
                enabled: !e3DLandmarksViewModel.areLandmarksChecked
                Layout.fillWidth: true
                text: qsTr("Check Anatomical Landmarks")
                checked: e3DLandmarksViewModel.areLandmarksChecked

                onClicked: e3DLandmarksViewModel.areLandmarksChecked = !e3DLandmarksViewModel.areLandmarksChecked
            }
        }

        LayoutSpacer { }

        PageControls {
            Layout.fillHeight: false

            forwardEnabled: e3DLandmarksViewModel.pageState == E3DLandmarksStatesPage.Checked

            onBackClicked: e3DLandmarksViewModel.pageState == E3DLandmarksStatesPage.Checked ? sidebarHeader.resetViewModel.displayRegistrationResetAlert() : applicationViewModel.switchToPage(AppPage.E3dImage)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.Navigate)
        }
    }

    DividerLine { }
}
