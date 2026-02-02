import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0

Item {
    id: item
    Layout.preferredWidth: Theme.margin(90)
    Layout.fillHeight: true

    property int sortedOrder: Qt.AscendingOrder
    property bool disableAllowed: false

    property alias title: label.text
    property alias model: listview.model
    property alias emptyListText: descriptiveBackground.text

    signal sortClicked()
    signal selectItem(string id)

    DescriptiveBackground {
        id: descriptiveBackground
        visible: listview.count === 0
        anchors { centerIn: parent }
        source: "qrc:/icons/info-circle-outline.svg"
    }

    ColumnLayout {
        anchors { fill: parent; leftMargin: Theme.marginSize; rightMargin: Theme.marginSize; bottomMargin: Theme.margin(1) }
        spacing: 0

        Label {
            id: label
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)
            state: "h6"
            font.bold: true
            verticalAlignment : Text.AlignVCenter
        }

        ListView {
            id: listview
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            headerPositioning: ListView.OverlayHeader
            currentIndex: -1
            interactive: contentHeight > height

            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                visible: listview.contentHeight > listview.height
                anchors { right: parent.right; rightMargin: -Theme.margin(2) }
            }

            header: Rectangle {
                visible: listview.count
                z: 100
                width: {
                    if (scrollBar.visible)
                        return listview.width - Theme.margin(2)

                    return listview.width
                }
                height: Theme.margin(8)
                color: Theme.backgroundColor

                SortHeader {
                    anchors { fill: parent; leftMargin: Theme.margin(2); rightMargin: Theme.margin(2) }
                    sortText: qsTr("Name")
                    sortRole: "role_displayName"
                    sortedRole: sortRole
                    sortedOrder: item.sortedOrder

                    onSort: sortClicked()
                }

                DividerLine { anchors.bottom: parent.bottom; orientation: Qt.Horizontal }
            }

            delegate: Item {
                width: {
                    if (scrollBar.visible)
                        return listview.width - Theme.margin(2)

                    return listview.width
                }
                height: Theme.margin(8)

                Rectangle {
                    visible: role_selected
                    anchors { fill: parent }
                    opacity: 0.16
                    color: Theme.blue
                }

                RowLayout {
                    anchors { fill: parent; margins: Theme.margin(2) }
                    spacing: Theme.margin(2)

                    Item {
                        Layout.preferredWidth: height
                        Layout.fillHeight: true

                        IconImage {
                            visible: role_selected
                            anchors { centerIn: parent }
                            sourceSize: Theme.iconSize
                            color: Theme.blue
                            source: "qrc:/icons/check.svg"
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        opacity: {
                            if (!disableAllowed)
                                return 1.0

                            if(role_enabled)
                                return 1.0

                            return 0.32
                        }
                        state: "button1"
                        elide: Label.ElideRight
                        horizontalAlignment: Text.AlignLeft
                        verticalAlignment: Text.AlignVCenter
                        text: role_displayName
                    }
                }

                DividerLine { anchors.bottom: parent.bottom; orientation: Qt.Horizontal }

                MouseArea {
                    enabled: {
                        if (!disableAllowed)
                            return true

                        return role_enabled
                    }
                    anchors { fill: parent }
                    onClicked: selectItem(role_key)
                }
            }
        }
    }
}
