import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import ".."

Item {
    height: contentItem.height

    property string uuid
    property string label

    property bool master: false
    property bool selected: false
    property bool merged: false
    property bool isLoaded: false
    property bool isFastsurferSegmented: false
    property bool isHypothalamusSegmented: false
    property bool isVesselsSegmented: false
    property bool isTaskRunning: false

    property string thumbnailPath

    property alias selectMasterEnabled: selectMasterButton.enabled
    property alias selectMasterVisible: selectMasterButton.visible

    signal selectVolumeClicked()
    signal selectMasterClicked()
    signal openDetailsClicked(var positionItem)

    ColumnLayout {
        id: contentItem
        width: parent.width
        spacing: Theme.marginSize / 2

        Item {
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: Layout.preferredWidth

            Rectangle {
                visible: selected
                radius: 4
                anchors { fill: parent; margins: -4 }
                border { width: -anchors.margins; color: Theme.blue }
                color: Theme.transparent
            }

            ImageThumbnail {
                id: imageThumbnail
                anchors { fill: parent }
                source: thumbnailPath && isLoaded ? "file:///" + encodeURIComponent(thumbnailPath)
                                      : "qrc:/images/thumbnailError.png"

                onThumbnailClicked: selectVolumeClicked()

                Button {
                    id: selectMasterButton
                    state: "icon"
                    highlighted: master
                    icon.source: master ? "qrc:/icons/star-filled.svg"
                                        : "qrc:/icons/star-outline.svg"

                    onClicked: selectMasterClicked()
                }

                IconImage {
                    visible: merged && !master
                    x: Theme.margin(1)
                    y: x
                    source: "qrc:/icons/merge.svg"
                    sourceSize: Theme.iconSize
                    color: Theme.green
                }

                Button {
                    rotation: 90
                    anchors { right: parent.right; bottom: parent.bottom }
                    state: "icon"
                    icon.source: "qrc:/icons/dots.svg"

                    onClicked: openDetailsClicked(this)
                }

                IconImage {
                    visible: !isTaskRunning && (isFastsurferSegmented || isHypothalamusSegmented || isVesselsSegmented)
                    anchors { left: parent.left; leftMargin: Theme.margin(0.5); bottom: parent.bottom; bottomMargin: Theme.margin(0.5) }
                    source: "qrc:/images/brain-sagittal-segment.svg"
                    sourceSize: Theme.iconSize
                }

                BusyIndicator {
                    visible: isTaskRunning
                    width: Theme.marginSize * 2
                    height: Theme.marginSize * 2

                    anchors { left: parent.left; leftMargin: Theme.margin(0.5); bottom: parent.bottom; bottomMargin: Theme.margin(0.5) }
                }
            }
        }

        Label {
            Layout.fillWidth: true
            state: "body1"
            text: label
            font.bold: true
        }
    }
}
