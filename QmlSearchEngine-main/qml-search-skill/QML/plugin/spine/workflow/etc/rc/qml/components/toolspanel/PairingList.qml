import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

Flickable {
    id: flickable
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.margin(20)
    topMargin: Theme.margin(.5)
    bottomMargin: Theme.margin(2)
    boundsBehavior: Flickable.DragOverBounds
    flickableDirection: Flickable.VerticalFlick
    contentHeight: gridLayout.height > height ? gridLayout.height : height
    interactive: contentHeight > height
    clip: true

    property ToolsListViewModel toolsListVM

    ScrollBar.vertical: ScrollBar {
        anchors { right: parent.right }
        visible: parent.contentHeight > parent.height
        padding: 4
    }

    GridLayout {
        id: gridLayout
        anchors{ left: parent.left; leftMargin: Theme.margin(2); right: parent.right; rightMargin: Theme.margin(2) }
        rowSpacing: Theme.margin(2)
        columnSpacing: Theme.margin(2)
        columns: 2

        Repeater {
            id: repeater
            model: toolsListVM.arrayPairingList

            delegate: PairingDelegate {
                Layout.preferredWidth: gridLayout.width / 2 - Theme.margin(1)
                iconSource: role_iconPath
                iconColor: role_color
                arrayIndex: role_arrayIndex
                toolTypeDisplayName: role_toolTypeDisplayName
                displayArrayIndex: role_displayArrayIndex
                selected: toolsListVM.selectedRefElementId === role_refElementId
                loaded: role_loaded

                onClicked: toolsListVM.selectRefElement(role_refElementId)
            }
        }
    }

    DescriptiveBackground {
        visible: repeater.count === 0
        anchors { centerIn: parent }
        source: "qrc:/icons/toolbox"
        text: qsTr("Verify Tools.")
    }
}


