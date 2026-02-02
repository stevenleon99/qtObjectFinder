import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import FluoroCtShotsPageState 1.0
import GmQml 1.0

import ".."
import "../.."

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    FluoroCtShotsViewModel {
        id: fluoroCtShotsVM
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            state: "Registration Sidebar"
            title: qsTr("Fluoro")
            pageNumber: 2
            maxPageNumber: 4
            description: qsTr("Select Fluoro images for registration.")
        }

        RowLayout {
            Layout.preferredHeight: Theme.margin(3)
            Layout.preferredWidth: Theme.margin(30)
            Layout.margins: Theme.marginSize
            spacing: Theme.marginSize

            IconImage {
                source: fluoroCtShotsVM.numShotsSelected == 2 ? "qrc:/icons/check.svg" : "qrc:/images/bullet.svg"
                sourceSize: Theme.iconSize
                color: fluoroCtShotsVM.numShotsSelected == 2 ? Theme.green : Theme.blue
            }

            Label {
                Layout.fillWidth: true
                state: "subtitle1"
                text: qsTr(fluoroCtShotsVM.numShotsSelected + "/2 images Selected")
            }

        }

        LayoutSpacer { }

        PageControls {
            Layout.fillHeight: false
            forwardEnabled: FluoroCtShotsPageState.ApLatSelected == fluoroCtShotsVM.pageState

            onBackClicked: applicationViewModel.switchToPage(AppPage.FluoroSetup)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.FluoroRegistration)
        }
    }

    DividerLine { }
}
