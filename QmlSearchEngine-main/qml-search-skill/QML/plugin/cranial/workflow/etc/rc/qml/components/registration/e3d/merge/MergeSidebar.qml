import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import E3DMergeStatesPage 1.0
import GmQml 1.0

import "../../.."
import "../../../volumemerge"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    E3DMergeViewModel {
        id: e3dMergeViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            state: "Registration Sidebar"
            title: qsTr("Merge Image")
            pageNumber: 3
            maxPageNumber: 4
            description: qsTr("Merge the E3D scan with a scan.")

        }

        VolumeMergeStudy {
            id: volumeMergeStudy
            visible: e3dMergeViewModel.isStudyMode
            mergeId: volumeMergeList.mergeIdSelected
        }

        VolumeMergeList {
            id: volumeMergeList
            visible: !e3dMergeViewModel.isStudyMode
            onStudyModeClicked: e3dMergeViewModel.isStudyMode = !e3dMergeViewModel.isStudyMode
        }

        VolumeMergeCreate {
            state: "Workflow"
            Layout.fillHeight: false
        }

        PageControls {
            Layout.fillHeight: false
            backEnabled: true

            forwardEnabled: e3dMergeViewModel.pageState == E3DMergeStatesPage.Merged

            onBackClicked: applicationViewModel.switchToPage(AppPage.E3dImage)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.E3dLandmarks)
        }
    }

    DividerLine { }
}
