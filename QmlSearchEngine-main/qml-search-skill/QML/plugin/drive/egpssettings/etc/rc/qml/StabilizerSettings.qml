import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

ColumnLayout {
    spacing: Theme.margin(4)

    EgpsStabilizersViewModel { id: egpsStabilizersViewModel }

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("Stabilizer")
    }

    RowLayout {
        Layout.preferredHeight: Theme.margin(8)
        spacing: Theme.marginSize

        SettingsDescription {
            title: qsTr("Stabilizer Override")
            description: qsTr("Manually engage stabilizers.")

            StabilizerOverridePopup {
                id: stabilizerOverridePopup

                onCancelClicked: stabilizerOverrideCheckBox.checked = false
                onAcknowledgeClicked: egpsStabilizersViewModel.setStabilizerOverride(true)
            }
        }

        Item {
            Layout.fillWidth: true
        }

        CheckBox {
            id: stabilizerOverrideCheckBox

            onCheckedChanged: {
                if (checked) {
                    if (egpsStabilizersViewModel.stabilizerOverride === false) {
                        stabilizerOverridePopup.open()
                    }
                }
                else {
                    egpsStabilizersViewModel.setStabilizerOverride(checked)
                }
            }

            Connections {
                target: egpsStabilizersViewModel
                onStabilizerOverrideChanged: { 
                    if (stabilizerOverrideCheckBox.checked !== flag) {
                        stabilizerOverrideCheckBox.checked = flag
                    }
                }
            }
        }
    }
}
