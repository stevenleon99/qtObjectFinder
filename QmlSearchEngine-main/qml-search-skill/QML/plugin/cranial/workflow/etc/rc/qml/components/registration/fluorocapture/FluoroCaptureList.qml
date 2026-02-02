import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import "../.."

Item {
    Layout.fillWidth: true
    Layout.preferredHeight: 224
    clip: true

    FluoroCaptureViewModel{
        id: fluoroCaptureViewModel
    }

    ListView {
        anchors { fill: parent }
        spacing: listView.spacing
        orientation: listView.orientation
        contentX: listView.contentX
        model: 10

        header: Item {
            width: listView.headerItem.width
            height: listView.headerItem.height
        }

        delegate: Item {
            width: height - (Theme.marginSize * 2)
            height: listView.height - scrollBar.height

            Rectangle {
                opacity: 0.25
                anchors { fill: parent; topMargin: Theme.marginSize; bottomMargin: Theme.marginSize }
                radius: Theme.marginSize / 4
                border { width: 2; color: Theme.disabledColor }
                color: Theme.transparent

                IconImage {
                    anchors { centerIn: parent }
                    color: Theme.disabledColor
                    source: "qrc:/icons/hd-image.svg"
                }
            }
        }
    }

    ListView {
        id: listView
        anchors { fill: parent }
        spacing: Theme.marginSize
        orientation: Qt.Horizontal
        headerPositioning: ListView.OverlayHeader
        model: fluoroCaptureViewModel.shotList

        header: Rectangle {
            id: header
            width: layout.width + (Theme.marginSize * 2)
            height: layout.height + (Theme.marginSize * 2)
            color: Theme.backgroundColor
            y: 16

            ColumnLayout {
                id: layout
                anchors { centerIn: parent }
                spacing: Theme.marginSize / 2

                RowLayout {
                    Layout.leftMargin: Theme.marginSize / 4
                    Layout.rightMargin: Theme.marginSize / 4
                    spacing: Theme.marginSize * 1.5
                    Label {
                        Layout.fillWidth: true
                        state: "body1"
                        color: Theme.navyLight
                        font.bold: true
                        text: "IMAGES"
                    }
                }

                RowLayout {
                    Layout.leftMargin: Theme.marginSize / 4
                    Layout.rightMargin: Theme.marginSize / 4
                    spacing: Theme.marginSize * 1.5

                    ColumnLayout {
                        spacing: 0

                        Button {
                            Layout.alignment: Qt.AlignHCenter
                            state: "icon"
                            icon.source: "qrc:/icons/refresh.svg"
                            onClicked: fluoroCaptureViewModel.captureShot()
                        }

                        Label {
                            Layout.fillWidth: true
                            state: "body2"
                            color: Theme.navyLight
                            horizontalAlignment: Label.AlignHCenter
                            text: qsTr("Refresh")
                        }
                    }

                    ColumnLayout {
                        spacing: 0

                        Button {
                            Layout.alignment: Qt.AlignHCenter
                            state: "icon"
                            icon.source: fluoroCaptureViewModel.detectorIsAnterior?"qrc:/images/PA-cranial.svg":"qrc:/images/AP-cranial.svg"
                            onClicked: fluoroCaptureViewModel.toggleDetectorIsAnterior()
                        }

                        Label {
                            Layout.fillWidth: true
                            state: "body2"
                            color: Theme.navyLight
                            horizontalAlignment: Label.AlignHCenter
                            textFormat: Text.RichText
                            text: {
                                if (fluoroCaptureViewModel.detectorIsAnterior)
                                    return qsTr("View: ") + "<font color=\"" + Theme.white + "\">AP</font>"
                                else
                                    qsTr("View: ") + "<font color=\"" + Theme.white + "\">PA</font>"
                            }
                        }
                    }
                }
            }
        }

        ScrollBar.horizontal: ScrollBar {
            id: scrollBar
            padding: Theme.marginSize
        }

        delegate: FluoroCaptureListElement {
            z: -1
            width: height - (Theme.marginSize * 2)
            height: listView.height - scrollBar.height

            onThumbClicked: fluoroCaptureViewModel.selectShot(roleId)
        }
    }
}
