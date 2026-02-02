import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import "../components"

Item {
    width: rowLayout.width
    height: Theme.margin(5)

    property string selectedOption

    property alias displayString: label.text
    property alias optionList: optionsPopup.model

    signal selected(string option)

    Rectangle {
        opacity: 0.16
        radius: 4
        anchors { fill: parent }
        color: optionsPopup.opened ? Theme.blue : Theme.transparent
    }

    RowLayout {
        id: rowLayout
        anchors { verticalCenter: parent.verticalCenter }
        spacing: 0

        Label {
            id: label
            leftPadding: Theme.margin(1)
            state: "subtitle2"
            color: Theme.white
            text: selectedOption
        }

        IconImage {
            visible: enabled
            sourceSize: Theme.iconSize
            source: "qrc:/icons/caret-down"
            color: optionsPopup.opened ? Theme.blue : Theme.white
        }

        OptionsPopup {
            id: optionsPopup
            visible: false
            popupAlignment: OptionsPopup.PopupAlignment.Right

            optionDelegate: Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(8)

                property bool isSelected: modelData === selectedOption

                Rectangle { anchors.fill: parent; opacity: 0.16; radius: 4; color: isSelected ? Theme.blue : Theme.transparent }

                RowLayout {
                    anchors { fill: parent }
                    spacing: 0

                    Item {
                        Layout.preferredWidth: height
                        Layout.fillHeight: true

                        IconImage {
                            visible: isSelected
                            anchors { centerIn: parent }
                            sourceSize: Theme.iconSize
                            color: Theme.blue
                            source: "qrc:/icons/check.svg"
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        state: "body1"
                        font.bold: true
                        text: modelData
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors { fill: parent }

                    onClicked: {
                        optionsPopup.close()
                        selected(modelData)
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onPressed: {
            if (!optionsPopup.visible)
                optionsPopup.setup(this)}
    }
}
