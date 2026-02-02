import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import GmQml 1.0
import Theme 1.0

GridLayout {
    rowSpacing: Theme.margin(2)
    columnSpacing: Theme.margin(2)
    columns: 4

    property bool numberEnabled: true

    property alias signButtonVisible: signButton.visible
    property alias enterVisible: enterButton.visible
    property alias enterEnabled: enterButton.enabled

    signal numberPressed(var number)
    signal clearPressed()
    signal backspacePressed()
    signal signButtonPressed()
    signal enterButtonPressed()

    Repeater {
        model: [ "1", "2", "3", "4", "5", "6", "7", "8", "9", "EMPTY", "0", "C" ]

        delegate: Item {
            width: Theme.margin(8)
            height: Theme.margin(8)

            Layout.row: Math.floor(index/3)
            Layout.column: index % 3

            states: [
                State {
                    when: modelData === "C"
                    PropertyChanges { target: button; onClicked: clearPressed() }
                },
                State {
                    when: modelData === "EMPTY"
                    PropertyChanges { target: button; visible: false; enabled: false }
                },
                State {
                    when: modelData !== "C" && modelData !== "EMPTY"
                    PropertyChanges { target: button; enabled: numberEnabled }
                }
            ]

            CalculatorButton {
                id: button
                text: modelData
                color: Theme.transparent
                borderColor: Theme.navyLight

                onClicked: numberPressed(modelData)
            }
        }
    }

    CalculatorButton {
        Layout.row: 0
        Layout.column: 3
        enabled: true
        icon: "qrc:/images/backspace.svg"
        color: Theme.navy

        onClicked: backspacePressed()
    }

    CalculatorButton {
        id: signButton
        Layout.row: 1
        Layout.column: 3
        enabled: true
        text: "+/-"
        color: Theme.navy
        borderColor: Theme.white
        border.color: Theme.transparent

        onClicked: signButtonPressed()
    }

    CalculatorButton {
        id: enterButton
        enabled: false
        Layout.row: signButton.visible ? 2 : 1
        Layout.column: 3
        Layout.rowSpan: signButton.visible ? 2 : 3
        Layout.preferredHeight: signButton.visible ? Theme.margin(18) : Theme.margin(28)
        icon: "qrc:/images/return.svg"
        color: Theme.blue
        pressedColor: Theme.navyLight

        onClicked: enterButtonPressed()
    }
}
