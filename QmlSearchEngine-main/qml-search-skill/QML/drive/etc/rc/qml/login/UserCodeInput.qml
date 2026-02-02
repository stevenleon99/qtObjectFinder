import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import "../components"

ColumnLayout {
    id: userCodeInput
    spacing: Theme.margin(2)

    property bool inputPin: true
    property bool inputPassword: true

    property alias pinInput: pinInput
    property alias confirmPinInput: confirmPinInput

    property alias passwordInput: passwordInput
    property alias confirmPasswordInput: confirmPasswordInput

    property bool editing: pinInput.editing ||
                           confirmPinInput.editing ||
                           passwordInput.editing ||
                           confirmPasswordInput.editing

    function clear() {
        pinInput.text = ""
        confirmPinInput.text = ""
        passwordInput.text = ""
        confirmPasswordInput.text = ""
    }

    IntValidator { id: pinValidator; bottom: 0; top: 9999 }

    RegExpValidator { id: passwordValidator; regExp: /^[0-9a-zA-Z !@#$%^&*()_+|~=`{}[\]:";'<>?,.\\/-]+$/ }

    RowLayout {
        visible: inputPin
        spacing: Theme.marginSize

        TitledTextField {
            id: pinInput
            objectName: "userResetPinField"
            Layout.preferredWidth: 1
            inputMethod: TitledTextField.InputMethod.PIN
            validator: pinValidator
            placeholderText: "Ex. 1234"
            title: qsTr("PIN")

            onEditingChanged: if (editing) {
                                  userCodeRequirementsPopup.pinMode = true
                                  userCodeRequirementsPopup.position(textField)
                              }
        }

        TitledTextField {
            id: confirmPinInput
            objectName: "userConfrimPinField"
            Layout.preferredWidth: 1
            inputMethod: TitledTextField.InputMethod.PIN
            validator: pinValidator
            placeholderText: pinInput.placeholderText
            title: qsTr("Confirm PIN")

            onEditingChanged: if (editing) {
                                  userCodeRequirementsPopup.pinMode = true
                                  userCodeRequirementsPopup.position(textField)
                              }
        }
    }

    RowLayout {
        visible: inputPassword
        spacing: Theme.marginSize

        TitledTextField {
            id: passwordInput
            objectName: "userResetPasswordField"
            Layout.preferredWidth: 1
            inputMethod: TitledTextField.InputMethod.Password
            validator: passwordValidator
            placeholderText: "Ex. Gl0busMed!cal"
            title: qsTr("Password")

            onEditingChanged: if (editing) {
                                  userCodeRequirementsPopup.pinMode = false
                                  userCodeRequirementsPopup.position(textField)
                              }
        }

        TitledTextField {
            id: confirmPasswordInput
            objectName: "userConfirmPasswordField"
            Layout.preferredWidth: 1
            inputMethod: TitledTextField.InputMethod.Password
            validator: passwordValidator
            placeholderText: passwordInput.placeholderText
            title: qsTr("Confirm Password")

            onEditingChanged: if (editing) {
                                  userCodeRequirementsPopup.pinMode = false
                                  userCodeRequirementsPopup.position(textField)
                              }
        }
    }
}
