import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0
import Enums 1.0

import "../components/toolspanel"

Item {
    id: verificationdelegate
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.margin(6)

    property color color
    property string iconSource
    property int verificationStatus
    property bool instrumentVisible: false
    property bool mleeVerifyVisible: false
    property bool mleeVerifyEnabled: false
    property bool ee15Vs17Visible: false
    property bool eeIs15: true
    property bool tapSwitchVisible: false
    property bool tapSwitchChecked: false
    property string arrayIndexStr
    property bool displayArrayIndex: false
    property var calibratedStatus
    property var serialNumbers
    property string selectedSerialNumber: ""
    property bool isPowerTool: false

    property alias name: label.text
    property alias subName: subtext.text

    signal verifyClicked()
    signal toggleEe15vs17Clicked()
    signal serialNumbersClicked(serialNumber: string)
    signal toggleTapSwitchClicked()
    signal iconClicked()
    
    Rectangle {
        opacity: 0.16
        radius: 4
        anchors { fill: parent }
        color: instrumentVisible ? verificationdelegate.color : Theme.transparent
    }

    RowLayout {
        width: parent.width
        anchors { verticalCenter: parent.verticalCenter }
        spacing: Theme.margin(2)

        Rectangle {
            visible: !icon.visible
            Layout.leftMargin: Theme.margin(1)
            Layout.preferredWidth: Theme.margin(4)
            Layout.preferredHeight: Layout.preferredWidth
            radius: width / 2
            border { width: 3; color: verificationdelegate.color }
            color: instrumentVisible ? verificationdelegate.color : Theme.transparent

            Label {
                visible: displayArrayIndex
                anchors.centerIn: parent
                state: "subtitle1"
                text: arrayIndexStr
            }
        }

        IconImage {
            id: icon
            visible: iconSource
            Layout.leftMargin: Theme.margin(1)
            sourceSize: Theme.iconSize
            source: iconSource
            color: verificationdelegate.color

            Label {
                visible: displayArrayIndex
                anchors.centerIn: parent
                state: "subtitle1"
                text: arrayIndexStr
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: iconClicked()
            }
        }

        ColumnLayout {
            visible: !isPowerTool
            spacing: 0

            Label {
                id: label
                Layout.fillWidth: true
                state: "body1"
                font.bold: true
            }

            Label {
                id: subtext
                visible: text
                Layout.fillWidth: true
                state: "body1"
                color: Theme.navyLight
            }
        }

        Loader {
            Layout.fillWidth: true
            Layout.fillHeight: true
            active: isPowerTool
            sourceComponent: ColumnLayout {
                anchors {fill: parent}
                PowerToolDetails {
                    visible: isPowerTool
                    state: "toolVerification"
                }
            }
        }

        Loader {
            visible: calibratedStatus != ToolCalibratedStatus.NotRequired
            Layout.preferredWidth: Theme.margin(21)
            Layout.fillWidth: false
            Layout.fillHeight: false
            Layout.preferredHeight: Theme.margin(5)
            active: visible
            sourceComponent: InstrumentCalibrationDropdown {
                calibratedStatus: verificationdelegate.calibratedStatus
                selectedSerialNumber: verificationdelegate.selectedSerialNumber
                model: serialNumbers
            }
        }

        RowLayout {
            visible: tapSwitchVisible
            spacing: 0

            Label {
                state: "body1"
                text: qsTr("Regular")
                color: tapSwitch.checked ? Theme.navyLight : Theme.blue
            }

            Switch {
                id: tapSwitch
                checked: tapSwitchChecked
                scale: .5

                onClicked: toggleTapSwitchClicked();
            }

            Label {
                state: "body1"
                text: qsTr("Awl Tip")
                color: tapSwitch.checked ? Theme.blue : Theme.navyLight
            }
        }

        Button {
            visible: mleeVerifyVisible
            enabled: mleeVerifyEnabled
            Layout.preferredWidth: Theme.margin(13)
            Layout.preferredHeight: Theme.margin(5)
            state: "active"
            text: qsTr("Verify")

            onClicked: verifyClicked()
        }

        RowLayout {
            visible: ee15Vs17Visible
            spacing: 0

            Label {
                state: "body1"
                text: qsTr("15mm")
                color: ee15vs17Switch.checked ? Theme.navyLight : Theme.blue
            }

            Switch {
                id: ee15vs17Switch
                checked: !eeIs15
                scale: .5

                onClicked: toggleEe15vs17Clicked()
            }

            Label {
                state: "body1"
                text: qsTr("17mm")
                color: ee15vs17Switch.checked ? Theme.blue : Theme.navyLight
            }
        }

        Item {
            Layout.rightMargin: Theme.margin(1)
            Layout.preferredWidth: Theme.margin(4)
            Layout.preferredHeight: Theme.margin(4)

            IconImage {
                visible: verificationStatus != ToolVerifiedStatus.NotRequired

                source: "qrc:/icons/register.svg"
                sourceSize: Theme.iconSize
                color: {
                    if (verificationStatus == ToolVerifiedStatus.Passed) { return Theme.green }
                    else if (verificationStatus == ToolVerifiedStatus.Failed) { return Theme.red }
                    else if (verificationStatus == ToolVerifiedStatus.ToolLengthUnverified) {return Theme.yellow}
                    else { return Theme.disabledColor }
                }
            }
        }
    }
}
