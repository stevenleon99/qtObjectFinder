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
import "../viewports"

Item {
    id: viewLabelOverlay
    visible: viewLabelOVM.isDisplayed

    property var renderer

    ViewLabelOverlayViewModel {
        id: viewLabelOVM
        viewport: renderer
    }

    Item {
        anchors { top: parent.top; left: parent.left; leftMargin: Theme.margin(1); topMargin: 12 }

        width: rowLayout.width
        height: Theme.margin(5)

        Rectangle {
            opacity: 0.16
            radius: 4
            anchors { fill: parent }
            color: orientationPopup.visible ? Theme.blue : Theme.transparent
        }

        RowLayout {
            id: rowLayout
            spacing: 0

            View2DOrientationPopup {
                id: orientationPopup
                visible: false
                viewportUuid: renderer.viewportUid
            }

            Label {
                objectName: "viewLabelText"
                id: label
                Layout.preferredHeight: Theme.margin(5)
                leftPadding: Theme.margin(1)
                state: "subtitle2"
                color: Theme.white
                text: viewLabelOVM.viewLabel
                verticalAlignment: Text.AlignVCenter

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        if (orientationPopup.isVolumeView && !orientationPopup.visible)
                            orientationPopup.setup(this)
                    }
                }
            }

            IconImage {
                objectName: "viewLabelIcon"
                sourceSize: Theme.iconSize
                source: "qrc:/icons/caret-down"
                color: orientationPopup.visible ? Theme.blue : Theme.white

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        if (orientationPopup.isVolumeView && !orientationPopup.visible)
                            orientationPopup.setup(label)
                    }
                }
            }
        }
    }
}
