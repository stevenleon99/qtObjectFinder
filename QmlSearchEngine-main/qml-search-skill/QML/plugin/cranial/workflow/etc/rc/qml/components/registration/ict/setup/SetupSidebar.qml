import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import IctSnapshotStatesPage 1.0
import GmQml 1.0

import "../.."
import "../../.."

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    IctSnapshotViewModel {
        id: ictSnapshotViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            id: sidebarHeader
            state: "Registration Sidebar"
            title: qsTr("Setup")
            pageNumber: 1
            maxPageNumber: 4
            description: qsTr("Select the target patient reference array type and capture the surgical area.")

            Label {
                Layout.preferredHeight: 64
                state: "body1"
                verticalAlignment: Label.AlignVCenter
                text: qsTr("PATIENT REFERENCE")
                color: Theme.navyLight
            }

            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: Theme.margin(1.5)
                spacing: Theme.margin(2)

                RadioButton {
                    enabled: ictSnapshotViewModel.isDRBEnabled
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    checked: ictSnapshotViewModel.isDrb
                    text: qsTr("DRB Array")

                    onClicked: ictSnapshotViewModel.setPatRefDrb()
                }

                RadioButton {
                    enabled: ictSnapshotViewModel.isCRWEnabled
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    checked: ictSnapshotViewModel.isCrw
                    text: qsTr("FRA CRW")

                    onClicked: ictSnapshotViewModel.setPatRefCrw()
                }

                RadioButton {
                    enabled: ictSnapshotViewModel.isLeksellEnabled
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    checked: ictSnapshotViewModel.isLeksell
                    text: qsTr("FRA Leksell")

                    onClicked: ictSnapshotViewModel.setPatRefLeksell()
                }
            }
        }
        LayoutSpacer { }

        PageControls {
            Layout.fillHeight: false

            forwardEnabled: ictSnapshotViewModel.pageState == IctSnapshotStatesPage.SnapshotTaken

            onBackClicked: sidebarHeader.resetViewModel.displayRegistrationResetAlert()

            onForwardClicked: applicationViewModel.switchToPage(AppPage.IctFiducial)

        }
    }

    DividerLine { }
}
