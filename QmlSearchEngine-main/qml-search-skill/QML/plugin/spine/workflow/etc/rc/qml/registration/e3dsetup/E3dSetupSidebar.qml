import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

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
            maxPageNumber: 4
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
