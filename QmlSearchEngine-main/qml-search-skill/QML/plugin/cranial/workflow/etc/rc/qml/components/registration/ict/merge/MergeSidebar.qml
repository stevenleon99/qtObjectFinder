import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import IctMergeStatesPage 1.0
import GmQml 1.0

import "../.."
import "../../.."
import "../../../volumemerge"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    IctMergeViewModel {
        id: ictMergeViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            state: "Registration Sidebar"
            title: qsTr("Merge Image")
            pageNumber: 3
            maxPageNumber: 4
            description: qsTr("Merge the ICT scan with a scan.")

        }

        VolumeMergeStudy {
            id: volumeMergeStudy
            visible: ictMergeViewModel.isStudyMode
            mergeId: volumeMergeList.mergeIdSelected
        }

        VolumeMergeList {
            id: volumeMergeList
            visible: !ictMergeViewModel.isStudyMode
            onStudyModeClicked: ictMergeViewModel.isStudyMode = !ictMergeViewModel.isStudyMode
        }

        VolumeMergeCreate {
            state: "Workflow"
            Layout.fillHeight: false
        }

        PageControls {
            Layout.fillHeight: false

            forwardEnabled: ictMergeViewModel.pageState == IctMergeStatesPage.Merged

            onBackClicked: applicationViewModel.switchToPage(AppPage.IctFiducial)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.IctLandmarks)
        }
    }

    DividerLine { }
}
