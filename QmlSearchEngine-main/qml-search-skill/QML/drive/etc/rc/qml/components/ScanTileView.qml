import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0
import DriveEnums 1.0

import DriveImport 1.0

Rectangle {
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.margin(40)
    radius: 4
    color: Theme.black

    Button {
        enabled: scanlist.currentIndex != 0
        anchors { left: parent.left;  verticalCenter: parent.verticalCenter }
        state: "icon"
        icon.source: "qrc:/icons/arrow.svg"
        icon.color: Theme.white

        onClicked: scanlist.currentIndex = (scanlist.currentIndex - 1)
    }

    ListView {
        id: scanlist
        anchors { centerIn: parent }
        width: Theme.margin(40)
        height: width
        interactive: false
        orientation: ListView.Horizontal
        currentIndex: 0
        highlightFollowsCurrentItem: true
        highlightMoveDuration: 100
        clip: true

        model: scanListModel

        delegate: ImageThumbnail {
            width: Theme.margin(40)
            height: width
            source: "file:///" + role_thumbnail_path

            onThumbnailClicked: {
                scanListModel.selectScanId(role_scan_id);
                scanDetailsPopup.open();
            }
        }
    }

    Button {
        enabled: scanlist.currentIndex < (scanListModel.count - 1)
        anchors { right: parent.right; verticalCenter: parent.verticalCenter }
        rotation: 180
        state: "icon"
        icon.source: "qrc:/icons/arrow.svg"

        onClicked: scanlist.currentIndex = (scanlist.currentIndex + 1)
    }

    ScanDetailsPopup {
        id: scanDetailsPopup
        exportEnabled: imageExportViewModel.locationsCount > 0

        onExportImage: {
            imageExportPopup.imageId = scanId
            imageExportPopup.visible = true
        }
    }

    ImageExportPopup { id: imageExportPopup }

    ProgressBarDialog {
        visible: imageExportViewModel.exporting
        progressBar.from: 0
        progressBar.to:  100
        progressBar.value: imageExportViewModel.progress
        header: qsTr("Exporting Image")
    }

    Component.onCompleted: scanListModel.scanSource = ScanSource.CASE
}
