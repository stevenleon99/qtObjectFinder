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
	visible: orientation3dOVM.isDisplayed
    property var renderer

    Orientation3dOverlayViewModel {
        id: orientation3dOVM
        viewport: renderer
    }

    RowLayout {
        //anchors { right: parent.right; top: parent.top; topMargin: Theme.margin(1); rightMargin: Theme.margin(16) }
        anchors { horizontalCenter: parent.horizontalCenter; top: parent.top; topMargin: Theme.margin(1) }
        spacing: Theme.margin(2)

        Rectangle {
            Layout.preferredWidth: orientationPresetLayout.width
            Layout.preferredHeight: Theme.margin(5)
            radius: 4
            color: Theme.transparent
            border.color: Theme.white

            RowLayout {
                id: orientationPresetLayout
                anchors { centerIn: parent }
                spacing: 0
       
                Button {
                    state: "icon"
                    icon.source: "qrc:/images/brain-axial.svg"

                    onClicked: {
                        orientation3dOVM.setView3dOrientation(ViewOrientation.Axial); 
                    }
                }

                Button {

                    state: "icon"
                    icon.source: "qrc:/images/brain-coronal.svg"
                    onClicked: {
                        orientation3dOVM.setView3dOrientation(ViewOrientation.Coronal);
                    }
                }

                Button {
                    state: "icon"
                    icon.source: "qrc:/images/brain-sagittal.svg"

                    onClicked: {
                        orientation3dOVM.setView3dOrientation(ViewOrientation.Sagittal);
                    }
                }
            }
        }
    }
}

