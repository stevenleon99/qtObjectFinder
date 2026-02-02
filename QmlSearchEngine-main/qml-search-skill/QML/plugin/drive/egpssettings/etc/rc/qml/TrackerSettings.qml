import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

ColumnLayout {
    spacing: 0
    
    Label {
        Layout.preferredHeight: Theme.margin(10)
        state: "h6"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text: qsTr("Tracking Devices")
    }
    
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: listView.contentHeight
        radius: 8
        border { width: 1; color: Theme.lineColor }
        color: Theme.transparent
        
        ListView {
            id: listView
            anchors { fill: parent }
            interactive: false
            spacing: 0
            
            model: TrackerInfoListModel { }
            
            ListModel {
                id: headerModel
                ListElement { role_role: "role_type"; role_text: "TYPE"; role_weight: 1 }
                ListElement { role_role: "role_id"; role_text: "ID"; role_weight: 2 }
                ListElement { role_role: "role_version"; role_text: "VERSION"; role_weight: 1 }
            }
            
            header: Item {
                width: listView.width
                height: Theme.margin(8)
                
                RowLayout {
                    anchors { fill: parent; leftMargin: Theme.margin(2) }
                    spacing: Theme.margin(2)
                    
                    Repeater {
                        model: headerModel
                        
                        delegate: Label {
                            Layout.preferredWidth: role_weight
                            Layout.fillWidth: true
                            state: "body1"
                            color: Theme.lineColor
                            font.bold: true
                            text: role_text
                        }
                    }
                }
                
                DividerLine {
                    anchors { bottom: parent.bottom }
                    orientation: Qt.Horizontal
                }
            }
            
            delegate: Item {
                width: listView.width
                height: Theme.margin(8)

                DividerLine {
                    anchors { top: parent.top }
                    orientation: Qt.Horizontal
                }
                
                RowLayout {
                    anchors { fill: parent; leftMargin: Theme.margin(2) }
                    spacing: Theme.margin(2)
                    
                    Repeater {
                        model: headerModel
                        
                        delegate: Label {
                            Layout.preferredWidth: role_weight
                            Layout.fillWidth: true
                            state: "body1"
                            text: switch (index) {
                                  case 0: return role_type
                                  case 1: return role_id
                                  case 2: return role_version
                                  }
                        }
                    }
                }
            }
        }
    }
}
