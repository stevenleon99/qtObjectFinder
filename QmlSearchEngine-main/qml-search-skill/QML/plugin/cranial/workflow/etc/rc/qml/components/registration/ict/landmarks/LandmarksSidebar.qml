import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import IctLandmarksStatesPage 1.0
import GmQml 1.0

import "../.."
import "../../.."

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    IctLandmarksViewModel {
        id: ictLandmarksViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            id: sidebarHeader
            state: "Registration Sidebar"
            title: qsTr("Verify")
            pageNumber: 4
            maxPageNumber: 4
            description: qsTr("Transfer registration when Patient Reference & ICT are visible and site is stable then confirm transfer accuracy.")

            Label {
                Layout.preferredHeight: 64
                state: "body1"
                verticalAlignment: Label.AlignVCenter
                text: qsTr("CHECKS")
                color: Theme.navyLight
            }

            ColumnLayout {
                Layout.fillHeight: false
                spacing: Theme.marginSize

                CheckDelegate {
                    id: surgicalFieldCheckbox
                    enabled: !checked
                    Layout.fillWidth: true
                    text: qsTr("Surgical Field Hasn't Moved")
                    checked: ictLandmarksViewModel.isTransferred || !ictLandmarksViewModel.intraopRegistrationShifted || ictLandmarksViewModel.surgicalFieldValidated

                    MouseArea {
                        anchors { fill: parent }
                        onClicked: ictLandmarksViewModel.validateSurgicalField()
                    }
                }

                CheckDelegate {
                    enabled: surgicalFieldCheckbox.checked && ictLandmarksViewModel.regTransferVisible && !ictLandmarksViewModel.isTransferred
                    Layout.fillWidth: true
                    text: ictLandmarksViewModel.isTransferred ? qsTr("Registration Transferred") : qsTr("Transfer Registration")
                    checked: ictLandmarksViewModel.isTransferred
                    onToggled: ictLandmarksViewModel.registerPatient()

                    IconImage {
                        visible: parent.enabled && !ictLandmarksViewModel.regTransferStable
                        anchors {verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: Theme.marginSize}
                        sourceSize: Theme.iconSize
                        source: "qrc:/images/motion2.svg"
                        color: Theme.yellow
                        rotation: -90
                    }
                }

                CheckDelegate {
                    enabled: ictLandmarksViewModel.isTransferred && !ictLandmarksViewModel.areLandmarksChecked
                    Layout.fillWidth: true
                    text: qsTr("Check Anatomical Landmarks")
                    checked: ictLandmarksViewModel.isTransferred && ictLandmarksViewModel.areLandmarksChecked

                    onToggled: ictLandmarksViewModel.areLandmarksChecked = !ictLandmarksViewModel.areLandmarksChecked
                }

                CheckDelegate {
                    enabled: ictLandmarksViewModel.isTransferred
                    Layout.fillWidth: true
                    text: qsTr("Carefully Remove ICT")
                    checked: ictLandmarksViewModel.isTransferred && ictLandmarksViewModel.isIctRemoved

                    onToggled: ictLandmarksViewModel.isIctRemoved = !ictLandmarksViewModel.isIctRemoved
                }
            }
        }

        LayoutSpacer { }

        PageControls {
            Layout.fillHeight: false

            forwardEnabled: ictLandmarksViewModel.pageState == IctLandmarksStatesPage.Completed || ictLandmarksViewModel.pageState == IctLandmarksStatesPage.CompletedAndWarning

            onBackClicked: ictLandmarksViewModel.pageState == IctLandmarksStatesPage.Completed || ictLandmarksViewModel.pageState == IctLandmarksStatesPage.CompletedAndWarning ? sidebarHeader.resetViewModel.displayRegistrationResetAlert() : applicationViewModel.switchToPage(AppPage.IctFiducial)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.Navigate)
        }
    }

    DividerLine { }
}
