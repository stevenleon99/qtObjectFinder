import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0


import ViewModels 1.0

import "../../components"

Item {
    id: item
    visible: filterRepeater.count > 0
    Layout.fillWidth: true
    Layout.preferredHeight: container.height

    ToolFilterViewModel {
        id: viewmodel   
    }
    
    ColumnLayout {
        id: container
        anchors {
            left: parent.left
            right: parent.right
        }
        spacing: 0

        RowLayout {
            Layout.topMargin: Theme.margin(1)
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)
            spacing: Theme.margin(1)

            IconImage {
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: Theme.margin(2)
                Layout.leftMargin: Theme.margin(2)
                sourceSize: Theme.iconSize
                source: "qrc:/icons/filter.svg"
                color: Theme.disabledColor
            }

            Label {
                Layout.fillWidth: true
                state: "subtitle2"
                font { bold: true; letterSpacing: 1; capitalization: Font.AllUppercase }
                color: Theme.headerTextColor
                text: qsTr("Filters")
            }

            Button {
                Layout.rightMargin: Theme.margin(2)
                spacing: Theme.margin(1)
                state: "active"
                text: qsTr("Clear All")
                font { pixelSize: 18; bold: false }

                enabled: !viewmodel.filterListClear

                onPressed: 
                {
                    viewmodel.clearFilterList()
                }
            }
       }

        Flickable {
            Layout.fillWidth: true
            Layout.preferredHeight: gridLayout.height
            Layout.maximumHeight: Theme.margin(40)
            Layout.topMargin: Theme.margin(2)
            Layout.bottomMargin: Theme.margin(2)
            Layout.leftMargin: Theme.margin(2)
            contentWidth: width
            contentHeight: gridLayout.height
            clip: true

            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                anchors { right: parent.right; rightMargin: -Theme.margin(.5) }
                visible: parent.contentHeight > parent.height
                padding: Theme.margin(1)
            }

            GridLayout {
                id: gridLayout
                width: parent.width
                rowSpacing: Theme.marginSize
                columnSpacing: Theme.marginSize
                columns: 2

                Repeater {
                    id: filterRepeater
                    model: viewmodel.toolFilterList

                    CheckBox {
                        id: cb
                        Layout.preferredWidth: gridLayout.width / 2 - Theme.margin(2.5)
                        spacing: Theme.margin(1)
                        checkable: true
                        checked: role_selected
                        text: role_name
                        font { pixelSize: 18; bold: false }

                        onToggled: {
                            viewmodel.toggleFilterSelected(role_filterType)
                        }
                    }
                }
            }
        }
        DividerLine{}
    }
}
