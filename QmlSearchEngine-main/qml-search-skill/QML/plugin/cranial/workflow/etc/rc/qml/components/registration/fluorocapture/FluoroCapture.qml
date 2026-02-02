import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0
import "../../viewports"

Item {
    Layout.fillWidth: true
    Layout.fillHeight: true

    RowLayout {
        anchors { fill: parent }
        spacing: 0
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ViewportLayout {
                    anchors { fill: parent }
                    viewportToolsVisible: false
                }

                FluoroSelectedImagePopup {
                    anchors { centerIn: parent }
                }
            }

            FluoroCaptureList {}
        }

        DividerLine{}

        ViewportTools {
            Layout.fillWidth: false
            Layout.margins: Theme.marginSize / 2
        }
    }
}
