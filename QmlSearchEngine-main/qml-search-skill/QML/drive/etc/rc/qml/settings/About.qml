
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

ColumnLayout {
    spacing: Theme.margin(4)

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("About")
    }

    SystemInfoViewModel { id: systemInfoViewModel }

    ColumnLayout {
        Layout.maximumWidth: Theme.margin(58)
        spacing: Theme.margin(1)

        Label {
            Layout.fillWidth: true
            state: "h6"
            font.bold: true
            text: qsTr("Versions")
        }

        Repeater {
            model: systemInfoViewModel.appInfoList

            RowLayout {
                Layout.fillWidth: true

                Label {
                    Layout.fillWidth: true
                    state: "body1"
                    text: role_displayName + ":"
                    color: Theme.disabledColor
                }

                Label {
                    Layout.maximumWidth: Theme.margin(50)
                    state: "body1"
                    elide: Text.ElideRight
                    text: role_version
                }
            }
        }
    }

    RowLayout {
        spacing: Theme.margin(4)

        ColumnLayout {
            Layout.maximumWidth: Theme.margin(58)
            spacing: Theme.margin(1)

            Label {
                Layout.fillWidth: true
                state: "h6"
                font.bold: true
                text: qsTr("Plugin Versions")
            }

            Repeater {
                model: pluginInfoListModel

                RowLayout {
                    visible: role_licensed
                    Layout.fillWidth: true

                    Label {
                        Layout.fillWidth: true
                        state: "body1"
                        text: role_display_name + ":"
                        color: Theme.disabledColor
                    }

                    Label {
                        Layout.maximumWidth: Theme.margin(50)
                        state: "body1"
                        elide: Text.ElideRight
                        text: role_version
                    }
                }
            }
        }
    }

    RowLayout {
        spacing: Theme.margin(4)

        ColumnLayout {
            Layout.maximumWidth: Theme.margin(58)
            spacing: Theme.margin(1)

            Label {
                Layout.fillWidth: true
                state: "h6"
                font.bold: true
                text: qsTr("Active Features for ") + pluginModel.systemName()
            }

            Repeater {
                model: pluginModel.getAllSoftwareFeaturesList()

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        Layout.fillWidth: true
                        state: "body1"
                        text: modelData
                        color: Theme.white
                    }
                }
            }
        }
    }
}
