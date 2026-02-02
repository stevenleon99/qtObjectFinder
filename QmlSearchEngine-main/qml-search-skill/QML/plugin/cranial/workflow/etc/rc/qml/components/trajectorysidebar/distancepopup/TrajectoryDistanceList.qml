import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

Item {
    Layout.preferredWidth: 460
    Layout.fillHeight: true

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        RowLayout {
            spacing: 0
            Layout.fillHeight: false
            Layout.leftMargin: Theme.margin(3)
            Layout.topMargin: Theme.margin(3)
            Layout.bottomMargin: Theme.margin(3)

            Label {
                state: "body2"
                color: Theme.headerTextColor
                font.bold: true
                text: qsTr("TRAJECTORIES")
            }

            LayoutSpacer { }
        }

        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin: Theme.margin(3)
            Layout.bottomMargin: Theme.margin(3)
            spacing: Theme.marginSize
            clip: true
            model: TrajectoryDistanceListViewModel {}

            ScrollBar.vertical: ScrollBar {
                id: scrollBar
            }

            delegate: TrajectoryDistanceListElement {
                width: listView.width - scrollBar.width
            }
        }
    }
}
