import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

Item {
    id: arraysPanel
    Layout.preferredWidth: Theme.margin(54)
    Layout.fillHeight: true

    property SwappablePairingsViewModel swappablePairingsViewModel

    ColumnLayout {
        anchors { fill: parent; leftMargin: Theme.marginSize; rightMargin: Theme.marginSize }
        spacing: 0

        Label {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)
            state: "h6"
            font.bold: true
            verticalAlignment : Text.AlignVCenter
            text: qsTr("Arrays")
        }

        ArrayPairingList {
            swappablePairingsViewModel: arraysPanel.swappablePairingsViewModel
        }
    }

    DividerLine {
        anchors { right: parent.right }
    }
}
