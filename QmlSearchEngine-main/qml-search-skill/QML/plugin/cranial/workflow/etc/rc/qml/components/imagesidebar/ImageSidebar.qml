import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import GmQml 1.0

import ".."

Item {
    Layout.preferredWidth: 200
    Layout.fillHeight: true

    VolumeListViewModel {
        id: volumeListViewModel
    }

    ImageDetailsPopup {
        id: imageDetailsPopup
    }


    DescriptiveBackground {
        visible: !imageList.count
        z: 1
        icon: "qrc:/icons/image-add.svg"
        title: qsTr("No Images")

        Button {
            Layout.topMargin: Theme.marginSize
            Layout.alignment: Qt.AlignHCenter
            icon.source: "qrc:/icons/plus.svg"
            state: "available"
            text: qsTr("Import")

            onClicked: importPopupLoader.item.open()
        }

        ImportPopupLoader {
            id: importPopupLoader
        }
    }

    ImageList {
        id: imageList
        anchors { fill: parent }

        isStudyMode: volumeListViewModel.isStudyMode

        model: volumeListViewModel.volumeListPS

        delegate: ImageListDelegate {
            width: imageList.delegateWidth - imageList.scrollBarWidth
            uuid: role_Id
            label: role_label
            master: role_isMaster
            merged: role_isMerged
            selected: role_isSelected
            thumbnailPath: role_thumbnailPath
            isLoaded: role_isLoaded
            isFastsurferSegmented: role_isFastsurferSegmented
            isHypothalamusSegmented: role_isHypothalamusSegmented
			isTaskRunning: role_isSegmenting
            selectMasterEnabled: volumeListViewModel.isChangeMasterAllowed
            selectMasterVisible: selectMasterEnabled || master

            onSelectVolumeClicked: volumeListViewModel.selectVolume(uuid)

            onSelectMasterClicked: selected ? volumeListViewModel.setMasterVolume(uuid) : volumeListViewModel.selectVolume(uuid)

            onOpenDetailsClicked: imageDetailsPopup.setup(positionItem, uuid, merged)
        }
    }

    DividerLine {
        anchors { right: parent.right }
    }
}
