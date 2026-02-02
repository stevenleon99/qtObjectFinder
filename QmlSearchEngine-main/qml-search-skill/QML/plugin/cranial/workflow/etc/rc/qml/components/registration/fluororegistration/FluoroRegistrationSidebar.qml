import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import FluoroCtRegistrationPageState 1.0
import GmQml 1.0


import ".."
import "../.."

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    FluoroCtRegistrationViewModel {
        id: fluoroCtRegistrationViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: Theme.marginSize

        SidebarHeader {
            state: "Registration Sidebar"
            title: qsTr("Merge")
            pageNumber: 3
            maxPageNumber: 4
            description: qsTr("Merge images and confirm merge quality.")
        }

        RowLayout {
            id: detectRow
            Layout.preferredHeight: Theme.marginSize * 3
            Layout.fillWidth: true
            Layout.topMargin: Theme.marginSize
            spacing: Theme.marginSize

            Button {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.marginSize
                state: "active"
                enabled: !fluoroCtRegistrationViewModel.isRunningTask
                text: "Auto-Merge"
                font.letterSpacing: 0.5

                onClicked: fluoroCtRegistrationViewModel.runFluroCtMerge()
            }

            Button {
                Layout.fillWidth: true
                Layout.rightMargin: Theme.marginSize
                state: "active"
                enabled: !fluoroCtRegistrationViewModel.isRunningTask
                text: "Deep Search"
                font.letterSpacing: 0.5
                onClicked: fluoroCtRegistrationViewModel.runFluroCtExtendedMerge()
            }
        }

        Rectangle {
            Layout.preferredWidth: 328
            Layout.preferredHeight: 64
            border { width: 1; color: Theme.navyLight }
            Layout.leftMargin: Theme.marginSize
            Layout.topMargin: Theme.marginSize

            color: Theme.transparent
            radius: 4

            RowLayout {
                id: mergeStatus
                Layout.fillWidth: true
                Layout.fillHeight: true

                Label {
                    text: qsTr("Image Merge")
                    font.pixelSize: 21
                    Layout.margins: Theme.marginSize
                    font.bold: true
                }

                Button {
                    state: "icon"
                    icon.source: "qrc:/icons/reset.svg"
                    Layout.leftMargin: Theme.marginSize*4
                    Layout.topMargin: 8
                    enabled: fluoroCtRegistrationViewModel.isResetButtonVisible && !fluoroCtRegistrationViewModel.isRunningTask

                    onClicked: fluoroCtRegistrationViewModel.onResetRegistrationClicked()
                }

                PreopConfidence {
                    visible: true
                    height: Theme.margin(5)
                    Layout.topMargin: 9
                    width: height
                    confidence: fluoroCtRegistrationViewModel.normalizedScore
                    text.color: Theme.white
                    text.font.pixelSize: 21
                    text.font.bold: true

                }
            }
        }

        DividerLine { }

        FluoroCentroid {
            Layout.fillHeight: false
            meterVisible: false
            isEnable: fluoroCtRegistrationViewModel.pageState == FluoroCtRegistrationPageState.Registered
        }

        LayoutSpacer { }

        PageControls {
            Layout.fillHeight: false
            forwardEnabled: fluoroCtRegistrationViewModel.pageState == FluoroCtRegistrationPageState.Registered

            onBackClicked: applicationViewModel.switchToPage(AppPage.FluoroCapture)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.FluoroLandmarks)
        }
    }

    DividerLine { }
}
