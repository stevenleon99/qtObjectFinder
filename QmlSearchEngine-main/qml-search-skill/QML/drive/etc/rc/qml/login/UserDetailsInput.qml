import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import "../components"

ColumnLayout {
    spacing: Theme.margin(2)

    property alias username: usernameInput.text
    property alias initials: initialsInput.text

    property color selectedColor: Theme.black

    property bool editing: usernameInput.editing ||
                           initialsInput.editing

    RowLayout {
        spacing: Theme.marginSize

        TitledTextField {
            id: usernameInput
            Layout.fillWidth: true
            placeholderText: "Ex. Dr. Dee Fault"
            title: qsTr("Username")
        }

        TitledTextField {
            id: initialsInput
            Layout.preferredWidth: Theme.margin(24)
            inputMethod: TitledTextField.InputMethod.Initials
            placeholderText: "Ex. DF"
            title: qsTr("Initials (2)")
        }
    }

    ColumnLayout {
        spacing: Theme.margin(1)

        Label {
            text: qsTr("Portrait Color")
            state: "body1"
            color: Theme.headerTextColor
        }

        Rectangle {
            Layout.preferredWidth: layout.width + Theme.margin(4)
            Layout.preferredHeight: layout.height + Theme.margin(4)
            color: Theme.transparent
            border.color: Theme.navyLight
            radius: 4

            RowLayout {
                id: layout
                x: Theme.margin(2)
                y: Theme.margin(2)
                spacing: Theme.marginSize

                Repeater {
                    model: Theme.secondaryColorList
                    Rectangle {
                        objectName: "autoColoredRectangleItem_" + index
                        Layout.preferredWidth: Theme.marginSize * 3
                        Layout.preferredHeight: width
                        radius: 4
                        border { width: Qt.colorEqual(selectedColor, modelData) ? 4 : 0; color: Theme.blue }
                        color: modelData
                       
                        MouseArea {
                            anchors { fill: parent }

                            onClicked: selectedColor = modelData
                        }
                    }
                }
            }
        }
    }
}
