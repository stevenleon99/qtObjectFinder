import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import ".."

ColumnLayout {
    spacing: 0

    property bool isVisible: visible
    property alias count: listView.count
    property var mergeIdSelected

    signal studyModeClicked()

    VolumeMergeListViewModel {
        id: volumeMergeListViewModel
    }

    SectionHeader {
        title: qsTr("MERGE LIST")
    }

    ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.leftMargin: Theme.marginSize
        z: -1
        spacing: 0
        clip: true

        model: volumeMergeListViewModel.volumeMergeListModel

        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            visible: listView.count
            policy: ScrollBar.AlwaysOn
        }

        delegate: VolumeMergeListDelegate {
            width: parent.width - scrollBar.width
            selected: role_isSelected
            taskRunning: volumeMergeListViewModel.isTaskRunning
            verified: role_isVerified
            isModifiable: role_isModifiable
            fromVolumeLabel: role_fromVolumeLabel
            toVolumeLabel: role_toVolumeLabel
            isToMaster: role_isToMaster
            fromThumbnailSource: role_fromThumbnailPath
            toThumbnailSource: role_toThumbnailPath
            isToLoaded: role_isToLoaded
            isFromLoaded: role_isFromLoaded
            isStudyMode: !isVisible

            onSelectedChanged: {if (selected) mergeIdSelected = role_id}

            onThumbnailClicked: volumeMergeListViewModel.selectMerge(role_id)
            onReRegisterClicked: volumeMergeListViewModel.registerVolumes()
            onStudyClicked:  studyModeClicked()
            onVerifyClicked: volumeMergeListViewModel.setMergeVerifiedStatus(role_id, !role_isVerified)
        }
    }
}
