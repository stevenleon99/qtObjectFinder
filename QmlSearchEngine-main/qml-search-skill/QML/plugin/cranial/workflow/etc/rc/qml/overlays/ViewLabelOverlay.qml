/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import ViewportEnums 1.0
import "../components/viewports"

Item {
    id: viewLabelOverlay
    visible: viewLabelOVM.isDisplayed

    property var renderer

    ViewLabelOverlayViewModel {
        id: viewLabelOVM
        viewport: renderer
    }

    ColumnLayout {
        anchors { top: parent.top; left: parent.left; margins: Theme.marginSize / 2 }
        spacing: 0

        RowLayout {
            spacing: 0

            View2DOrientationPopup {
                id: orientationPopup
                visible: false
                viewportUuid: renderer.viewportUid
            }

            Label {
                id: label
                state: "subtitle1"
                color: Theme.white
                text: viewLabelOVM.viewLabel

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (orientationPopup.isVolumeView)
                            orientationPopup.setup(this)}
                }
            }

            IconImage {
                sourceSize: Qt.size(20, 20)
                source: "qrc:/icons/carrot.svg"
                color: Theme.white

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (orientationPopup.isVolumeView)
                            orientationPopup.setup(label)}
                }
            }
        }

        Button {
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: -Theme.marginSize / 2
            Layout.topMargin: Theme.marginSize
            visible: viewType !== ImageViewport.ThreeD
            state: "icon"
            icon.source: "qrc:/images/crosshair-image.svg"
            color: (viewLabelOVM.view2dCoordinateType == View2DCoordinateType.Volume) ? Theme.white : Theme.disabledColor
            onClicked: viewLabelOVM.setView2dCoordinateTypeView(View2DCoordinateType.Volume)
        }

        Button {
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: -Theme.marginSize / 2
            visible: viewType !== ImageViewport.ThreeD
            state: "icon"
            icon.source: "qrc:/images/crosshair-trajectory.svg"
            color: (viewLabelOVM.view2dCoordinateType == View2DCoordinateType.ActiveTrajectory) ? Theme.white : Theme.disabledColor
            onClicked: viewLabelOVM.setView2dCoordinateTypeView(View2DCoordinateType.ActiveTrajectory)
        }

        Button {
            Layout.alignment: Qt.AlignLeft
            Layout.leftMargin: -Theme.marginSize / 2
            visible: viewType !== ImageViewport.ThreeD
            state: "icon"
            icon.source: "qrc:/images/crosshair-tool.svg"
            color: (viewLabelOVM.view2dCoordinateType == View2DCoordinateType.ActiveTool) ? Theme.white : Theme.disabledColor
            onClicked: viewLabelOVM.setView2dCoordinateTypeView(View2DCoordinateType.ActiveTool)
        }
    }
}
