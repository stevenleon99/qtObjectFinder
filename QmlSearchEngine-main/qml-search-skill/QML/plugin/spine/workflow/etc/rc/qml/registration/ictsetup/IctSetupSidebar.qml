import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import PageEnum 1.0
import IctSnapshotStatesPage 1.0


import "../../components"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true
    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            spacing: Theme.marginSize
            title: qsTr("Setup")
            pageNumber: 2
            maxPageNumber: 5

            Label {
                visible: false
                state: "body1"
                verticalAlignment: Label.AlignVCenter
                text: qsTr("REGISTRATION FIXTURE")
                color: Theme.navyLight
            }

            RadioButton {
                visible: false
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(4)
                Layout.bottomMargin: Theme.margin(1)
                checked: true // link to backend once available SPINE-1643
                text: qsTr("ICT")

                onClicked: { /* Call backend once available SPINE-1643 */ }
            }

            RadioButton {
                visible: false
                enabled: false
                opacity: 0.5
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(4)
                Layout.bottomMargin: Theme.margin(1)
                checked: false // link to backend once available SPINE-1643
                text: qsTr("DDICT")

                onClicked: { /* Call backend once available SPINE-1643 */ }
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
