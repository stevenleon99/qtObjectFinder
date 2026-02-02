import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import GmQml 1.0

import ".."

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    VolumeMergeSidebarViewModel {
        id: volumeMergeSidebarViewModel
    }

    DescriptiveBackground {
        visible: !volumeMergeCreate.visible && !volumeMergeList.count
        width: parent.width - (Theme.marginSize * 5)
        icon: "qrc:/icons/star-filled.svg"
        title: qsTr("Set a Master")
        description: qsTr("To merge images, select a master and select two images.")
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        VolumeMergeStudy{
            id: volumeMergeStudy
            visible: volumeMergeSidebarViewModel.isStudyMode
            mergeId: volumeMergeList.mergeIdSelected
        }

        VolumeMergeList {
            id: volumeMergeList
            visible: !volumeMergeSidebarViewModel.isStudyMode
            onStudyModeClicked: volumeMergeSidebarViewModel.isStudyMode = !volumeMergeSidebarViewModel.isStudyMode
        }

        VolumeMergeCreate {
            id: volumeMergeCreate
            Layout.fillHeight: false
        }

        PageControls {
            Layout.fillHeight: false
            backEnabled: false
            forwardEnabled: applicationViewModel.acpcPageIsAvailable

            onBackClicked: pluginGui.requestQuit()

            onForwardClicked: applicationViewModel.testModeEnabled ? applicationViewModel.switchToPage(AppPage.AccTestSetup) :applicationViewModel.switchToPage(AppPage.AcPc)
        }
    }

    DividerLine { }
}
