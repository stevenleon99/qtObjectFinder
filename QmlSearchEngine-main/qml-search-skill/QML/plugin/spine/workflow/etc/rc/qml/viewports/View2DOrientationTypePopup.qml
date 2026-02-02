import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import ViewportEnums 1.0
import GmQml 1.0


Popup {
    width: Theme.margin(30)
    height: Theme.margin(32)
    modal: false
    dim: false

    property alias view2dLRType: view2DOrientationTypeViewModel.view2dLRType
    property alias view2dSIType: view2DOrientationTypeViewModel.view2dSIType

    background: Rectangle { radius: Theme.margin(1); color: Theme.slate900 }

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
                    Layout.leftMargin: Theme.margin(2)
                    Layout.rightMargin: Theme.margin(2)
                    spacing: Theme.margin(2)

                    IconImage {
                        source: "qrc:/images/orientation-LR.svg"
                        sourceSize: Theme.iconSize
                        color: view2dLRType == View2DLRType.LeftRight ? Theme.blue : Theme.white
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Left-Right")
                        color: view2dLRType == View2DLRType.LeftRight ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                objectName: "leftRightOption"  
                anchors { fill: parent }
                onClicked: {
                    view2DOrientationTypeViewModel.setLROrientationType(View2DLRType.LeftRight)
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
                    Layout.leftMargin: Theme.margin(2)
                    Layout.rightMargin: Theme.margin(2)
                    spacing: Theme.margin(2)

                    IconImage {
                        source: "qrc:/images/orientation-RL.svg"
                        sourceSize: Theme.iconSize
                        color: view2dLRType == View2DLRType.RightLeft ? Theme.blue : Theme.white
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Right-Left")
                        color: view2dLRType == View2DLRType.RightLeft ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                objectName: "rightLeftOption" 
                anchors { fill: parent }
                onClicked: {
                    view2DOrientationTypeViewModel.setLROrientationType(View2DLRType.RightLeft)
                    view2DOrientationTypePopup.visible = false
                }
            }
        }

        DividerLine { color: Theme.slate700 }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors { fill: parent }
                spacing: Theme.marginSize / 2

                RowLayout {
                    Layout.leftMargin: Theme.margin(2)
                    Layout.rightMargin: Theme.margin(2)
                    spacing: Theme.margin(2)

                    IconImage {
                        source: "qrc:/images/orientation-SI.svg"
                        sourceSize: Theme.iconSize
                        color: view2dSIType == View2DSIType.SuperiorInferior ? Theme.blue : Theme.white
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Superior-Inferior")
                        color: view2dSIType == View2DSIType.SuperiorInferior ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                objectName: "superiorInferiorOption"  
                anchors { fill: parent }
                onClicked: {
                    view2DOrientationTypeViewModel.setSIOrientationType(View2DSIType.SuperiorInferior)
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
                    Layout.leftMargin: Theme.margin(2)
                    Layout.rightMargin: Theme.margin(2)
                    spacing: Theme.margin(2)

                    IconImage {
                        source: "qrc:/images/orientation-IS.svg"
                        sourceSize: Theme.iconSize
                        color: view2dSIType == View2DSIType.InferiorSuperior ? Theme.blue : Theme.white
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Inferior-Superior")
                        color: view2dSIType == View2DSIType.InferiorSuperior ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                objectName: "inferiorSuperiorOption"  
                anchors { fill: parent }
                onClicked: {
                    view2DOrientationTypeViewModel.setSIOrientationType(View2DSIType.InferiorSuperior)
                    view2DOrientationTypePopup.visible = false
                }
            }
        }
    }
}
