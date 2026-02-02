import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

RowLayout {
    anchors { fill: parent; leftMargin: Theme.marginSize }

   ShotGalleryViewModel {
       id: shotGalleryViewModel
   }

    ListView {
        id: shotList
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.topMargin: 12
        spacing: Theme.margin(1)
        orientation: Qt.Horizontal
        highlightFollowsCurrentItem: true
        highlightMoveDuration : 250
        clip: true

        model: shotGalleryViewModel.sortedShotList

        ScrollBar.horizontal: ScrollBar {
            visible: shotList.width < shotList.contentWidth
            anchors { bottom: parent.bottom; bottomMargin: -18 }

            leftPadding: 4
            rightPadding: leftPadding
        }

        delegate: ShotItem {
            id: shotDelegate
            z: -1
            enabled: true
            width: Theme.margin(20)
            height: Theme.margin(20)
            selected: role_shotId === shotGalleryViewModel.selectedShotId

            onThumbClicked: {
                shotList.currentIndex = index
                shotGalleryViewModel.selectShot(role_shotId)
            } 
        }

        Connections {
            target: shotList
            function onCountChanged() {
                shotList.currentIndex = 0
            }
        }

        DescriptiveBackground {
            visible: shotList.count === 0
            anchors { centerIn: parent }
            source: "qrc:/icons/image-fluoro"
            text: qsTr("No Images Captured.")
        }
    }
}
