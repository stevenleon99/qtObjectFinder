import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

Popup {
    width: 450
    height: layout.height + Theme.margin(4)

    property alias maxTextLength: textField.maximumLength  // maximum permissible number of characters in the field
    property alias placeholderText: textField.placeholderText  // hint visible when there is no text in the field
    property alias textValidator: textField.validator  // validator for restricting acceptable input characters
    property string initialText: ""  // initial text present in the field when the popup is opened
    property string popupTitle: ""  // title of the popup

    signal confirmClicked(string confirmedText)
    signal confirmClickedAll(string confirmedText)

    onConfirmClicked: close()
    onConfirmClickedAll: close()

    onClosed: textField.text = Qt.binding(function() { return initialText })
    onAboutToShow: textField.clear()

    ColumnLayout {
        id: layout
        width: parent.width - Theme.margin(4)
        anchors { centerIn: parent }
        spacing: Theme.margin(2)

        Label {
            state: "h5"
            text: popupTitle
        }

        TextField {
            id: textField
            Layout.fillWidth: true
            placeholderText: initialText
            inputMethodHints: Qt.ImhFormattedNumbersOnly
        }

        RowLayout {
            Layout.alignment: Qt.AlignRight
            spacing: Theme.margin(2)

            Button {
                enabled: textField.text
                state: "hinted"
                text: "Set All"

                onClicked: confirmClickedAll(textField.text)
            }

            Button {
                enabled: textField.text
                state: "hinted"
                text: "Set Selected"

                onClicked: confirmClicked(textField.text)
            }

            Button {
                state: "available"
                text: "Cancel"

                onClicked: close()
            }
        }
    }
}
