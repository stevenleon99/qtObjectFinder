import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import ViewportEnums 1.0
import GmQml 1.0


Popup {
    id: popup
    width: 328
    height: 240

    background: Rectangle { radius: Theme.margin(1); color: Theme.foregroundColor }

    ClipSliceViewModel {
        id: clipSliceViewModel
    }

    function setup(positionItem) {
        var bottomLeft = positionItem.mapToItem(null, 0, positionItem.height)
        x = bottomLeft.x
        y = bottomLeft.y - 200

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
                        source: "qrc:/images/image-thru.svg"
                        sourceSize: Theme.iconSize
                        color: Theme.white
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Slice Image")
                        color: Theme.white
                    }

                    LayoutSpacer {}

                    IconImage {
                        visible: clipSliceViewModel.isSliceSliderVisible
                        source: "qrc:/icons/check.svg"
                        sourceSize: Theme.iconSize
                        color: Theme.blue
                    }
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    clipSliceViewModel.toggleSliceSliderVisibility()
                }
            }
        }

        Rectangle {
            width: popup.width  // Adjust the width as needed
            height: 2   // Height of the line
            color: Theme.backgroundColor  // Color of the line
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
                        source: "qrc:/images/crop-wide.svg"
                        sourceSize: Theme.iconSize
                        color: Theme.white
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Clip 3D")
                        color: Theme.white
                    }

                    LayoutSpacer {}

                    IconImage {
                        visible: clipSliceViewModel.isClipping
                        source: "qrc:/icons/check.svg"
                        sourceSize: Theme.iconSize
                        color: Theme.blue
                    }
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    clipSliceViewModel.toggleHaveClippedVolumes()
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
                    Layout.leftMargin: 48
                    Layout.rightMargin: Theme.marginSize / 2

                    IconImage {
                        source: "qrc:/images/image-3D.svg"
                        sourceSize: Theme.iconSize
                        color: Theme.white
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Clip Objects")
                        color: Theme.white
                    }

                    LayoutSpacer {}

                    IconImage {
                        visible: clipSliceViewModel.isClippingCads && clipSliceViewModel.isClipping
                        source: "qrc:/icons/check.svg"
                        sourceSize: Theme.iconSize
                        color: Theme.blue
                    }
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    clipSliceViewModel.toggleHaveClippedCads()
                }
            }
        }

        //        LayoutSpacer {}

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors { fill: parent }
                spacing: Theme.marginSize / 2

                RowLayout {
                    Layout.leftMargin: 48
                    Layout.rightMargin: Theme.marginSize / 2

                    IconImage {
                        id: flipIcon
                        source: "qrc:/images/flip-horizontal.svg"
                        sourceSize: Theme.iconSize
                        color: Theme.white//clipSliceViewModel.isSliceSliderVisible?Theme.white:Theme.disabledColor
                        mirror: true
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Flip Clip")
                        color: Theme.white//clipSliceViewModel.isSliceSliderVisible?Theme.white:Theme.disabledColor
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    clipSliceViewModel.flipClip();
                    flipIcon.mirror = !flipIcon.mirror;
                }
            }
        }

    }
}
