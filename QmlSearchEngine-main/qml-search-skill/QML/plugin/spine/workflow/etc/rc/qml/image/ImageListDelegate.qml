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

    property string thumbnailPath

    signal selectVolumeClicked()
    signal selectMasterClicked()
    signal openDetailsClicked(var positionItem)

    ColumnLayout {
        id: contentItem
        width: parent.width
        spacing: Theme.marginSize

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
                source: thumbnailPath ? "file:///" + encodeURIComponent(thumbnailPath)
                                      : "qrc:/images/thumbnailError.png"

                Button {
                    id: selectMasterButton
                    visible: false
                    state: "icon"
                    highlighted: master
                    icon.source: master ? "qrc:/icons/star-filled.svg"
                                        : "qrc:/icons/star-outline.svg"

                    onClicked: selectMasterClicked()
                }

                Button {
                    rotation: 90
                    anchors { right: parent.right; bottom: parent.bottom }
                    state: "icon"
                    icon.source: "qrc:/icons/dots.svg"

                    onPressed: openDetailsClicked(this)
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
