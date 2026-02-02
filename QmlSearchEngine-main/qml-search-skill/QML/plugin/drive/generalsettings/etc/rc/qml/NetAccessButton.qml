import NetworkSettingsViewModel 1.0
import QtGraphicalEffects 1.0
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Layouts 1.12
import Theme 1.0

Item {
    id: control

    property alias name: control.state
    property alias mouseBtn: mouseArea
    property alias isActive: button.active

    width: Theme.margin(30)
    height: Theme.margin(8)
    states: [
        State {
            name: "Ethernet"

            PropertyChanges {
                target: titleText
                text: "Ethernet - Hospital"
            }

            PropertyChanges {
                target: networkIcon
                source: NwModel.isEthernetConnected ? "qrc:/icons/internet.svg" : "qrc:/icons/no-internet.svg"
            }

            PropertyChanges {
                target: statusInfo
                enabled: NwModel.isEthernetConnected
            }

        },
        State {
            name: "Glink"

            PropertyChanges {
                target: titleText
                text: "Ethernet - G-Link"
            }

            PropertyChanges {
                target: networkIcon
                source: NwModel.isGlinkConnected ? "qrc:/icons/network.svg" : "qrc:/icons/no-network.svg"
            }

            PropertyChanges {
                target: statusInfo
                enabled: NwModel.isGlinkConnected
            }

        }
    ]

    Rectangle {
        id: button

        property bool active: false

        radius: 4
        color: active ? "#160099FF" : Theme.transparent

        anchors {
            fill: parent
        }

        border {
            width: 1
            color: active ? Theme.blue : Theme.lineColor
        }

    }

    RowLayout {
        anchors.fill: parent
        spacing: 0

        IconImage {
            id: networkIcon

            sourceSize: Theme.iconSize
            color: Theme.blue
            Layout.preferredWidth: Theme.margin(6)
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }

        ColumnLayout {
            spacing: 0

            Label {
                id: titleText

                state: "button1"
            }

            Label {
                id: statusInfo

                state: "body1"
                text: enabled ? "Connected" : "Disconnected"
                color: enabled ? Theme.green : Theme.disabledColor
            }

        }

    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
    }

}
