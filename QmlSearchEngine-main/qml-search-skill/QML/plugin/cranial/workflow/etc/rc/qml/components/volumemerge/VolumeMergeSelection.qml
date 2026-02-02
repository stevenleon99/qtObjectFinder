import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import ".."

RowLayout {
    spacing: Theme.marginSize / 2

    property string fromVolumeLabel
    property string toVolumeLabel

    property string fromThumbnailPath
    property string toThumbnailPath

    property bool isToMaster

    ColumnLayout {
        spacing: 0

        ImageThumbnail {
            id: thumbnail
            Layout.preferredWidth: 112
            Layout.preferredHeight: 112
            source: fromThumbnailPath ? "file:///" + encodeURIComponent(fromThumbnailPath)
                                      : ""
        }

        Label {
            Layout.fillWidth: true
            Layout.maximumWidth: thumbnail.width
            state: "body1"
            text: fromVolumeLabel
            font.bold: true
        }
    }

    ColumnLayout {
        Layout.alignment: Qt.AlignVCenter
        Layout.fillWidth: false
        Layout.fillHeight: true
        spacing: 0

        LayoutSpacer { }

        Button {
            state: "icon"
            icon.source: "qrc:/icons/compare.svg"
            enabled: volumeMergeCreateViewModel.selectedVolumesRegisterableBothDirections
            onClicked: volumeMergeCreateViewModel.swapSelectedVolumes()
        }

        LayoutSpacer { }

        IconImage {
            Layout.alignment: Qt.AlignHCenter
            rotation: 180
            source: "qrc:/icons/arrow.svg"
            sourceSize: Theme.iconSize
            color: Theme.navyLight
        }
    }

    ColumnLayout {
        spacing: 0

        ImageThumbnail {
            Layout.preferredWidth: 112
            Layout.preferredHeight: 112
            source: toThumbnailPath ? "file:///" + encodeURIComponent(toThumbnailPath)
                                    : ""

            IconImage {
                visible: isToMaster
                source: "qrc:/icons/star-filled.svg"
                sourceSize: Theme.iconSize
                color: Theme.blue
            }
        }

        Label {
            Layout.fillWidth: true
            Layout.maximumWidth: thumbnail.width
            state: "body1"
            text: toVolumeLabel
            font.bold: true
        }
    }
}
