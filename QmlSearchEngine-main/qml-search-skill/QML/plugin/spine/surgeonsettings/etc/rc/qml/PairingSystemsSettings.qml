import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

ColumnLayout {
    spacing: Theme.marginSize

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("Array Styles")
    }

    RowLayout {
        spacing: Theme.margin(4)

        SurgeonSettingsDescription {
            Layout.alignment: Qt.AlignTop

            title: qsTr("Active Array Styles")
            description: qsTr("Select the active Array Styles. ")
        }

        ColumnLayout {
            spacing: Theme.margin(3)

            Repeater {
                id: repeater
                model: surgeonSettingsViewModel.arrayTypeList

                RowLayout {

                    CheckBox {
                        checkState: role_isSelected ? Qt.Checked : Qt.Unchecked

                        onClicked: surgeonSettingsViewModel.toggleArrayType(role_arrayType)
                    }

                    Label {
                        state: "subtitle1"
                        text: role_displayName
                    }
                }
            }
        }
    }
}
