import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

Popup {
    width: Theme.margin(90)
    height: layout.height + Theme.margin(4)

    property alias maxTextLength: textField.maximumLength  // maximum permissible number of characters in the field
    property alias placeholderText: textField.placeholderText  // hint visible when there is no text in the field
    property alias textValidator: textField.validator  // validator for restricting acceptable input characters
    property string initialText: ""  // initial text present in the field when the popup is opened
    property string popupTitle: ""  // title of the popup
    property alias errorText: errorLabel.text  // text of the error label
    property alias confirmButtonEnabled: confirmButton.enabled  // text of the confirm button
    property alias currentText: textField.text  // current text in the field

    signal confirmClicked(string confirmedText)
    signal textEditChanged(string currentText)

    onConfirmClicked: close()

    onClosed: textField.text = Qt.binding(function() { return initialText })

    onOpened: textField.forceActiveFocus()

    ColumnLayout {
        id: layout
        width: parent.width - Theme.margin(4)
        anchors { centerIn: parent }
        spacing: Theme.margin(2)

        Label {
            Layout.topMargin: Theme.margin(3)
            state: "h4"
            text: popupTitle
        }

        TextField {
            objectName: "TextFieldPopupTextField"
            id: textField
            Layout.fillWidth: true
            text: initialText
            rightPadding: clearButton.width
            onTextEdited: 
            {
                textEditChanged(text)
            }

            MouseArea {
                id: clearButton
                anchors { right: parent.right }
                width: textField.height
                height: width
                visible: textField.text
                onClicked: textField.text = ""
                Image {
                    anchors { centerIn: parent }
                    source: "qrc:/icons/x.svg"
                    width: Theme.margin(4)
                    height: width
                }
            }
        }

        Label 
        {
            id: errorLabel
            state: "error"
            visible: text
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            Layout.topMargin: Theme.margin(2)
            Layout.bottomMargin: Theme.margin(2)
            spacing: Theme.margin(2)

            Button {
                objectName: "TextFieldPopupCancelBtn"
                state: "available"
                text: "Cancel"

                onClicked: close()
            }

            Button {
                objectName: "TextFieldPopupConfirmBtn"
                id: confirmButton
                enabled: textField.text
                state: "active"
                text: "Confirm"

                onClicked: confirmClicked(textField.text)
            }
        }
    }
}
