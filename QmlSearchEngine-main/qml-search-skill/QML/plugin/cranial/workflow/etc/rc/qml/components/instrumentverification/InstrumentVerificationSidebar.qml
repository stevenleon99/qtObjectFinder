import QtQuick 2.4
import QtGraphicalEffects 1.0
import QtQuick.Layouts 1.12

import ViewModels 1.0
import AppPage 1.0
import GmQml 1.0

import ".."

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        InstrumentVerificationList { }

        PageControls {
            Layout.fillHeight: false
            forwardEnabled: true

            onBackClicked: applicationViewModel.switchToPage(AppPage.Trajectory)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.PatientRegistrationSelect)
        }
    }

    DividerLine { }
}
