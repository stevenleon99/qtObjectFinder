import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import GmQml 1.0
import Theme 1.0

Popup {
    width: layout.width
    height: layout.height
    dim: false

    property bool initialOffset: false
    property string offsetStr: ""
    signal enterPressed(int offsetValue)

    background: Rectangle { radius: 8; color: Theme.slate900 }

    function setup(positionItem, initialValue) {
        var position = positionItem.mapToItem(null, 0, 0)
        var newX = position.x
        var newY = position.y - height - Theme.margin(2)

        x = newX
        y = newY

        rectangle.x = positionItem.width/2 - rectangle.width/2

        offsetStr = initialValue
        initialOffset = true

        visible = true;
    }

    Rectangle {
        id: rectangle
        z: 1000
        y: parent.height - height / 2
        width: Theme.margin(2)
        height: width
        rotation: 45
        color: Theme.slate900
    }

    Button {
        anchors { top: parent.top; right: parent.right; margins: Theme.margin(.5) }
        icon.source: "qrc:/images/x.svg"
        state: "icon"

        onClicked: close()
    }

    ColumnLayout {
        id: layout
        width: calculatorKeypad.width + Theme.margin(4)
        spacing: 0

        Label {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(6.5)
            Layout.leftMargin: Theme.margin(2)
            Layout.alignment: Qt.AlignVCenter
            state: "subtitle2"
            font { bold: true; letterSpacing: 1; capitalization: Font.AllUppercase }
            verticalAlignment : Text.AlignVCenter
            color: Theme.headerTextColor
            text: qsTr("OFFSET (MM)")
        }

        Label {
            id: searchBox
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)
            Layout.leftMargin: Theme.margin(2)
            state: "h5"
            font.styleName: Theme.mediumFont.styleName
            verticalAlignment: Text.AlignVCenter
            text: offsetStr
        }

        DividerLine { }

        CalculatorKeypad {
            id: calculatorKeypad
            Layout.margins: Theme.margin(2)

            enterEnabled: offsetStr && offsetStr !== "-"
            numberEnabled: initialOffset || offsetStr.length < (offsetStr.charAt(0) === '-' ? 4 : 3)

            function toggleOffsetSign(value) {
                return -value;
            }

            onNumberPressed: {
                if (initialOffset) {
                    offsetStr = number
                } else {
                    offsetStr += number
                }
            }

            onClearPressed: offsetStr = ""

            onBackspacePressed: offsetStr = offsetStr.substring(0, offsetStr.length - 1)

            onSignButtonPressed: {
                if (offsetStr == "" || offsetStr == "0") {
                    offsetStr = "-"
                } else if (offsetStr == "-") {
                    offsetStr = ""
                } else {
                    offsetStr = toggleOffsetSign(offsetStr)
                }
            }

            onEnterButtonPressed: {
                close()
                enterPressed(parseInt(offsetStr))
            }
        }
    }

    onOffsetStrChanged: {
        // Clear inital offset value if any
        if (initialOffset)
            initialOffset = false
    }
}
