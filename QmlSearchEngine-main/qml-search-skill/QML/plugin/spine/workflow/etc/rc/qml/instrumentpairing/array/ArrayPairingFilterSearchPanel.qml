import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0

import Enums 1.0
import ViewModels 1.0

import "../../components"

ColumnLayout{
    Layout.preferredWidth: Theme.margin(45)

    spacing: 0

    property var swappablePairingsViewModel

    ArrayPairingToolsFilter {}

    ArrayPairingToolSearch {
        onSearchTextChanged: swappablePairingsViewModel.filterToolList(text)
    }

    LayoutSpacer {}

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.margin(12)

        RowLayout {
            anchors { fill: parent; leftMargin: Theme.marginSize; rightMargin: Theme.marginSize }

            spacing: Theme.marginSize

            IconImage {
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: Theme.marginSize
                sourceSize: Theme.iconSize
                source: "qrc:/icons/alert-caution.svg"
                color: Theme.yellow
            }

            Label {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
                state: "body1"
                verticalAlignment: Text.AlignVCenter
                text: qsTr("Perform an anatomical landmark check on each new instrument or level.")
                wrapMode: Label.WordWrap
            }
        }

        DividerLine {
            anchors { top: parent.top }
            orientation: Qt.Horizontal
        }
    }
}
