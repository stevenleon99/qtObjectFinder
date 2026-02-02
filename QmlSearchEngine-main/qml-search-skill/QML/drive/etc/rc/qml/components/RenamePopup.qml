import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

Popup {
    y: 249
    width: Theme.margin(80)
    height: layout.implicitHeight + Theme.margin(8)
    closePolicy: Popup.NoAutoClose

    property alias title: titleLabel.text
    property alias text: textField.text

    signal saveClicked()

    onSaveClicked: close()

    onOpened: textField.forceActiveFocus()

    ColumnLayout {
        id: layout
        width: parent.width - Theme.margin(8)
        anchors { centerIn: parent }
        spacing: 0

        ColumnLayout {
            spacing: Theme.margin(4)

            ColumnLayout {
                spacing: Theme.margin(2)

                Label {
                    id: titleLabel
                    Layout.fillWidth: true
                    state: "h4"
                    font.styleName: Theme.mediumFont.styleName
                }

                TextField {
                    id: textField
                    Layout.fillWidth: true
                    color: Theme.navyLight
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                spacing: Theme.margin(2)

                Button {
                    Layout.preferredWidth: Theme.margin(16)
                    state: "available"
                    text: qsTr("Cancel")

                    onClicked: close()
                }

                Button {
                    enabled: textField.text
                    Layout.preferredWidth: Theme.margin(16)
                    state: "active"
                    text: qsTr("Save")

                    onClicked: saveClicked()
                }
            }
        }
    }
}
