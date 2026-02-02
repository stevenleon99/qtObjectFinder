import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0

Item {
    ColumnLayout {
        anchors.centerIn: parent

        IconImage {
            id: image
            Layout.alignment: Qt.AlignHCenter
            color: Theme.navy
            sourceSize: Qt.size(120, 120)
            fillMode: Image.PreserveAspectFit
            source: "qrc:/icons/cases.svg"
        }

        Label {
            id: label
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 185
            wrapMode: Label.WrapAnywhere
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("Select an item to view details.")
            font.bold: true
            state: "h6"
            color: Theme.slate100
        }

        Rectangle { id: spacer; width: parent.width; Layout.preferredHeight: 1 }
    }

    states: [
        State {
            name: "patients"
            PropertyChanges {
                target: label
                Layout.preferredWidth: 220
                text: qsTr("No patients added. Add new or import.")
            }
            PropertyChanges {
                target: image
                source: "qrc:/icons/folder-man.svg"
            }
            PropertyChanges {
                target: spacer
                Layout.preferredHeight: Theme.marginSize * 6
            }
        },
        State {
            name: "cases"
            PropertyChanges {
                target: label
                Layout.preferredWidth: 300
                text: qsTr("No cases or studies added. Add new or import.")
            }
            PropertyChanges {
                target: image
                source: "qrc:/icons/case.svg"
            }
            PropertyChanges {
                target: spacer
                Layout.preferredHeight: Theme.marginSize * 6
            }
        }
    ]
}
