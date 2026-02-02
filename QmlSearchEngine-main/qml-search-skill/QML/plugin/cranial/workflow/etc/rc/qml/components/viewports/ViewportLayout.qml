import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
//import DataModel 1.0
import ViewModels 1.0

Item {
    Layout.fillWidth: true
    Layout.fillHeight: true

    property alias viewportToolsVisible: viewportTools.visible

    ViewportListViewModel {
        id: viewportListViewModel
    }

    RowLayout {
        anchors { fill: parent }
        spacing: 0

        GridLayout {
            Layout.margins: Theme.marginSize / 2
            columnSpacing: Theme.marginSize / 2
            rowSpacing: Theme.marginSize / 2
            columns: 2

            Repeater {
                model: viewportListViewModel.viewportListPS

                Viewport {
                    visible: role_fillHeight && role_fillWidth
                    Layout.column: role_column
                    Layout.row: role_row
                    Layout.fillWidth: role_fillWidth
                    Layout.fillHeight: role_fillHeight
                    viewportUid: role_uid
                    //mergeType: viewportsViewModel.viewMergeType
                    //viewPortIndex: index

                    //onMergeTypeChanged: update()

                    //onExpandClicked: viewLayoutViewModel.changeLayout(viewPortUuid)
                }
            }
        }

        ViewportTools {
            id: viewportTools
            Layout.fillWidth: false
            Layout.margins: Theme.marginSize / 2
        }
    }
}
