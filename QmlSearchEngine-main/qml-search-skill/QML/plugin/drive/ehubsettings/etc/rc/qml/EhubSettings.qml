
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

ColumnLayout {
    spacing: Theme.margin(4)

    EhubVersionViewModel { id: ehubVersionViewModel }

    RowLayout {
        spacing: Theme.margin(4)

        ColumnLayout {
            Layout.preferredWidth: Theme.margin(58)
            spacing: Theme.margin(1)

            Label {
                Layout.fillWidth: true
                state: "h6"
                font.bold: true
                text: qsTr("System Information")
            }

            Repeater {
                model: ListModel {
                    ListElement { role_text: qsTr("Serial Number");    role_version: "serial_number" }
                    ListElement { role_text: qsTr("Build");            role_version: "build_version" }
                    ListElement { role_text: qsTr("Suite");            role_version: "suite_version" }
                }

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        Layout.fillWidth: true
                        state: "body1"
                        text: role_text + ":"
                        color: Theme.disabledColor
                    }

                    Label {
                        Layout.maximumWidth: Theme.margin(36)
                        state: "body1"
                        elide: Text.ElideRight
                        text: version ? version : " - "

                        property var version: ehubVersionViewModel.versionInfo[role_version]
                    }
                }
            }
        }
        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: Theme.margin(58)
            spacing: Theme.margin(1)
        }
    }
}
