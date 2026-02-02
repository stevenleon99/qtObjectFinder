import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

Popup {
    y: 249
    width: Theme.margin(93)
    height: layout.height + Theme.margin(8)
    closePolicy: Popup.NoAutoClose

    property string caseName: ""
    property string caseNotes: ""

    signal savedClicked(string notesText)

    onSavedClicked: close()

    onOpened: caseNotesText.forceActiveFocus()

    ColumnLayout {
        id: layout
        width: parent.width - Theme.margin(8)
        anchors { centerIn: parent }
        spacing: Theme.margin(2)

        RowLayout {
            spacing: 0

            Label {
                Layout.maximumWidth: layout.width - notesLabel.width
                state: "h4"
                font.bold: true
                maximumLineCount: 1
                text: "\"" + caseName
            }

            Label {
                id: notesLabel
                state: "h4"
                font.bold: true
                text: "\" " + qsTr("Notes")
            }
        }

        ColumnLayout {
            spacing: Theme.margin(4)

            TextField {
                id: caseNotesText
                Layout.fillWidth: true
                Layout.preferredHeight: 232
                verticalAlignment: TextInput.AlignTop
                padding: Theme.marginSize
                wrapMode: Label.Wrap
                color: Theme.navyLight
                placeholderText: qsTr("Add Notes...")
                text: caseNotes
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: Theme.marginSize

                Button {
                    Layout.preferredWidth: Theme.margin(16)
                    state: "available"
                    text: qsTr("Cancel")

                    onClicked: close()
                }

                Button {
                    enabled: caseNotesText.text !== caseNotes
                    Layout.preferredWidth: Theme.margin(16)
                    state: "active"
                    text: qsTr("Save")

                    onClicked: {
                        savedClicked(caseNotesText.text);
                        close();
                    }
                }
            }
        }
    }
}
