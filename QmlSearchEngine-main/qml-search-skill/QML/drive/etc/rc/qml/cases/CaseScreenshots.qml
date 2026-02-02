import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4
import QtGraphicalEffects 1.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import "../components"

GridView {
    id: grid
    anchors.fill: parent
    cellWidth: width/2
    cellHeight: cellWidth + Theme.margin(1)
    clip: true

    model: SortFilterProxyModel { sourceModel: screenshotsViewModel.screenshotList }

    delegate: Item {
        width: grid.cellWidth
        height: grid.cellHeight

        Rectangle {
            id: rect
            x: (index % 2) ? Theme.margin(1) : 0
            width: Theme.margin(29)
            height: width
            radius: Theme.margin(1)
            color: Theme.black

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 0

                Button {
                    Layout.alignment: Qt.AlignRight
                    state: "icon"
                    icon.source: "qrc:/icons/trash.svg"

                    onClicked: screenshotsViewModel.deleteScreenshot(role_screenshot_id)
                }

                Image {
                    Layout.preferredWidth: Theme.margin(29)
                    Layout.preferredHeight: 131

                    source: "file:///" + role_path

                    MouseArea {
                        anchors { fill: parent }
                        onClicked: {
                            imageViewerPopup.model = grid.model;
                            imageViewerPopup.index = index;
                            imageViewerPopup.open();
                        }
                    }

                    LinearGradient {
                        width: Theme.margin(4)
                        height: parent.height
                        anchors { left: parent.left }
                        opacity: 0.1
                        start: Qt.point(0, 0)
                        end: Qt.point(32, 0)
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Theme.black }
                            GradientStop { position: 1.0; color: Theme.transparent }
                        }
                    }

                    LinearGradient {
                        width: Theme.margin(4)
                        height: parent.height
                        anchors { right: parent.right }
                        opacity: 0.1
                        start: Qt.point(0, 0)
                        end: Qt.point(32, 0)
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Theme.transparent }
                            GradientStop { position: 1.0; color: Theme.black }
                        }
                    }
                }

                IconImage {
                    Layout.leftMargin: Theme.marginSize
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/icons/image-screenshot.svg"
                    sourceSize: Theme.iconSize
                }
            }
        }
    }

    ImageViewerPopup {
        id: imageViewerPopup
        dateVisible: true
    }

    Component.onCompleted: grid.model.setSort("role_date", Qt.DescendingOrder)
}
