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

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    TrajectoryViewModel {
        id: trajectoryViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        NavigateHeader {
            id: navigateHeader
        }

        ReachabilityList {
            visible: navigateHeader.reachabilityCheckEnabled
        }

        ColumnLayout {
            visible: !navigateHeader.reachabilityCheckEnabled
            spacing: Theme.margin(2)

            TrajectoryList {
                id: trajectoryList
                Layout.fillHeight: false
            }

            NavigateControls {
                visible: trajectoryList.trajectorySelected
                Layout.fillHeight: false
            }

            ImplantLength {
                visible: trajectoryList.trajectorySelected
                Layout.fillHeight: false
            }

            NavigateAccTestControls {
                visible: applicationViewModel.testModeEnabled && !navigateHeader.reachabilityCheckEnabled
            }

            LayoutSpacer { }
        }

        DividerLine { }

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

        PageControls {
            Layout.fillHeight: false

            onBackClicked: applicationViewModel.switchToPage(AppPage.PatientRegistrationSelect)
            onForwardClicked: applicationViewModel.switchToPage(AppPage.PostOpCt)
        }
    }

    DividerLine {
        anchors { left: parent.left }
    }
}
