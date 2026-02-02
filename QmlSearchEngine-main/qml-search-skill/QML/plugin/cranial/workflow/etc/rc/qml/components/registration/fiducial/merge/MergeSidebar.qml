import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import FiducialMergeStatesPage 1.0
import GmQml 1.0

import "../.."
import "../../.."
import "../../../volumemerge"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    FiducialMergeViewModel {
        id: fiducialMergeViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            state: "Registration Sidebar"
            title: qsTr("Merge Image")
            pageNumber: 2
            maxPageNumber: 3
            description: qsTr("Merge the Fiducial scan with a scan.")

        }

        VolumeMergeStudy {
            id: volumeMergeStudy
            visible: fiducialMergeViewModel.isStudyMode
            mergeId: volumeMergeList.mergeIdSelected
        }

        VolumeMergeList {
            id: volumeMergeList
            visible: !fiducialMergeViewModel.isStudyMode
            onStudyModeClicked: fiducialMergeViewModel.isStudyMode = !fiducialMergeViewModel.isStudyMode
        }

        VolumeMergeCreate {
            state: "Workflow"
            Layout.fillHeight: false
        }

        PageControls {
            Layout.fillHeight: false

            forwardEnabled: fiducialMergeViewModel.pageState == FiducialMergeStatesPage.Merged

            onBackClicked: applicationViewModel.switchToPage(AppPage.FiducialSetup)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.FiducialRegistration)
        }
    }

    DividerLine { }
}
