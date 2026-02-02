import DriveEnums 1.0
import GmQml 1.0
import NetworkSettingsViewModel 1.0
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Theme 1.0

ColumnLayout {
    property var nwTypeBtnState: "Ethernet"
    property int activeBtnIdx: nwTypeBtnState === "Ethernet" ? 0 : 1

    spacing: Theme.margin(4)

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text: qsTr("Network Configuration")
    }

    GridLayout {
        id: nwSettingsPage

        rowSpacing: Theme.margin(8)
        rows: 2
        flow: GridLayout.TopToBottom

        SettingsDescription {
            Layout.preferredHeight: Theme.margin(6)
            title: qsTr("Network")
            description: qsTr("View and change IP address for network connections.")
        }

        GridLayout {
            columnSpacing: Theme.margin(6)
            columns: 3
            flow: GridLayout.LeftToRight

            ColumnLayout {
                id: nwTypeBtns

                spacing: Theme.margin(2)
                visible: NwModel.isEhub

                Repeater {
                    id: nwTypeBtnRepeater

                    model: ["Ethernet", "Glink"]

                    NetAccessButton {
                        name: modelData
                        mouseBtn.onClicked: {
                            nwTypeBtnState = name;
                            NwModel.btnNwTypeClicked(name);
                        }
                        isActive: {
                            (activeBtnIdx !== index) ? false : true;
                        }
                    }

                }

                LayoutSpacer {
                }

            }

            ColumnLayout {
                id: nwStatusEhub

                visible: (userViewModel.platformType === PlatformType.Ehub && nwTypeBtnState === "Glink")
                spacing: Theme.margin(2)

                NetworkStatusRow {
                    id: nwStatusEhubGlink
                }

                LayoutSpacer {
                }

            }

            ColumnLayout {
                id: nwSettingsDetails

                visible: userViewModel.platformType !== PlatformType.Ehub || nwTypeBtnState !== "Glink"
                spacing: Theme.margin(2)

                NetworkStatusRow {
                    id: nwStatus
                }

                RowLayout {
                    spacing: Theme.margin(8)

                    Label {
                        id: ipAddrTypeLabel

                        state: "subtitle1"
                        text: NwModel.ipAddressType
                    }

                    Switch {
                        id: ipAddrTypeSwitch

                        enabled: true
                        width: 120
                        height: 48
                        checked: (NwModel.ipAddressType === "Dynamic Address")
                        onToggled: {
                            ipAddrTypeLabel.text = checked ? "Dynamic Address" : "Static Address";
                            NwModel.handleIPTypeSwitch(checked);
                        }
                    }

                    BusyIndicator {
                        id: busyIndicator

                        visible: NwModel.isApplyChangesPending
                        Layout.preferredWidth: Theme.iconSize.width
                        Layout.preferredHeight: Theme.iconSize.height
                    }

                }

                RowLayout {
                    spacing: Theme.margin(8)

                    ColumnLayout {
                        spacing: Theme.margin(2)

                        Label {
                            state: "subtitle1"
                            Layout.preferredHeight: Theme.margin(6)
                            verticalAlignment: "AlignVCenter"
                            text: qsTr("MAC Address:")
                        }

                        Label {
                            state: "subtitle1"
                            Layout.preferredHeight: Theme.margin(6)
                            verticalAlignment: "AlignVCenter"
                            text: qsTr("IP Address:")
                        }

                        Label {
                            state: "subtitle1"
                            Layout.preferredHeight: Theme.margin(6)
                            verticalAlignment: "AlignVCenter"
                            text: qsTr("Subnet Mask:")
                        }

                        Label {
                            state: "subtitle1"
                            Layout.preferredHeight: Theme.margin(6)
                            verticalAlignment: "AlignVCenter"
                            text: qsTr("Gateway:")
                        }

                    }

                    ColumnLayout {
                        spacing: Theme.margin(2)

                        TextField {
                            id: macAddressField

                            Layout.preferredHeight: Theme.margin(6)
                            readOnly: true
                            text: NwModel.macAddress
                        }

                        // Text fields can only be edited if editMode is true or in staticMode
                        TextField {
                            id: ipAddressField

                            readonly property bool changed: text !== NwModel.ipAddress

                            Layout.preferredHeight: Theme.margin(6)
                            readOnly: ipAddrTypeSwitch.checked
                            color: ipAddrTypeSwitch.checked ? Theme.disabledColor : Theme.white
                            validator: NwModel.validator()
                            placeholderText: "Ex. 000.000.000.000"
                            text: NwModel.ipAddress
                            onTextEdited: {
                                if (NwModel.isIPAddressExcluded(text)) {
                                    excludedIPLbl.visible = true;
                                    text = "";
                                    NwModel.isApplyButtonActivated = false;
                                } else {
                                    excludedIPLbl.visible = false;
                                    NwModel.isApplyButtonActivated = true;
                                }
                            }
                        }

                        Label {
                            id: "excludedIPLbl"

                            state: overline
                            Layout.preferredHeight: Theme.margin(2)
                            verticalAlignment: "AlignVCenter"
                            visible: false
                            text: qsTr("Invalid IP Address. Please enter another")
                        }

                        TextField {
                            id: subNetField

                            readonly property bool changed: text !== NwModel.subnet

                            Layout.preferredHeight: Theme.margin(6)
                            readOnly: ipAddressField.readOnly
                            color: ipAddressField.color
                            validator: NwModel.validator()
                            placeholderText: ipAddressField.placeholderText
                            text: NwModel.subnet
                            onTextEdited: NwModel.isApplyButtonActivated = true
                        }

                        TextField {
                            id: gateWayField

                            readonly property bool changed: text !== NwModel.gateway

                            Layout.preferredHeight: Theme.margin(6)
                            readOnly: ipAddressField.readOnly
                            color: ipAddressField.color
                            validator: NwModel.validator()
                            placeholderText: ipAddressField.placeholderText
                            text: NwModel.gateway
                            onTextEdited: NwModel.isApplyButtonActivated = true
                        }

                    }

                }

                ColumnLayout {
                    spacing: Theme.margin(2)

                    RowLayout {
                        id: ehubDnsARow

                        // Hide these fields for now. There is a question why they are needed.
                        // The code was left because there may be a need in the future to make
                        // them visible when the platform is eHub. If needed, replace "false"
                        // below with "userViewModel.platformType === PlatformType.Ehub"
                        visible: false
                        spacing: Theme.margin(2)

                        Label {
                            state: "subtitle2"
                            Layout.preferredHeight: Theme.margin(6)
                            text: qsTr("Preferred DNS Server:")
                        }

                        TextField {
                            id: dnsServerAField

                            readonly property bool changed: text !== NwModel.dnsServerA

                            readOnly: ipAddressField.readOnly
                            color: ipAddressField.color
                            Layout.preferredHeight: Theme.margin(6)
                            validator: NwModel.validator()
                            text: NwModel.dnsServerA
                            onTextEdited: NwModel.isApplyButtonActivated = true
                        }

                    }

                    RowLayout {
                        id: ehubDnsBRow

                        visible: ehubDnsARow.visible
                        spacing: Theme.margin(2)

                        Label {
                            state: "subtitle2"
                            Layout.preferredHeight: Theme.margin(6)
                            text: qsTr("Alternate DNS Server:")
                        }

                        TextField {
                            id: dnsServerBField

                            readonly property bool changed: text !== NwModel.dnsServerB

                            readOnly: ipAddressField.readOnly
                            color: ipAddressField.color
                            Layout.preferredHeight: Theme.margin(6)
                            validator: NwModel.validator()
                            text: NwModel.dnsServerB
                            onTextEdited: NwModel.isApplyButtonActivated = true
                        }

                    }

                }

                RowLayout {
                    spacing: Theme.margin(2)

                    Button {
                        id: revertNWSettings

                        enabled: NwModel.isApplyButtonActivated
                        height: 48
                        width: 240
                        state: "active"
                        text: qsTr("Cancel Changes")
                        onClicked: NwModel.handleIPTypeSwitch(false)
                    }

                    Button {
                        id: applyNWSettings

                        enabled: revertNWSettings.enabled
                        height: 48
                        width: 240
                        state: "hinted"
                        text: qsTr("Apply Changes")
                        onClicked: ehubDnsARow.visible ? NwModel.applyNwSettings(ipAddrTypeSwitch.checked, ipAddressField.text, subNetField.text, gateWayField.text, dnsServerAField.text, dnsServerBField.text) : NwModel.applyNwSettings(ipAddrTypeSwitch.checked, ipAddressField.text, subNetField.text, gateWayField.text)
                    }

                }

                LayoutSpacer {
                }

            }

        }

    }

}
