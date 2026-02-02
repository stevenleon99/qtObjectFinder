import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0


Flickable {
    Layout.leftMargin: Theme.marginSize
    contentWidth: width
    contentHeight: imageList.height

    readonly property int count: repeater.count

    VolumeListViewModel {
        id: volumeListViewModel
    }

    ImageDetailsPopup {
        id: imageDetailsPopup
    }

    ScrollBar.vertical: ScrollBar {
        id: scrollBar
        anchors { right: parent.right; rightMargin: -Theme.marginSize }
        visible: parent.contentHeight > parent.height
        leftPadding: Theme.margin(1)
    }

    GridLayout {
        rowSpacing: Theme.marginSize
        columnSpacing: Theme.marginSize
        columns: 1

        Repeater {
            id: repeater

            model: volumeListViewModel.volumeListPS

            delegate: ImageListDelegate {
                width: Theme.margin(40)
                uuid: role_Id
                label: role_label
                master: role_isMaster
                merged: role_isMerged
                selected: role_isSelected
                thumbnailPath: role_thumbnailPath

                onSelectVolumeClicked: volumeListViewModel.selectVolume(uuid)

                onSelectMasterClicked: selected ? volumeListViewModel.setMasterVolume(uuid) : volumeListViewModel.selectVolume(uuid)

                onOpenDetailsClicked: {
                    if (!imageDetailsPopup.visible)
                        imageDetailsPopup.setup(positionItem, uuid)
                }
            }
        }
    }
}
