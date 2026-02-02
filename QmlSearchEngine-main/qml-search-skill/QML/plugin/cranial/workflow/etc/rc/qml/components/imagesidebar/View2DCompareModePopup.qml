import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import ViewportEnums 1.0
import GmQml 1.0


Popup {
    id: compareModePopup
    width: 240
    height: 144

    background: Rectangle { radius: Theme.margin(1); color: Theme.white }

    View2DCompareModeViewModel {
        id: view2DCompareModeViewModel
    }

    property var compareMode: view2DCompareModeViewModel.compareMode

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
                        source: "qrc:/icons/image-single.svg"
                        sourceSize: Theme.iconSize
                        color: compareModePopup.compareMode == CompareMode.Single ? Theme.blue : Theme.disabledColor
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Single")
                        color: Theme.black
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    view2DCompareModeViewModel.setCompareModeSingle();
                    compareModePopup.visible = false;
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
                        source: "qrc:/icons/checkerboard.svg"
                        sourceSize: Theme.iconSize
                        color: compareModePopup.compareMode == CompareMode.CheckerBoard ? Theme.blue : Theme.disabledColor
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Checkerboard")
                        color: Theme.black
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    view2DCompareModeViewModel.setCompareModeCheckerboard();
                    compareModePopup.visible = false;
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
                        source: "qrc:/icons/blend.svg"
                        sourceSize: Theme.iconSize
                        color: compareModePopup.compareMode == CompareMode.Alpha ? Theme.blue : Theme.disabledColor
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Blend Mode")
                        color: Theme.black
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    view2DCompareModeViewModel.setCompareModeAlpha();
                    compareModePopup.visible = false;
                }
            }
        }
    }
}
