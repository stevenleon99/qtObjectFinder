
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

ColumnLayout {
    spacing: Theme.margin(4)

    EgpsVersionViewModel { id: egpsVersionViewModel }

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("Build Details")
    }

    RowLayout {
        spacing: Theme.margin(4)

        ColumnLayout {
            Layout.preferredWidth: Theme.margin(58)
            spacing: Theme.margin(1)

            Label {
                Layout.fillWidth: true
                state: "h6"
                font.bold: true
                text: qsTr("GPS Software")
            }

            Repeater {
                model: ListModel {
                    ListElement { role_text: qsTr("Serial Number");    role_version: "serial_number" }
                    ListElement { role_text: qsTr("Build");            role_version: "build_version" }
                    ListElement { role_text: qsTr("Power");            role_version: "pdu_firmware" }
                    ListElement { role_text: qsTr("Platform");         role_version: "pib_firmware" }
                    ListElement { role_text: qsTr("Battery");          role_version: "battery_firmware" }
                    ListElement { role_text: qsTr("Information Ring"); role_version: "roi_firmware" }
                    ListElement { role_text: qsTr("Stabilizer 1");     role_version: "stab1_firmware" }
                    ListElement { role_text: qsTr("Stabilizer 2");     role_version: "stab2_firmware" }
                    ListElement { role_text: qsTr("Stabilizer 3");     role_version: "stab3_firmware" }
                    ListElement { role_text: qsTr("Stabilizer 4");     role_version: "stab4_firmware" }
                    ListElement { role_text: qsTr("UAIB");             role_version: "uaib_firmware" }
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

                        property var version: egpsVersionViewModel.versionInfo[role_version]
                    }
                }
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignTop
            Layout.preferredWidth: Theme.margin(58)
            spacing: Theme.margin(1)

            Label {
                Layout.fillWidth: true
                state: "h6"
                font.bold: true
                text: qsTr("Motion Software")
            }

            Repeater {
                model: ListModel {
                    ListElement { role_text: qsTr("Application"); role_version: "gmas_application" }
                    ListElement { role_text: qsTr("Firmware");    role_version: "gmas_firmware" }
                    ListElement { role_text: qsTr("Elbow");       role_version: "gmas_vertical_firmware" }
                    ListElement { role_text: qsTr("Pitch");       role_version: "gmas_shoulder_firmware" }
                    ListElement { role_text: qsTr("Roll");        role_version: "gmas_pitch_firmware" }
                    ListElement { role_text: qsTr("Shoulder");    role_version: "gmas_roll_firmware" }
                    ListElement { role_text: qsTr("Vertical");    role_version: "gmas_elbow_firmware" }
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

                        property var version: egpsVersionViewModel.versionInfo[role_version]
                    }
                }
            }
        }
    }
}
