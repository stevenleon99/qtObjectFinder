import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import DriveEnums 1.0

Popup {
    id: popup
    visible: false
    width: Theme.margin(30)
    height: layout.height
    modal: false
    dim: false

    background: Rectangle { radius: 4; color: Theme.slate900 }

    signal selected(string pluginName)

    function setup(positionItem)
    {
        var position = positionItem.mapToItem(null, 0, 0)
        x = position.x - (width - positionItem.width)
        y = position.y + positionItem.height

        visible = true;
    }

    ColumnLayout {
        id: layout
        width: parent.width
        spacing: 0

        Repeater {
            id: repeater

            model: SortFilterProxyModel {
                sourceModel: pluginInfoListModel
                Component.onCompleted: {
                    filterRoleName = "role_type"
                    filterRegExp = /^PluginType::Workflow$/
                    sortRoleName = "role_name"
                }
            }

            Item {
                objectName: "plugin_" + role_display_name
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(8)

                RowLayout {
                    anchors { fill: parent }
                    spacing: 0

                    Item {
                        Layout.preferredWidth: height
                        Layout.fillHeight: true

                        IconImage {
                            anchors { centerIn: parent }
                            sourceSize: Theme.iconSize
                            color: Theme.blue
                            source: role_icon
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        state: "body1"
                        text: qsTr("New ") + role_display_name + qsTr(" Case")
                        color: mouseArea.pressed ? Theme.blue : Theme.white
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors { fill: parent }

                    onClicked: {
                        if(role_licensed) {
                            repeater.selectedPlugin = role_name
                        }
                        else {
                            licenseManagerViewModel.alertInvalidLicense()
                        }
                        popup.close()
                    }


                }
            }

            property string selectedPlugin
        }
    }

    onClosed: {
        if(repeater.selectedPlugin) {
            popup.selected(repeater.selectedPlugin)
            repeater.selectedPlugin = ""
        }
    }
}

