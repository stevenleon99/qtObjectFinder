import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import Enums 1.0

Rectangle {
    visible: instrumentVerificationViewModel.verifyingTool
    width: Theme.margin(32)
    height: layout.height
    radius: Theme.margin(1)
    color: Theme.slate900

    states: [
        State {
            when: instrumentVerificationViewModel.verifyingStatus == ToolVerifyingStatus.Verifying
            PropertyChanges { target: text; text: qsTr("Verifying...") }
            PropertyChanges { target: name; visible: true; color: Theme.navyLight; text: instrumentVerificationViewModel.instrumentName }
            PropertyChanges { target: busyIndicator; visible: true }
        },
        State {
            when: instrumentVerificationViewModel.verifyingStatus == ToolVerifyingStatus.Passed
            PropertyChanges { target: text; text: qsTr("Verified") }
            PropertyChanges { target: image; visible: true; color: Theme.green }
        },
        State {
            when: instrumentVerificationViewModel.verifyingStatus == ToolVerifyingStatus.Failed
            PropertyChanges { target: text; text: qsTr("Failed") }
            PropertyChanges { target: subtext; color: Theme.red; text: instrumentVerificationViewModel.verifyingToolErrorLabel}
            PropertyChanges { target: image; visible: true; color: Theme.red }
        },
        State {
            name: "cancelled"
            PropertyChanges { target: text; text: qsTr("Cancelled") }
            PropertyChanges { target: image; visible: true; color: Theme.red }
        },
        State {
            when: instrumentVerificationViewModel.verifyingStatus == ToolVerifyingStatus.ToolBlocked
            extend: "cancelled"
            PropertyChanges { target: subtext; text: qsTr("Tool Blocked") }
        },
        State {
            when: instrumentVerificationViewModel.verifyingStatus == ToolVerifyingStatus.HighMotion
            extend: "cancelled"
            PropertyChanges { target: subtext; text: qsTr("Motion Too High") }
        },
        State {
            when: instrumentVerificationViewModel.verifyingStatus == ToolVerifyingStatus.WrongDivot
            extend: "cancelled"
            PropertyChanges { target: subtext; text: qsTr("Wrong Divot") }
        }
    ]

    ColumnLayout {
        id: layout
        width: parent.width
        spacing: 0

        ColumnLayout {
            Layout.topMargin: Theme.margin(3)
            spacing: 0

            Label {
                id: name
                visible: false
                Layout.fillWidth: true
                state: "h6"
                font.styleName: Theme.mediumFont.styleName
                horizontalAlignment: Label.AlignHCenter
            }

            Label {
                id: text
                Layout.fillWidth: true
                state: "h4"
                font.styleName: Theme.mediumFont.styleName
                horizontalAlignment: Label.AlignHCenter
            }

            Label {
                id: subtext
                Layout.fillWidth: true
                state: "h6"
                font.styleName: Theme.mediumFont.styleName
                horizontalAlignment: Label.AlignHCenter
                color: Theme.red
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(17)
            Layout.bottomMargin: Theme.margin(3)

            BusyIndicator {
                id: busyIndicator
                visible: false
                width: parent.height
                height: width
                anchors { centerIn: parent }
            }

            IconImage {
                id: image
                visible: false
                anchors { centerIn: parent }
                source: "qrc:/icons/register.svg"
                sourceSize: Qt.size(Theme.margin(14), Theme.margin(14))
            }
        }
    }
}
