import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

ColumnLayout {
    Layout.fillWidth: true
    spacing: Theme.marginSize / 2

    readonly property string selectedGender: textField.enabled ? textField.text : gender
    property string gender: ""

    Label {
        id: label
        state: "body1"
        text: qsTr("Sex")
        color: Theme.headerTextColor
    }

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.marginSize * 3
        Layout.leftMargin: Theme.marginSize / 2

        RowLayout {
            anchors.fill: parent
            spacing: Theme.marginSize * 1.5

            RadioButton {
                id: maleButton
                text: qsTr("Male")
                checked: text === gender
                onClicked: gender = text;
            }

            RadioButton {
                id: femaleButton
                text: qsTr("Female")
                checked: text === gender
                onClicked: gender = text;
            }

            RowLayout {
                spacing: 0

                RadioButton {
                    id: otherButton
                    checked: !maleButton.checked &&
                             !femaleButton.checked && (gender !== "")
                    onClicked: gender = "Other...";
                }

                TextField {
                    id: textField
                    Layout.preferredWidth: 170
                    Layout.fillHeight: true
                    enabled: otherButton.checked
                    text: enabled ? gender : ""
                    maximumLength: 30
                }
            }
        }
    }
}
