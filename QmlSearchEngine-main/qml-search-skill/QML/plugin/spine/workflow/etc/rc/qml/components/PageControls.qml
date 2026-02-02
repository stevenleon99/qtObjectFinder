import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import ViewModels 1.0
import Theme 1.0
import GmQml 1.0

ColumnLayout {
    id: pageControls
    spacing: 0

    PageStateViewModel {
        id: pageStateViewModel
    }

    readonly property bool forwardEnabled: pageStateViewModel.nextPageEnabled
    readonly property bool backEnabled: pageStateViewModel.prevPageEnabled

    RowLayout {
        Layout.margins: Theme.marginSize
        Layout.leftMargin: Theme.marginSize
        spacing: Theme.marginSize / 2

        Button {
            visible: backEnabled
            state: "icon"
            icon.source: "qrc:/icons/arrow.svg"

            onClicked: pageStateViewModel.selectPrevPage()
        }

        Button {
            objectName: "nextBtn"
            enabled: forwardEnabled
            Layout.fillWidth: true
            state: "hinted"
            text: qsTr("Next")

            onClicked: pageStateViewModel.selectNextPage()

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
