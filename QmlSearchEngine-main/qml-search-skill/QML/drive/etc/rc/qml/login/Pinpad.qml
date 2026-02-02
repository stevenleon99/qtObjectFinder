import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtGraphicalEffects 1.0

import Theme 1.0
import GmQml 1.0
import DriveEnums 1.0
import ViewModels 1.0

import "../components"

ColumnLayout {
    id: pinpad
    spacing: Theme.marginSize

    property bool loginFailed: false

    readonly property bool usePassword: !userViewModel.isPinAccessAllowed

    readonly property var passcodeField: usePassword ? passwordField : pinInput

    signal numberPressed (var pin)
    signal unlockPressed
    signal clearPressed
    signal backspacePressed

    function triggerUnlock() {
        if (pinPad.unlockEnabled || unlockButton.enabled)
            unlockPressed();
    }

    onNumberPressed: pinInput.text += pin

    onClearPressed: pinInput.text = ""

    onBackspacePressed: pinInput.text = pinInput.text.substring(0, pinInput.text.length - 1)

    onUnlockPressed: {
        if (userViewModel.login(passcodeField.text)) {
            if (userViewModel.activeUser.isServiceUser) {
                serviceUserPopup.open();
            } else {
                drivePageViewModel.currentPage = DrivePage.Patients;
                if (driveMirrorViewModel.usingGPS && userViewModel.activeUser.isMirrorEnabled &&
                (connectionsViewModel.connectedPeerType !== ConnectedPeerType.E3d))
                {
                    console.log("Starting Mirror Server");
                    driveMirrorViewModel.startMirrorServer();
                }
            }
        }
        else {
            passcodeField.text = ""
            loginFailed = true
        }
    }

    Component.onCompleted: {
        if (usePassword) {
            passwordField.forceActiveFocus()
        }
    }

    Shortcut { sequence: "0"; onActivated: numberPressed(0) }
    Shortcut { sequence: "1"; onActivated: numberPressed(1) }
    Shortcut { sequence: "2"; onActivated: numberPressed(2) }
    Shortcut { sequence: "3"; onActivated: numberPressed(3) }
    Shortcut { sequence: "4"; onActivated: numberPressed(4) }
    Shortcut { sequence: "5"; onActivated: numberPressed(5) }
    Shortcut { sequence: "6"; onActivated: numberPressed(6) }
    Shortcut { sequence: "7"; onActivated: numberPressed(7) }
    Shortcut { sequence: "8"; onActivated: numberPressed(8) }
    Shortcut { sequence: "9"; onActivated: numberPressed(9) }
    Shortcut { sequences: ["Space", "Enter", "Return"]; onActivated: triggerUnlock() }
    Shortcut { sequence: "Delete"; onActivated: clearPressed() }
    Shortcut { sequence: "Backspace"; onActivated: backspacePressed() }

    LayoutSpacer { width: Theme.marginSize; height: Theme.margin(22); visible: usePassword }

    UserIcon {
        id: userIcon
        Layout.alignment: Qt.AlignHCenter
        Layout.preferredWidth: 160
        Layout.preferredHeight: 160

        iconText: userViewModel.activeUser.initials
        iconColor: userViewModel.activeUser.iconColor
        state: "login"

        Rectangle {
            id: changeUser
            width: Theme.margin(8)
            height: width
            radius: height / 2
            anchors { horizontalCenter: parent.horizontalCenter; horizontalCenterOffset: Theme.margin(9) }

            Button {
                objectName: "changeUser"
                anchors { centerIn: parent }
                state: "icon"
                icon.source: "qrc:/icons/swap-vertical-bold"
                color: Theme.blue

                onClicked: loader.state = "userSelector"
            }
        }

        DropShadow {
            anchors { fill: changeUser }
            transparentBorder: true
            horizontalOffset: 2
            verticalOffset: 4
            samples: 13
            radius: 6.0
            spread: 0.0
            source: changeUser
            cached: true
            color: "#aa000000"
        }
    }

    Label {
        objectName: "userName"
        Layout.alignment: Qt.AlignHCenter
        font { pixelSize: 48; bold: true }
        text: userViewModel.activeUser.name ? userViewModel.activeUser.name : qsTr("No User Selected")
    }

    ColumnLayout {
        visible: usePassword
        opacity: userViewModel.activeUser.name ? 1 : 0.5

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.marginSize / 2

            LayoutSpacer { width: 64; height: width }

            Rectangle {
                Layout.preferredWidth: 480
                Layout.preferredHeight: 64
                radius: Theme.marginSize * 0.5
                color: Theme.transparent
                border { width: 2; color: passwordField.activeFocus ? Theme.blue : Theme.navyLight }

                TextField {
                    id: passwordField
                    enabled: userViewModel.activeUser.name && (userViewModel.loginAttemptsRemaining > 0)
                    width: parent.width
                    height: parent.height
                    maximumLength: 18
                    padding: Theme.marginSize * 0.75
                    font { pixelSize: 27 }
                    placeholderText: qsTr("Password")
                    placeholderTextColor: Theme.navyLight
                    echoMode: TextInput.Password
                    background: Item {}
                    validator: RegExpValidator { regExp: /^[0-9a-zA-Z !@#$%^&*()_+|~=`{}[\]:";'<>?,.\\/-]+$/ }

                    Keys.onReturnPressed: unlockPressed()

                    onTextChanged: loginFailed = false

                    PasscodeAttemptsHint {
                        visible: loginFailed || (remainingAttemptCount <= 0)
                        width: parent.width
                        anchors { top: parent.bottom }
                        usePassword: pinpad.usePassword
                    }

                    Rectangle {
                        visible: loginFailed
                        radius: 4
                        anchors { fill: parent }
                        border { width: 4; color: Theme.red }
                        color: Theme.transparent
                    }
                }
            }

            Rectangle {
                id: unlockButton
                enabled: passwordField.enabled && passwordField.text
                Layout.preferredHeight: 64
                Layout.preferredWidth: 64
                radius: height / 2
                color: Theme.blue

                opacity: enabled ? 1 : 0.5

                IconImage {
                    anchors { centerIn: parent }
                    source: "qrc:/icons/arrow.svg"
                    sourceSize: Theme.iconSize
                    color: Theme.black
                    fillMode: Image.PreserveAspectFit
                    rotation: 180
                }

                MouseArea { anchors.fill: parent; onClicked: unlockPressed()  }
            }
        }

        LayoutSpacer { width: Theme.marginSize; height: Theme.margin(43) }
    }

    ColumnLayout {
        visible: !usePassword
        spacing: Theme.marginSize

        TextInput {
            id: pinInput
            Layout.leftMargin: Theme.marginSize
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredHeight: 112
            Layout.fillWidth: true
            horizontalAlignment: TextInput.AlignHCenter
            verticalAlignment: TextInput.AlignVCenter
            font { pixelSize: 110; letterSpacing: 22 }
            maximumLength: 6
            echoMode: TextInput.Password
            cursorVisible: false
            readOnly: true
            color: Theme.white

            onTextChanged: loginFailed = false

            Button {
                visible: parent.text
                anchors { left: parent.right; verticalCenter: parent.verticalCenter; verticalCenterOffset: 14 }
                icon.source: "qrc:/icons/backspace.svg"
                state: "icon"

                onClicked: backspacePressed()
            }
        }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 720
            Layout.preferredHeight: 2
            color: loginFailed ? Theme.red : Theme.white

            PasscodeAttemptsHint {
                visible: loginFailed || (remainingAttemptCount <= 0)
                width: parent.width
                anchors { top: parent.bottom }
                usePassword: pinpad.usePassword
            }
        }

        GridView {
            id: pinPad
            enabled: userViewModel.loginAttemptsRemaining > 0
            opacity: enabled ? 1.0 : 0.5
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 336
            Layout.preferredHeight: 448
            Layout.topMargin: Theme.margin(5)
            cellWidth: width / 3
            cellHeight: height / 4
            interactive: false
            model: [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "CLEAR", "0", "UNLOCK" ]

            property bool unlockEnabled: (pinInput.length >= 4)

            delegate: Item {
                objectName: "pinPadButton_" + pinText.text
                width: pinPad.cellWidth
                height: pinPad.cellHeight

                states: [
                    State {
                        when: modelData === "UNLOCK"
                        PropertyChanges { target: unlockPin; visible: true ; color: Theme.black; opacity: pinPad.unlockEnabled ? 1 : 0.5 }
                        PropertyChanges { target: pin; color: pinMA.pressed ? Theme.lighterBlue : Theme.lighterBlue; opacity: pinPad.unlockEnabled ? 1 : 0.5; border { width: 0 } }
                        PropertyChanges { target: pinText; visible: false }
                        PropertyChanges { target: pinMA; enabled: pinPad.unlockEnabled; onClicked: unlockPressed() }
                    },
                    State {
                        when: modelData === "CLEAR"
                        PropertyChanges { target: deletePin; visible: true }
                        PropertyChanges { target: pin; color: pinMA.pressed ? Theme.white : "transparent" }
                        PropertyChanges { target: pinText; visible: false }
                        PropertyChanges { target: pinMA; onClicked: clearPressed() }
                    },
                    State {
                        when: pinMA.pressed
                        PropertyChanges { target: pin; color: Theme.white }
                        PropertyChanges { target: pinText; color: Theme.black }
                    }
                ]

                Rectangle {
                    id: pin
                    width: parent.width - 30
                    height: parent.width - 30
                    radius: width / 2
                    anchors { centerIn: parent }
                    color: "transparent"
                    border { width: 1; color: Theme.white }
                }

                Label {
                    id: pinText
                    anchors { centerIn: parent }
                    font { bold: true }
                    text: modelData
                    state: "h5"
                }

                IconImage {
                    id: unlockPin
                    visible: false
                    anchors { centerIn: parent }
                    source: "qrc:/icons/arrow.svg"
                    sourceSize: Theme.iconSize
                    fillMode: Image.PreserveAspectFit
                    rotation: 180
                }

                Image {
                    id: deletePin
                    visible: false
                    anchors { centerIn: parent }
                    source: "qrc:/icons/x.svg"
                    sourceSize: Theme.iconSize
                    fillMode: Image.PreserveAspectFit
                }

                MouseArea {
                    id: pinMA
                    anchors { fill: parent }

                    onClicked: numberPressed(modelData)
                }
            }
        }
    }

    RowLayout {
        visible: userViewModel.activeUser.name
        Layout.alignment: Qt.AlignHCenter
        spacing: Theme.marginSize

        Button {            
            objectName: "autoSwitchPinPassBtnObj"
            visible: (userViewModel.platformType != PlatformType.Laptop)
                                   && userViewModel.activeUser.pinAccess
                                   && !userViewModel.activeUser.isServiceUser
            Layout.preferredWidth: Theme.margin(30)
            state: "available"
            text: userViewModel.activeUser.pinPreferred ? qsTr("Switch to Password")
                                                        : qsTr("Switch to PIN")
            onClicked: {
                userViewModel.setPinPreferred(userViewModel.activeUser.uuid,
                                               !userViewModel.activeUser.pinPreferred)
                if (!userViewModel.activeUser.pinPreferred)
                    passwordField.forceActiveFocus();
            }
        }

        Button {
            objectName: "forgotPasswordBtn"
            visible: !userViewModel.activeUser.isServiceUser
            Layout.preferredWidth: Theme.margin(30)
            state: "available"
            text: qsTr("Forgot Password?")
            onClicked: resetPasswordPopup.open()
        }

        Button {
            visible: userViewModel.activeUser.isServiceUser
            Layout.preferredWidth: Theme.margin(25)
            state: "available"
            text: qsTr("Delete Account")
            onClicked: deleteAccountPopup.open()
        }
    }

    ResetPasswordPopup { id: resetPasswordPopup }

    ServiceUserPopup { id: serviceUserPopup }

    DeleteItemPopup {
        id: deleteAccountPopup
        state: "account"
        itemName: userViewModel.activeUser.name
        onDeleteClicked: userViewModel.deactivateUser(userViewModel.activeUser.uuid)
    }
}
