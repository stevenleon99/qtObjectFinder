import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import ViewportEnums 1.0
import GmQml 1.0

Popup {
    width: 150
    height: 144

    property alias viewportUuid: view2DOrientationViewModel.viewportUuid
    property alias isVolumeView: view2DOrientationViewModel.isVolumeView

    background: Rectangle { radius: Theme.margin(1); color: Theme.backgroundColor }

    View2DOrientationViewModel {
        id: view2DOrientationViewModel
    }

    property var coordinateType: view2DOrientationViewModel.view2dCoordinateType

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

                    Label {
                        state: "body1"
                        text: view2DOrientationViewModel.labelList[0]
                        color: view2DOrientationViewModel.is2Dview &&
                               view2DOrientationViewModel.view2dOrientation == View2DOrientation.Sagittal ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked:
                {
                    close()
                    view2DOrientationViewModel.setViewOrientationSagittal()
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

                    Label {
                        state: "body1"
                        text: view2DOrientationViewModel.labelList[1]
                        color:view2DOrientationViewModel.is2Dview &&
                              view2DOrientationViewModel.view2dOrientation == View2DOrientation.Coronal ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    close()
                    view2DOrientationViewModel.setViewOrientationCoronal()
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

                    Label {
                        state: "body1"
                        text: view2DOrientationViewModel.labelList[2]
                        color: view2DOrientationViewModel.is2Dview &&
                               view2DOrientationViewModel.view2dOrientation == View2DOrientation.Axial ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    close()
                    view2DOrientationViewModel.setViewOrientationAxial()
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

                    Label {
                        state: "body1"
                        text: view2DOrientationViewModel.labelList[3]
                        color: !view2DOrientationViewModel.is2Dview &&
                               view2DOrientationViewModel.isVolumeView ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    close()
                    view2DOrientationViewModel.setViewOrientation3D()
                }
            }
        }
    }
}
