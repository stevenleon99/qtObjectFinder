import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

Popup {
    id: progressBarDialog
    closePolicy: Popup.NoAutoClose

    property string header: ""
    property alias progressBar: progressBar

    Rectangle {
        id: container
        width: 664
        height: contentColumn.height + (Theme.marginSize * 4)
        anchors { centerIn: parent }
        radius: 8
        color: Theme.foregroundColor

        ColumnLayout {
            id: contentColumn
            width: container.width - Theme.margin(8)
            anchors { centerIn: parent }
            spacing: Theme.margin(4)

            Label {
                Layout.fillWidth: true
                elide: Text.ElideRight
                enabled: progressBarDialog.header
                state: "h4"
                text: progressBarDialog.header
            }

            ProgressBar {
                id: progressBar
                padding: Theme.margin(1)
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(3)
            }
        }
    }
}
