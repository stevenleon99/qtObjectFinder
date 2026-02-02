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
    height: layout.height
    modal: false
    dim: false

    property alias viewportUuid: view2DOrientationViewModel.viewportUuid
    property alias isVolumeView: view2DOrientationViewModel.isVolumeView

    readonly property bool sagittalSelected: view2DOrientationViewModel.is2Dview &&
                                             view2DOrientationViewModel.view2dOrientation == View2DOrientation.Sagittal
    readonly property bool coronalSelected: view2DOrientationViewModel.is2Dview &&
                                            view2DOrientationViewModel.view2dOrientation == View2DOrientation.Coronal
    readonly property bool axialSelected: view2DOrientationViewModel.is2Dview &&
                                          view2DOrientationViewModel.view2dOrientation == View2DOrientation.Axial
    readonly property bool view3dSelected: view2DOrientationViewModel.viewportViewType == ViewportViewType.ViewType3D &&
                                           view2DOrientationViewModel.isVolumeView
    readonly property bool viewXrSelected: view2DOrientationViewModel.viewportViewType == ViewportViewType.ViewTypeXr &&
                                      view2DOrientationViewModel.isVolumeView

    background: Rectangle { radius: Theme.margin(1); color: Theme.slate900 }

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
        id: layout
        width: parent.width
        spacing: 0

        Item {
            objectName: "2DOrientationItem_" + view2DOrientationViewModel.labelList[0]
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            Rectangle { anchors.fill: parent; opacity: 0.16; radius: 4; color: axialSelected ? Theme.blue : Theme.transparent }

            RowLayout {
                anchors { fill: parent }
                spacing: 0

                Item {
                    Layout.preferredWidth: height
                    Layout.fillHeight: true

                    IconImage {
                        visible: axialSelected
                        anchors { centerIn: parent }
                        sourceSize: Theme.iconSize
                        color: Theme.blue
                        source: "qrc:/icons/check.svg"
                    }
                }

                Label {
                    Layout.fillWidth: true
                    state: "body1"
                    font.bold: true
                    text: view2DOrientationViewModel.labelList[0]
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    // MUST call 'close' prior to changing the view type. Changing the view type causes a reset
                    // in all overlay view models so that they can reload their viewport pointers. Closing
                    // while the reset occurs causes a crash.
                    close()
                    view2DOrientationViewModel.setViewOrientationAxial()
                }
            }
        }

        Item {
            objectName: "2DOrientationItem_" + view2DOrientationViewModel.labelList[1]
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            Rectangle { anchors.fill: parent; opacity: 0.16; radius: 4; color: sagittalSelected ? Theme.blue : Theme.transparent }

            RowLayout {
                anchors { fill: parent }
                spacing: 0

                Item {
                    Layout.preferredWidth: height
                    Layout.fillHeight: true

                    IconImage {
                        visible: sagittalSelected
                        anchors { centerIn: parent }
                        sourceSize: Theme.iconSize
                        color: Theme.blue
                        source: "qrc:/icons/check.svg"
                    }
                }

                Label {
                    Layout.fillWidth: true
                    state: "body1"
                    font.bold: true
                    text: view2DOrientationViewModel.labelList[1]
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    // MUST call 'close' prior to changing the view type. Changing the view type causes a reset
                    // in all overlay view models so that they can reload their viewport pointers. Closing
                    // while the reset occurs causes a crash.
                    close()
                    view2DOrientationViewModel.setViewOrientationSagittal()
                }
            }
        }

        Item {
            objectName: "2DOrientationItem_" + view2DOrientationViewModel.labelList[2]
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            Rectangle { anchors.fill: parent; opacity: 0.16; radius: 4; color: coronalSelected ? Theme.blue : Theme.transparent }

            RowLayout {
                anchors { fill: parent }
                spacing: 0

                Item {
                    Layout.preferredWidth: height
                    Layout.fillHeight: true

                    IconImage {
                        visible: coronalSelected
                        anchors { centerIn: parent }
                        sourceSize: Theme.iconSize
                        color: Theme.blue
                        source: "qrc:/icons/check.svg"
                    }
                }

                Label {
                    Layout.fillWidth: true
                    state: "body1"
                    font.bold: true
                    text: view2DOrientationViewModel.labelList[2]
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    // MUST call 'close' prior to changing the view type. Changing the view type causes a reset
                    // in all overlay view models so that they can reload their viewport pointers. Closing
                    // while the reset occurs causes a crash.
                    close()
                    view2DOrientationViewModel.setViewOrientationCoronal()
                }
            }
        }

        Item {
            objectName: "2DOrientationItem_" + view2DOrientationViewModel.labelList[3]
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            Rectangle { anchors.fill: parent; opacity: 0.16; radius: 4; color: view3dSelected ? Theme.blue : Theme.transparent }

            RowLayout {
                anchors { fill: parent }
                spacing: 0

                Item {
                    Layout.preferredWidth: height
                    Layout.fillHeight: true

                    IconImage {
                        visible: view3dSelected
                        anchors { centerIn: parent }
                        sourceSize: Theme.iconSize
                        color: Theme.blue
                        source: "qrc:/icons/check.svg"
                    }
                }

                Label {
                    Layout.fillWidth: true
                    state: "body1"
                    font.bold: true
                    text: view2DOrientationViewModel.labelList[3]
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    // MUST call 'close' prior to changing the view type. Changing the view type causes a reset
                    // in all overlay view models so that they can reload their viewport pointers. Closing
                    // while the reset occurs causes a crash.
                    close()
                    view2DOrientationViewModel.setViewOrientation3D()
                }
            }
        } 

        Item {
            objectName: "2DOrientationItem_" + view2DOrientationViewModel.labelList[4]
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)
            visible: view2DOrientationViewModel.xrEnabled

            Rectangle { anchors.fill: parent; opacity: 0.16; radius: 4; color: viewXrSelected ? Theme.blue : Theme.transparent }

            RowLayout {
                anchors { fill: parent }
                spacing: 0

                Item {
                    Layout.preferredWidth: height
                    Layout.fillHeight: true

                    IconImage {
                        visible: viewXrSelected
                        anchors { centerIn: parent }
                        sourceSize: Theme.iconSize
                        color: Theme.blue
                        source: "qrc:/icons/check.svg"
                    }
                }

                Label {
                    Layout.fillWidth: true
                    state: "body1"
                    font.bold: true
                    text: view2DOrientationViewModel.labelList[4]
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    // MUST call 'close' prior to changing the view type. Changing the view type causes a reset
                    // in all overlay view models so that they can reload their viewport pointers. Closing
                    // while the reset occurs causes a crash.
                    close()
                    view2DOrientationViewModel.setViewOrientationXr()
                }
            }
        }
    }
}
