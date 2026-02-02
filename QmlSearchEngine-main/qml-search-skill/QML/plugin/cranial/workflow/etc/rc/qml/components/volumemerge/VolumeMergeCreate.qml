import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import ".."

ColumnLayout {
    id: volumeMergeCreateRoot

    visible: volumeMergeCreateViewModel.selectedVolumesRegisterable

    spacing: 0

    states: [
        State {
            name: "Workflow"
            PropertyChanges { target: volumeMergeCreateRoot; visible: volumeMergeCreateViewModel.potentialWorkflowRegistrationSelected }
            PropertyChanges { target: mergeButton; enabled: !volumeMergeCreateViewModel.registrationTaskRunning
                                                            && volumeMergeCreateViewModel.selectedVolumesRegisterable }
        }
    ]

    VolumeMergeCreateViewModel {
        id: volumeMergeCreateViewModel
    }

    DividerLine { }

    SectionHeader {
        title: qsTr("SELECTION")

        Button {
            id: mergeButton
            enabled: !volumeMergeCreateViewModel.registrationTaskRunning
            state: "active"
            text: "Merge"

            onClicked: volumeMergeCreateViewModel.registerSelectedVolumes()
        }
    }

    VolumeMergeSelection {
        enabled: volumeMergeCreateViewModel.selectedVolumesRegisterableBothDirections
        Layout.margins: Theme.marginSize
        Layout.leftMargin: Theme.marginSize * 2
        Layout.rightMargin: Theme.marginSize * 2
        fromVolumeLabel: volumeMergeCreateViewModel.fromVolumeLabel
        toVolumeLabel: volumeMergeCreateViewModel.toVolumeLabel
        fromThumbnailPath: volumeMergeCreateViewModel.fromThumbnailPath
        toThumbnailPath: volumeMergeCreateViewModel.toThumbnailPath
        isToMaster: volumeMergeCreateViewModel.isToMaster
    }
}
