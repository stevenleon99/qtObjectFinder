import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import SurfaceMeshPageState 1.0
import GmQml 1.0

import "../.."
import "../../.."
import "../../../tracking"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    SurfaceMeshViewModel {
        id: surfaceMeshViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            state: "Registration Sidebar"
            title: qsTr("Generate Mesh")
            pageNumber: 2
            maxPageNumber: 5
            description: qsTr("Generate a 3D volume from the patient scan.")

            RowLayout
            {
                Layout.preferredHeight: 32
                Layout.fillWidth: true
                Layout.topMargin: Theme.marginSize
                Label {

                    Layout.fillWidth: true
                    Layout.alignment: Layout.left
                    state: "body1"
                    verticalAlignment: Label.AlignVCenter
                    text: qsTr("Threshold (intensity)")
                    color: Theme.navyLight
                }
                Label {

                    Layout.alignment: Layout.right
                    state: "subtitle1"
                    verticalAlignment: Label.AlignVCenter
                    text: surfaceMeshViewModel.threshold
                    color: Theme.white
                    font.bold: true
                }
            }

            Slider {
                visible: true
                Layout.preferredWidth: Theme.margin(37)
                Layout.preferredHeight: Theme.margin(4)
                Layout.leftMargin: Theme.marginSize
                Layout.topMargin: Theme.marginSize
                padding: 0
                orientation: Qt.Horizontal
                from: surfaceMeshViewModel.minThreshold
                value: surfaceMeshViewModel.threshold
                to: surfaceMeshViewModel.maxThreshold

                onValueChanged: surfaceMeshViewModel.threshold = value
            }

            RowLayout
            {
                Layout.preferredHeight: 32
                Layout.fillWidth: true
                Layout.topMargin: Theme.marginSize
                Label {
                    Layout.fillWidth: true
                    state: "body1"
                    verticalAlignment: Label.AlignVCenter
                    text: qsTr("Smoothing (pixels)")
                    color: Theme.navyLight
                }
                Label {
                    Layout.alignment: Layout.right
                    state: "subtitle1"
                    verticalAlignment: Label.AlignVCenter
                    text: surfaceMeshViewModel.smoothing
                    color: Theme.white
                    font.bold: true
                }
            }

            Slider {
                visible: true
                Layout.preferredWidth: Theme.margin(37)
                Layout.preferredHeight: Theme.margin(4)
                Layout.leftMargin: Theme.marginSize
                Layout.topMargin: Theme.marginSize
                padding: 0
                orientation: Qt.Horizontal
                from: 0
                value: surfaceMeshViewModel.smoothing
                to: 5

                onValueChanged: surfaceMeshViewModel.smoothing = value
            }


            Button {
                Layout.topMargin: Theme.marginSize
                visible: true
                enabled: !surfaceMeshViewModel.isTaskRunning
                Layout.fillWidth: true
                state: !surfaceMeshViewModel.isTaskRunning?"active":"hinted"
                text: "Generate"

                onClicked: {
                    if (enabled)
                        surfaceMeshViewModel.runSkinExtraction();
                }
            }
        }
        LayoutSpacer { }


        PageControls {
            Layout.fillHeight: false
            forwardEnabled: surfaceMeshViewModel.pageState == SurfaceMeshPageState.Mesh
            backEnabled: true

            onBackClicked: applicationViewModel.switchToPage(AppPage.SurfaceSetup)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.SurfaceFiducial)
        }
    }

    DividerLine { }
}
