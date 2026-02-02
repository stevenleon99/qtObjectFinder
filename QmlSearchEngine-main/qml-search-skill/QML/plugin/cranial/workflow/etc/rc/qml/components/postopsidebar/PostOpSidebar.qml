import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import GmQml 1.0

import ".."
import "../trajectorysidebar"
import "../tracking"
import "../registration/fluororegistration"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    PostOpViewModel {
        id: trajectoryViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: Theme.margin(2)

        ColumnLayout {
            spacing: 0

            PostOpWorkflowSelector {
                Layout.fillHeight: false
            }

            TrajectoryHeader {
                presetTrajVisible: false
                newTrajVisible: false
            }

            RowLayout
            {
                Layout.topMargin: Theme.marginSize
                Layout.rightMargin: Theme.marginSize
                Layout.alignment: Qt.AlignHCenter
                spacing: Theme.marginSize

                TrajectoryList { }

                Button {
                    visible: trajectoryViewModel.trajectoryCount > 0
                    state: "icon"
                    icon.source: trajectoryViewModel.isTrajectoryVisible ? "qrc:/icons/visibility-on.svg"
                                                                         : "qrc:/icons/visibility-off.svg"

                    onClicked: trajectoryViewModel.toggleTrajectoryVisibility()
                }
            }
        }

        DividerLine { }

        TrajectorySliderControl {
            visible: trajectoryViewModel.trajectoryCount > 0
        }

        ColumnLayout {
            visible: trajectoryViewModel.trajectoryCount > 0
            spacing: 0

            DividerLine {
                visible: applicationViewModel.currentPage == AppPage.PostOpFluoro
            }

            FluoroCentroid {
                Layout.fillHeight: false
                meterVisible: false
                visible: applicationViewModel.currentPage == AppPage.PostOpFluoro
                isEnable: trajectoryViewModel.isCentroidEnable
            }

            DividerLine { }
        }

        LandmarkControls {
            visible: trajectoryViewModel.trajectoryCount > 0
        }

        ColumnLayout {
            Layout.fillHeight: false
            spacing: 0

            DividerLine {
                visible: trajectoryViewModel.trajectoryCount > 0
            }

            RenderPosition {
                visible: applicationViewModel.currentPage == AppPage.PostOpCt
                Layout.leftMargin: Theme.marginSize
                Layout.rightMargin: Theme.marginSize
            }

            ProbeOffsetComponent {
                visible: toolsVisibilityViewModel.isProbeDisplayed
            }

            InstrumentPlanningComponent {
                visible: toolsVisibilityViewModel.isProbeDisplayed
                Layout.leftMargin: Theme.marginSize
                Layout.rightMargin: Theme.marginSize
                Layout.bottomMargin: Theme.marginSize
                Layout.fillWidth: true
                Layout.preferredWidth: 1
            }
        }

        PageControls {
            forwardEnabled: false

            onBackClicked: applicationViewModel.laptopTypeEnabled?applicationViewModel.switchToPage(AppPage.Trajectory):applicationViewModel.switchToPage(AppPage.Navigate)
        }
    }

    DividerLine {
        anchors { left: parent.left }
    }
}
