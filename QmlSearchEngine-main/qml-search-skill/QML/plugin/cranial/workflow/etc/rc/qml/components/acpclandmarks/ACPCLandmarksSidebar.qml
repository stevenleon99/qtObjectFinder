import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import GmQml 1.0

import ".."
import "../trajectorysidebar"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    OrientViewModel {
        id: orientViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        ACPCLandmarksList {
            Layout.fillHeight: false
            distance: orientViewModel.acpcDistance < 0 ? "-" : orientViewModel.acpcDistance.toFixed(2)

            onLandmarkClickedParent: orientViewModel.goToLandmark(landmark)
            onResetClickedParent: orientViewModel.resetLandmark(landmark)
            onSetClickedParent: orientViewModel.setLandmark(landmark)
        }

        LayoutSpacer { }

        DividerLine { }

        RenderPosition {
            Layout.topMargin: Theme.marginSize
			Layout.bottomMargin: Theme.marginSize
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize

		    areDistancesVisible: false 
        }

        PageControls {
            Layout.fillHeight: false
            forwardEnabled: true

            onBackClicked: applicationViewModel.switchToPage(AppPage.Merge)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.Trajectory)
        }
    }

    DividerLine { }
}
