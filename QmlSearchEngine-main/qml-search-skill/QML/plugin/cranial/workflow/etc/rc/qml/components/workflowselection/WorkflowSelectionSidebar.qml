import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import PatRegSelectPageState 1.0
import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import Enums 1.0

import GmQml 1.0

import ".."

Item {
    id: sidebar
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    WorkflowSelectionSidebarViewModel {
        id: workflowSelectionSidebarViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        Layout.margins: 0
        spacing: 0

        LayoutSpacer { }

        LayoutSpacer { }

        PageControls {
            Layout.fillHeight: false
            forwardEnabled: workflowSelectionSidebarViewModel.isNextButtonEnabled
            onBackClicked: applicationViewModel.switchToPage(AppPage.InstrumentVerification)

            onForwardClicked: workflowSelectionSidebarViewModel.swithToWorkFlowPage();
        }
    }
}
