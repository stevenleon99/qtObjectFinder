import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

import CalculatorSm 1.0
import CalculatorButtonType 1.0

import GmQml 1.0

Popup {
    width: layout.width
    height: layout.height
    dim: false
    closePolicy: Popup.NoAutoClose
    focus: true

    background: Rectangle { radius: 8; color: Theme.slate900 }

    property bool digitsEnabled: true
    property bool operatorsEnabled: calculatorPositionViewModel.displayValue
    // Set to true to position calculator above parent object. Otherwise it is below.
    property bool positionAbove: false

    function positionCalculator(positionItem) {
        var position = positionItem.mapToItem(null, 0, 0)
        var newX = position.x
        var newY = position.y + positionItem.height + Theme.margin(1)
        var bottomY = newY + height

        if (positionAbove) {
            newY = position.y - height - Theme.margin(1)
        }

        x = newX
        y = newY
    }

    function setup(positionItem, value, negativeLabel, positiveLabel, coordinateLabel, resultFuction) {
        positionCalculator(positionItem)
        m.resultFuction = resultFuction
        calculatorPositionViewModel.setCalculatorSetup(value, negativeLabel, positiveLabel, coordinateLabel)
        open()
    }

    QtObject {
        id: m

        property var resultFuction

        readonly property bool numbersValid: calculatorPositionViewModel.calcStateMachine === CalculatorSm.FirstNumberValidState ||
                                             calculatorPositionViewModel.calcStateMachine === CalculatorSm.SecondNumberValidState

        readonly property bool pointEnabled: calculatorPositionViewModel.isPointButtonEnabled

        readonly property bool enterEnabled: numbersValid && calculatorPositionViewModel.isEnterButtonEnabled

        function calculateResult(result) {
            close()

            if (resultFuction) {
                resultFuction(result)
            }
        }
    }

    CalculatorLPSViewModel {
        id: calculatorPositionViewModel
    }

    ColumnLayout {
        id: layout
        width: gridLayout.width + Theme.margin(4)
        spacing: 0

        RowLayout {
            Layout.preferredHeight: Theme.margin(8)
            spacing: Theme.margin(2)

            Label {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: Theme.margin(2)
                verticalAlignment: Label.AlignVCenter
                state: "subtitle1"
                color: Theme.navyLight
                text: calculatorPositionViewModel.coordinateLabel
            }

            Button {
                icon.source: "qrc:/images/x.svg"
                state: "icon"

                onClicked: close()
            }
        }

        Label {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.margin(2)
            state: "h5"
            font.styleName: Theme.mediumFont.styleName
            text: calculatorPositionViewModel.displayValue
        }

        RowLayout {
            Layout.leftMargin: Theme.margin(2)
            Layout.rightMargin: Theme.margin(2)
            Layout.bottomMargin: Theme.margin(2)
            spacing: 0

            Label {
                Layout.fillWidth: false
                Layout.rightMargin: Theme.margin(2)
                state: "h6"
                color: Theme.navy
                font.styleName: Theme.mediumFont.styleName
                elide: Label.ElideNone
                text: calculatorPositionViewModel.displayResult
            }

            LayoutSpacer { }

            RowLayout {
                visible: calculatorPositionViewModel.leftLabel && calculatorPositionViewModel.rightLabel
                Layout.fillWidth: true
                spacing: Theme.margin(1)

                Label {
                    Layout.fillWidth: true
                    Layout.maximumWidth: implicitWidth
                    state: "subtitle1"
                    font.styleName: Theme.mediumFont.styleName
                    font.bold: true
                    verticalAlignment: Label.AlignVCenter
                    fontSizeMode: Label.HorizontalFit
                    color: axisSwitch.position ? Theme.navyLight : Theme.blue
                    text: calculatorPositionViewModel.leftLabel
                }

                Switch {
                    id: axisSwitch
                    enabled: m.enterEnabled
                    Layout.fillWidth: false
                    position: calculatorPositionViewModel.axisSwitch

                    onPositionChanged: calculatorPositionViewModel.buttonPressed(position ? CalculatorButtonType.Toggle1_Button
                                                                                          : CalculatorButtonType.Toggle0_Button)
                }

                Label {
                    Layout.fillWidth: true
                    Layout.maximumWidth: implicitWidth
                    state: "subtitle1"
                    font.styleName: Theme.mediumFont.styleName
                    font.bold: true
                    verticalAlignment: Label.AlignVCenter
                    fontSizeMode: Label.HorizontalFit
                    color: axisSwitch.position ? Theme.blue : Theme.navyLight
                    text: calculatorPositionViewModel.rightLabel
                }
            }
        }

        DividerLine { }

        GridLayout {
            id: gridLayout
            Layout.margins: Theme.margin(2)
            rowSpacing: Layout.margins
            columnSpacing: Layout.margins
            columns: 4

            Repeater {
                model: ListModel {
                    ListElement { role_buttonType: CalculatorButtonType.Digit1_Button; role_icon: ""; role_text: "1"; role_color: "#1E2A31" }
                    ListElement { role_buttonType: CalculatorButtonType.Digit2_Button; role_icon: ""; role_text: "2"; role_color: "#1E2A31" }
                    ListElement { role_buttonType: CalculatorButtonType.Digit3_Button; role_icon: ""; role_text: "3"; role_color: "#1E2A31" }
                    ListElement { role_buttonType: CalculatorButtonType.Backspace_Button; role_icon: "qrc:/images/backspace.svg"; role_text: ""; role_color: "#5E8095" }
                    ListElement { role_buttonType: CalculatorButtonType.Digit4_Button; role_icon: ""; role_text: "4"; role_color: "#1E2A31" }
                    ListElement { role_buttonType: CalculatorButtonType.Digit5_Button; role_icon: ""; role_text: "5"; role_color: "#1E2A31" }
                    ListElement { role_buttonType: CalculatorButtonType.Digit6_Button; role_icon: ""; role_text: "6"; role_color: "#1E2A31" }
                    ListElement { role_buttonType: CalculatorButtonType.Plus_Button; role_icon: ""; role_text: "+"; role_color: "#5E8095" }
                    ListElement { role_buttonType: CalculatorButtonType.Digit7_Button; role_icon: ""; role_text: "7"; role_color: "#1E2A31" }
                    ListElement { role_buttonType: CalculatorButtonType.Digit8_Button; role_icon: ""; role_text: "8"; role_color: "#1E2A31" }
                    ListElement { role_buttonType: CalculatorButtonType.Digit9_Button; role_icon: ""; role_text: "9"; role_color: "#1E2A31" }
                    ListElement { role_buttonType: CalculatorButtonType.Minus_Button; role_icon: ""; role_text: "-"; role_color: "#5E8095" }
                    ListElement { role_buttonType: CalculatorButtonType.Digit0_Button; role_icon: ""; role_text: "0"; role_color: "#1E2A31" }
                    ListElement { role_buttonType: CalculatorButtonType.DecimalPoint_Button; role_icon: ""; role_text: "."; role_color: "#1E2A31" }
                    ListElement { role_buttonType: CalculatorButtonType.Clear_Button; role_icon: ""; role_text: "C"; role_color: "#1E2A31" }
                }

                CalculatorButton {
                    enabled: switch (role_buttonType) {
                             case CalculatorButtonType.Clear_Button:
                             case CalculatorButtonType.Backspace_Button: return true
                             case CalculatorButtonType.Plus_Button:
                             case CalculatorButtonType.Minus_Button: return operatorsEnabled
                             case CalculatorButtonType.DecimalPoint_Button: return m.pointEnabled
                             default: return digitsEnabled
                             }
                    text: role_text
                    color: role_color
                    icon: role_icon

                    onClicked: calculatorPositionViewModel.buttonPressed(role_buttonType)
                }
            }

            CalculatorButton {
                enabled: m.enterEnabled
                icon: "qrc:/images/return.svg"
                color: "#0099FF"

                onClicked: m.calculateResult(calculatorPositionViewModel.finalResult)
            }
        }
    }
}
