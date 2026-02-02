import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import "../components"

ColumnLayout {
    spacing: Theme.marginSize / 2

    property int currentHeightIn: 0
    readonly property int heightInches: (textFeet.text === "" ? 0 : (parseInt(textFeet.text) * 12))
                                            + (textInch.text === "" ? 0 : parseInt(textInch.text))

    Label {
        id: label
        state: "body1"
        text: qsTr("Height (ft./in.)")
        color: textFeet.activeFocus || textInch.activeFocus ? Theme.blue : Theme.navyLight
    }
    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.marginSize * 3
        color: Theme.transparent
        border.color: textFeet.activeFocus || textInch.activeFocus ? Theme.blue : Theme.navyLight
        radius: 4

        RowLayout {
            id: container
            anchors.fill: parent
            TextField {
                id: textFeet
                Layout.preferredWidth: container.width / 2
                text: Math.trunc(currentHeightIn / 12)
                background: Item {}
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator { bottom: 0; top: 9 }
            }

            DividerLine { color: textFeet.activeFocus || textInch.activeFocus ? Theme.blue : Theme.navyLight }

            TextField {
                id: textInch
                Layout.preferredWidth: container.width / 2
                text: (currentHeightIn.toFixed(0) % 12)
                background: Item {}
                inputMethodHints: Qt.ImhDigitsOnly
                validator: IntValidator { bottom: 0; top: 11 }
            }
        }
    }
}
