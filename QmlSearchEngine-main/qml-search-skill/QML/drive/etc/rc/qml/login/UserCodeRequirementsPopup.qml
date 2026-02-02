import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import "../components"

Rectangle {
    id: userCodeRequirementsPopup
    width: 320
    height: layout.height
    radius: 8
    color: "#0E161B"

    property bool valid: false
    readonly property bool codesMatch: code && (code === confirmCode)

    property string code
    property string confirmCode

    property bool pinMode: false

    function position(positionItem) {
        var position = positionItem.mapToItem(parent, 0, 0)
        y = Qt.binding(function() { return position.y + (positionItem.height / 2) - (height / 2) })

        if (position.x > parent.width / 2) {
            indicator.x = -indicator.width / 2
            x = position.x + positionItem.width + Theme.margin(2)
        }
        else {
            indicator.x = width - indicator.width / 2
            x = position.x - width - Theme.margin(2)
        }
    }

    Rectangle {
        id: indicator
        width: Theme.margin(4) / Math.sqrt(2)
        height: width
        rotation: 45
        anchors { verticalCenter: parent.verticalCenter }
        color: parent.color
    }

    ColumnLayout {
        id: layout
        width: parent.width
        spacing: Theme.margin(0)

        states: [
            State {
                when: pinMode
                PropertyChanges { target: requirements; text: qsTr("PIN Requirements:") }
                PropertyChanges { target: fourNumberPolicy; visible: true }
                PropertyChanges { target: pinMatchPolicy; visible: true }
                PropertyChanges { target: userCodeRequirementsPopup; valid: fourNumberPolicy.active && pinMatchPolicy.active }
            },
            State {
                when: !pinMode
                PropertyChanges { target: requirements; text: qsTr("Password Requirements:") }
                PropertyChanges { target: lowerCasePolicy; visible: true }
                PropertyChanges { target: numberPolicy; visible: true }
                PropertyChanges { target: lengthPolicy; visible: true }
                PropertyChanges { target: upperCasePolicy; visible: true }
                PropertyChanges { target: spCharacterPolicy; visible: true }
                PropertyChanges { target: passwordMatchPolicy; visible: true }
                PropertyChanges {
                    target: userCodeRequirementsPopup
                    valid: lowerCasePolicy.active && upperCasePolicy.active && numberPolicy.active &&
                           spCharacterPolicy.active && lengthPolicy.active && passwordMatchPolicy.active
                }
            }
        ]

        Label {
            id: requirements
            Layout.preferredHeight: Theme.margin(8)
            Layout.leftMargin: Theme.margin(2)
            verticalAlignment: Label.AlignVCenter
            state: "h6"
        }

        DividerLine { }

        ColumnLayout {
            Layout.margins: Theme.margin(2)
            spacing: Theme.margin(1)

            PasswordPolicyItem {
                id: fourNumberPolicy
                text: qsTr("have 4 digits")
                active: code.length === 4
            }

            PasswordPolicyItem {
                id: pinMatchPolicy
                text: qsTr("PINs match")
                active: codesMatch
            }

            PasswordPolicyItem {
                id: lowerCasePolicy
                text: qsTr("use lower-case")
                active: code.match(/[a-z]/)
            }

            PasswordPolicyItem {
                id: upperCasePolicy
                text: qsTr("use upper-case")
                active: code.match(/[A-Z]/)
                state: "matches"
            }

            PasswordPolicyItem {
                id: numberPolicy
                text: qsTr("use a number")
                active: code.match(/[0-9]/)
            }

            PasswordPolicyItem {
                id: spCharacterPolicy
                text: qsTr("use a special character")
                active: code.match(/[ !@#$%^&*()_+|~=`{}[\]:";'<>?,.\\/-]/)
            }

            PasswordPolicyItem {
                id: lengthPolicy
                text: qsTr("have 8+ letters")
                active: code.length >= 8
            }

            PasswordPolicyItem {
                id: passwordMatchPolicy
                text: qsTr("passwords match")
                active: codesMatch
            }
        }
    }
}
