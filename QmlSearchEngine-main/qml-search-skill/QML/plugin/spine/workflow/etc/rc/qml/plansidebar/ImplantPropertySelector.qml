import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.4 as T
import QtQuick.Window 2.12

import Theme 1.0

ColumnLayout {
    id: control
    spacing: Theme.margin(0.5)

    property int maxPopupHeight: Window.height - Theme.margin(8)
    property bool stepperEnabled: false

    property alias title: label.text
    property alias model: comboBox.model
    property alias displayText: comboBox.displayText
    property alias currentIndex: comboBox.currentIndex
    property alias comboBox: comboBox
    property alias count: comboBox.count

    signal valueSelected(int selectedIndex)

    function active() {
        return comboBox.pressed || comboBox.popup.visible
                || leftbutton.down || rightButton.down
    }

    Label {
        id: label
        visible: text
        state: "body2"
        color: Theme.navyLight
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.margin(6)
        radius: Theme.margin(0.5)
        border { width: 1; color: control.active() ? Theme.blue : Theme.navyLight }
        color: Theme.transparent

        RowLayout {
            anchors { fill: parent }
            spacing: 0

            Button {
                id: leftbutton
                visible: stepperEnabled
                enabled: comboBox.currentIndex > 0
                rotation: 90
                state: "icon"
                icon.source: "qrc:/icons/arrow-down-stemless"

                onClicked: valueSelected(comboBox.currentIndex - 1)
            }

            ComboBox {
                id: comboBox
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: Theme.margin(1)
                Layout.bottomMargin: Theme.margin(1)
                spacing: 0
                padding: 0
                leftPadding: stepperEnabled ? 0 : Theme.margin(2)
                rightPadding: stepperEnabled ? Theme.margin(1) : Theme.margin(4)

                background: Rectangle { visible: stepperEnabled && (comboBox.pressed || comboBox.popup.visible); radius: 4; opacity: 0.32; color: Theme.blue }

                delegate: ItemDelegate {
                    width: parent.width
                    text: comboBox.textRole ? (Array.isArray(comboBox.model) ? modelData[comboBox.textRole] : model[comboBox.textRole]) : modelData
                    font.bold: comboBox.currentIndex === index
                    font { pixelSize: 18; family: Theme.regularFont.family; letterSpacing: Theme.regularFont.letterSpacing }
                    highlighted: comboBox.highlightedIndex === index
                    hoverEnabled: comboBox.hoverEnabled
                    palette.text: comboBox.currentIndex === index ? Theme.blue : Theme.white

                    background: Rectangle { radius: 4;  opacity: 0.16; color: comboBox.currentIndex === index ? Theme.blue : Theme.transparent }
                }

                indicator: IconImage {
                    visible: comboBox.enabled
                    x: comboBox.mirrored ? comboBox.padding : comboBox.width - width - 4
                    y: stepperEnabled ? comboBox.height - height - 4 : 0
                    color: comboBox.pressed || comboBox.popup.visible ? Theme.blue : Theme.white
                    source: stepperEnabled ? "qrc:/icons/caret-small-angled.svg" : "qrc:/icons/caret-down.svg"
                    sourceSize: stepperEnabled ? Qt.size(6, 6) : Qt.size(32, 32)
                }

                contentItem: Label {
                    state: "subtitle2"
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: stepperEnabled ? Text.AlignHCenter : Text.AlignLeft
                    text: comboBox.displayText
                }

                popup: T.Popup {
                    y: comboBox.height + Theme.margin(1)
                    x: (comboBox.width - control.width) / 2
                    width: control.width
                    height: contentItem.implicitHeight < maxPopupHeight ? contentItem.implicitHeight
                                                                        : maxPopupHeight
                    topMargin: 6
                    bottomMargin: 6

                    contentItem: ListView {
                        clip: true
                        implicitWidth: contentWidth
                        implicitHeight: contentHeight
                        model: comboBox.delegateModel
                        currentIndex: comboBox.highlightedIndex
                        highlightMoveDuration: 0

                        T.ScrollBar.vertical: ScrollBar {
                            visible: parent.height < parent.contentHeight
                            padding: Theme.margin(0.5)
                        }
                    }

                    background: Rectangle { radius: 4;  color: Theme.slate900 }
                }

                onActivated: control.valueSelected(index)
            }


            Button {
                id: rightButton
                visible: stepperEnabled
                enabled: comboBox.currentIndex < (comboBox.count - 1)
                rotation: -90
                state: "icon"
                icon.source: "qrc:/icons/arrow-down-stemless"

                onClicked: valueSelected(comboBox.currentIndex + 1)
            }
        }
    }
}
