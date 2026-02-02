import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0
import PageEnum 1.0
import PatientRegistrationCategory 1.0

import "../../components"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            title: qsTr("Capture")
            pageNumber: 1
            maxPageNumber: 2
            description: qsTr("Capture and assign Fluoro images for registration. Adjust centroids for proper registration.")
        }

        Item {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize
            Layout.preferredHeight: Theme.margin(8)

            Label {
                anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                state: "body1"
                text: qsTr("Levels")
                color: Theme.navyLight
                font { bold: true; capitalization: Font.AllUppercase }
            }
        }

        CaptureAnatomyList {
            id: captureAnatomyList
            Layout.fillWidth: true
            Layout.fillHeight: true
            leftMargin: Theme.margin(2)
            Layout.bottomMargin: Theme.margin(1)
        }

        ImageTools {}

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
