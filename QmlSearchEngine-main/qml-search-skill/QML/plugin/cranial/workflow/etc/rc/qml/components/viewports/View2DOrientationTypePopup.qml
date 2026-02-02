import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import ViewportEnums 1.0
import GmQml 1.0


Popup {
    width: 260
    height: 144

    property alias view2dOrientationType: view2DOrientationTypeViewModel.view2dOrientationType

    background: Rectangle { radius: Theme.margin(1); color: Theme.backgroundColor }

    View2DOrientationTypeViewModel {
        id: view2DOrientationTypeViewModel
    }

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
                        source: "qrc:/images/orientation-LR.svg"
                        sourceSize: Theme.iconSize
                        color: view2dOrientationType == View2DOrientationType.Neuro ? Theme.blue : Theme.white
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Neurological Orientation")
                        color: view2dOrientationType == View2DOrientationType.Neuro ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    view2DOrientationTypeViewModel.setOrientationTypeNeuro()
                    view2DOrientationTypePopup.visible = false
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
                        source: "qrc:/images/orientation-RL.svg"
                        sourceSize: Theme.iconSize
                        color: view2dOrientationType == View2DOrientationType.Radio ? Theme.blue : Theme.white
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Radiological Orientation")
                        color: view2dOrientationType == View2DOrientationType.Radio ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    view2DOrientationTypeViewModel.setOrientationTypeRadio()
                    view2DOrientationTypePopup.visible = false
                }
            }
        }
    }
}
