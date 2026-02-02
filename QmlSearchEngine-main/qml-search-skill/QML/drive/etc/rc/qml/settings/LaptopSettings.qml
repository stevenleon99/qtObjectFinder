import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

ColumnLayout {
    x: Theme.margin(6)
    width: parent.width
    spacing: Theme.margin(4)

    SystemInfoViewModel { id: systemInfoViewModel }

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("Build Details")
    }

    ColumnLayout {
        Layout.maximumWidth: Theme.margin(58)
        spacing: Theme.margin(1)

        Label {
            Layout.fillWidth: true
            state: "h6"
            font.bold: true
            text: qsTr("Software")
        }

        Repeater {
            model: ListModel {
                ListElement { role_text: qsTr("Build");            role_type: "build_version" }
                ListElement { role_text: qsTr("Serial Number");    role_type: "serial_number" }
            }

            RowLayout {
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
                    text: value ? value : " - "

                    property var value: systemInfoViewModel.systemInfo[role_type]
                }
            }
        }
    }
}
