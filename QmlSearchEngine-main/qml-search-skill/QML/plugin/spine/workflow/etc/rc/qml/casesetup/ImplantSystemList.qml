import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0
import GmQml 1.0

import "../components"

Item {
    id: implantSystemList
    Layout.fillWidth: true
    Layout.preferredHeight: layout.height
    Layout.leftMargin: Theme.marginSize
    Layout.rightMargin: Theme.marginSize

    property bool expanded: false
    property int selectedCount: 0

    property alias title: label.text
    property alias systemList: systemList
    property alias model: systemList.model

    signal listExpaned()
    signal addSystem(string id)
    signal removeSystem(string id)

    ColumnLayout {
        id: layout
        width: parent.width
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            RowLayout {
                anchors { fill: parent }
                spacing: Theme.marginSize

                IconImage {
                    source: "qrc:/icons/carrot"
                    sourceSize: Theme.iconSize
                    rotation: expanded ? 0 : -90
                }

                Label {
                    id: label
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    state: "subtitle2"
                    verticalAlignment: Label.AlignVCenter
                }

                Item {
                    visible: selectedCount
                    Layout.preferredWidth: Theme.margin(4)
                    Layout.preferredHeight: Theme.margin(4)

                    Rectangle { anchors.fill: parent; color: Theme.blue; opacity: .32; radius: 4 }

                    Label {
                        objectName: "selectedCountLabel"
                        anchors { centerIn: parent }
                        state: "subtitle1"
                        color: Theme.blue
                        text: selectedCount
                    }
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    if (implantSystemList.expanded)
                        implantSystemList.expanded = false
                    else {

                        implantSystemList.expanded = true
                        listExpaned()
                    }
                }
            }
        }

        ListView {
            id: systemList   

            Layout.fillWidth: true
            Layout.preferredHeight: expanded ? Theme.margin(38) : 0
            clip: true

            model: caseSetupImplantSystemsViewModel.addedSystemsList

            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                objectName: "scrollBar"
                anchors { right: parent.right; rightMargin: -Theme.marginSize }
                visible: systemList.contentHeight > systemList.height
            }
            
            delegate: ImplantSystem {
                objectName: "implantSystem_"+index
                onClicked : {
                    if (!role_systemAdded)
                        addSystem(role_key)
                    else
                        removeSystem(role_key)
                }
            }
        }
    }
}
