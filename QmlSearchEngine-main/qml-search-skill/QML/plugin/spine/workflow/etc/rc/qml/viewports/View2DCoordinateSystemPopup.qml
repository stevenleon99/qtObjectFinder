import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import ViewportEnums 1.0
import GmQml 1.0


Popup {
    width: 240
    height: 144

    background: Rectangle { radius: Theme.margin(1); color: Theme.backgroundColor }

    View2DCoordinateSystemViewModel {
        id: view2DCoordinateSystemViewModel
    }

    property var coordinateType: view2DCoordinateSystemViewModel.view2dCoordinateType

    function setup(positionItem) {
        var bottomLeft = positionItem.mapToItem(null, 0, positionItem.height)
        x = bottomLeft.x
        y = bottomLeft.y

        open()
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors { fill: parent }
                spacing: Theme.marginSize / 2

                RowLayout {
                    Layout.leftMargin: Theme.marginSize / 2
                    Layout.rightMargin: Theme.marginSize / 2

                    IconImage {
                        source: "qrc:/images/crosshair-image.svg"
                        sourceSize: Theme.iconSize
                        color: view2DCoordinateSystemViewModel.view2dCoordinateType == View2DCoordinateType.Volume ? Theme.blue : Theme.disabledColor
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Volume-centric")
                        color: Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    view2DCoordinateSystemViewModel.setViewCoordinateTypeVolume()
                    coordinateSystemPopup.visible = false;
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors { fill: parent }
                spacing: Theme.marginSize / 2

                RowLayout {
                    Layout.leftMargin: Theme.marginSize / 2
                    Layout.rightMargin: Theme.marginSize / 2

                    IconImage {
                        source: "qrc:/images/crosshair-trajectory.svg"
                        sourceSize: Theme.iconSize
                        color: view2DCoordinateSystemViewModel.view2dCoordinateType == View2DCoordinateType.ActiveTrajectory ? Theme.blue : Theme.disabledColor
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Trajectory-centric")
                        color: Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    view2DCoordinateSystemViewModel.setViewCoordinateTypeActiveTrajectory()
                    coordinateSystemPopup.visible = false;
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors { fill: parent }
                spacing: Theme.marginSize / 2

                RowLayout {
                    Layout.leftMargin: Theme.marginSize / 2
                    Layout.rightMargin: Theme.marginSize / 2

                    IconImage {
                        source: "qrc:/images/crosshair-tool.svg"
                        sourceSize: Theme.iconSize
                        color: view2DCoordinateSystemViewModel.view2dCoordinateType == View2DCoordinateType.ActiveTool ? Theme.blue : Theme.disabledColor
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Tool-centric")
                        color: Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    view2DCoordinateSystemViewModel.setViewCoordinateTypeActiveTool()
                    coordinateSystemPopup.visible = false;
                }
            }
        }
    }
}
