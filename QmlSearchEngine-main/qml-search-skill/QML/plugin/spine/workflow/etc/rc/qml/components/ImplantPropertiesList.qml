import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

import "../plansidebar"

Flickable {
    anchors.fill: parent
    bottomMargin: Theme.margin(2)
    boundsBehavior: Flickable.DragOverBounds
    flickableDirection: Flickable.VerticalFlick
    contentHeight: gridLayout.height
    interactive: contentHeight > height
    clip: true

    property alias model: repeater.model

    signal propertySelected(int keyVal, int index)

    ScrollBar.vertical: ScrollBar {
        anchors { right: parent.right }
        visible: parent.contentHeight > parent.height
        padding: 4
    }

    GridLayout {
        id: gridLayout
        anchors{ left: parent.left; leftMargin: Theme.margin(2); right: parent.right; rightMargin: Theme.margin(2) }
        rowSpacing: Theme.margin(1)
        columnSpacing: Theme.margin(2)
        columns: 2

        Repeater {
            id: repeater

            delegate: Item {
                Layout.fillWidth: true
                Layout.preferredHeight: comboBox.height
                Layout.columnSpan: role_wideSpan ? gridLayout.columns : 1

                ImplantPropertySelector {
                    id: comboBox
                    width: parent.width
                    title: role_propertyName
                    stepperEnabled: role_stepperEnabled
                    model: role_values
                    currentIndex: role_selectedIdx

                    onValueSelected: {
                        propertySelected(role_key, selectedIndex)

                        currentIndex = Qt.binding(function() { return role_selectedIdx })
                    }

                    onModelChanged: {
                        currentIndex = Qt.binding(function() { return role_selectedIdx })
                    }
                }
            }
        }
    }
}
