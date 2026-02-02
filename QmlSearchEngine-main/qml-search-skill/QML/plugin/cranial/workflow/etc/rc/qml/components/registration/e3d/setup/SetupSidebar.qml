import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import E3DSetupStatesPage 1.0
import GmQml 1.0
import Enums 1.0

import "../.."
import "../../.."
import "../../../tracking"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    E3DSetupViewModel {
        id: e3DSetupViewModel
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
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    checked: e3DSetupViewModel.isDrb
                    text: qsTr("DRB Array")

                    onClicked: e3DSetupViewModel.setPatRefDrb()
                }

                RadioButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    checked: e3DSetupViewModel.isCrw
                    text: qsTr("FRA CRW")

                    onClicked: e3DSetupViewModel.setPatRefCrw()
                }

                RadioButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(3.25)
                    checked: e3DSetupViewModel.isLeksell
                    text: qsTr("FRA Leksell")

                    onClicked: e3DSetupViewModel.setPatRefLeksell()
                }
            }
        }

        LayoutSpacer { }

        PageControls {
            Layout.fillHeight: false

            forwardEnabled: e3DSetupViewModel.pageState == E3DSetupStatesPage.PatRefSelected && e3DSetupViewModel.isPatRefE3DVisible

            onBackClicked: sidebarHeader.resetViewModel.displayRegistrationResetAlert()

            onForwardClicked: applicationViewModel.switchToPage(AppPage.E3dImage)
        }
    }

    DividerLine { }
}
