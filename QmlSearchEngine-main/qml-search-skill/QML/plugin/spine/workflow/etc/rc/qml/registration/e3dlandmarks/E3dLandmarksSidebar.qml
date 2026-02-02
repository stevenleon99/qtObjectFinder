import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import PageEnum 1.0
import IctLandmarksStatesPage 1.0
import GmQml 1.0

import "../../components"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    E3dLandmarksViewModel {
        id: e3dLandmarksViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            title: qsTr("Verify")
            pageNumber: 4
            maxPageNumber: 4
            description: qsTr("Verify the image merge.")

            Label {
                Layout.preferredHeight: 64
                state: "body1"
                verticalAlignment: Label.AlignVCenter
                text: qsTr("CHECKS")
                color: Theme.navyLight
            }


            CheckDelegate {
                objectName: "e3dCheckLandmarksCheckbox"
                enabled: e3dLandmarksViewModel.isTransferred && !e3dLandmarksViewModel.areLandmarksChecked
                Layout.fillWidth: true
                text: qsTr("Check anatomical landmarks")
                checked: e3dLandmarksViewModel.isTransferred && e3dLandmarksViewModel.areLandmarksChecked

                onClicked: e3dLandmarksViewModel.checkLandmarks()
            }
        }

        LayoutSpacer { }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            PageControls {
                anchors { verticalCenter: parent.verticalCenter }
                width: parent.width
            }

            DividerLine {
                orientation: Qt.Horizontal
                anchors { top: parent.top }
            }
        }
    }

    DividerLine { }
}
