import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

ColumnLayout {
    x: Theme.margin(6)
    width: parent.width
    spacing: Theme.marginSize * 2

    Repeater {
        model: ["Workflow", "Calibration", "Build", "Tracker"]

        delegate: ColumnLayout {
            spacing: Theme.margin(4)

            DividerLine {
                Layout.fillWidth: true
                visible: index
            }

            Loader {
                Layout.margins: item ? item.Layout.margins : 0
                Layout.fillHeight: item ? item.Layout.fillHeight : 0
                Layout.fillWidth: true
                Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
                active: true
                source: modelData + "Settings.qml"
            }
        }
    }
}
