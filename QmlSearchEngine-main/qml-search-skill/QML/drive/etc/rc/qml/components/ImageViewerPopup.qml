import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtGraphicalEffects 1.0

import Theme 1.0
import GmQml 1.0

Popup {
    id: popup

    width: parent.width
    height: parent.height
    closePolicy: Popup.NoAutoClose

    background: Rectangle { color: Qt.rgba(0, 0, 0, 0.75) }

    property alias model: imageList.model
    property alias index: imageList.currentIndex
    property alias iconSource: icon.source
    property alias titleText: title.text
    property alias dateVisible: date.visible

    ColumnLayout {
        id: columnLayout
        anchors { fill: parent }
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(10)

            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.black }
                GradientStop { position: 1.0; color: Theme.transparent }
            }

            RowLayout {
                anchors { fill: parent; leftMargin: Theme.margin(4); rightMargin: Theme.margin(2) }
                spacing: 0

                IconImage {
                    id: icon
                    Layout.alignment: Qt.AlignVCenter
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/icons/image-screenshot.svg"
                    sourceSize: Theme.iconSize
                }

                Label {
                    Layout.fillWidth: true
                    state: "subtitle1"
                    rightPadding: Theme.marginSize
                    text: (imageList.currentIndex + 1 ) + "/" + imageList.count
                    verticalAlignment: Label.AlignVCenter
                    horizontalAlignment: Label.AlignHCenter
                    font.bold: true

                    RowLayout {
                        spacing: 0
                        Label {
                            id: title
                            visible: text
                            state: "subtitle1"
                            leftPadding: Theme.marginSize
                            verticalAlignment: Label.AlignVCenter
                            font.bold: true
                        }
                        Label {
                            id: date
                            visible: false
                            state: "subtitle1"
                            leftPadding: Theme.marginSize
                            text: imageList.currentItem ? imageList.currentItem.capturedDate : ""
                            verticalAlignment: Label.AlignVCenter
                            font.bold: true
                        }
                    }
                }

                IconImage {
                    Layout.alignment: Qt.AlignVCenter
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/icons/x.svg"
                    sourceSize: Theme.iconSize

                    MouseArea {
                        anchors.fill: parent
                        onClicked: popup.close()
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            spacing: 62

            Button {
                enabled: imageList.currentIndex != 0
                Layout.preferredWidth: Theme.margin(8)
                Layout.preferredHeight: Theme.margin(8)
                state: "icon"
                icon.source: "qrc:/icons/arrow.svg"
                icon.color: Theme.white

                onClicked: imageList.currentIndex = (imageList.currentIndex - 1)
            }

            Item {
                Layout.preferredWidth: Theme.margin(204.5)
                Layout.preferredHeight: Theme.margin(115)

                ListView {
                    id: imageList
                    anchors { centerIn: parent }
                    width: Theme.margin(204.5)
                    height: Theme.margin(115)
                    interactive: false
                    orientation: ListView.Horizontal
                    highlightFollowsCurrentItem: true
                    highlightMoveDuration: 0
                    clip: true

                    delegate: Image {
                        width: imageList.width
                        height: imageList.height
                        source: "file:///" + role_path

                        property string capturedDate: dateVisible ? role_date : ""
                    }
                }
            }

            Button {
                enabled: imageList.currentIndex < (imageList.count - 1)
                Layout.preferredWidth: Theme.margin(8)
                Layout.preferredHeight: Theme.margin(8)
                rotation: 180
                state: "icon"
                icon.source: "qrc:/icons/arrow.svg"

                onClicked: imageList.currentIndex = (imageList.currentIndex + 1)
            }
        }

        LayoutSpacer { Layout.preferredHeight: Theme.margin(10) }

    }
}
