import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

ColumnLayout {
    id: pageControls
    spacing: 0
    Layout.preferredHeight: 64

    property bool forwardEnabled: true
    property bool backEnabled: true
    property bool backVisible: true

    signal backClicked()
    signal forwardClicked()

    DividerLine { }

    RowLayout {
        Layout.preferredHeight: 64
        Layout.leftMargin: Theme.marginSize
        Layout.rightMargin: Theme.marginSize
        spacing: Theme.marginSize / 2

        Button {
            visible: backVisible
            enabled: backEnabled
            state: "icon"
            icon.source: "qrc:/icons/arrow.svg"

            onClicked: backClicked()
        }

        Button {
            enabled: forwardEnabled
            Layout.fillWidth: true
            state: "hinted"
            text: qsTr("Next")

            onClicked: forwardClicked()

            IconImage {
                anchors { right: parent.right; rightMargin: Theme.margin(1); verticalCenter: parent.verticalCenter; }
                source: "qrc:/icons/arrow.svg"
                sourceSize: Theme.iconSize
                color: forwardEnabled ? Theme.black : Theme.disabledColor
                rotation: 180
            }

        }
    }
}
