import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0

ColumnLayout {
    id: expandableVerificationPanel
    spacing: Theme.margin(1)

    property bool selectable: true
    property bool expanded: true

    property alias title: label.text
    property alias editButtonVisible: editButton.visible
    property alias adapterSelectionVisible: checkbox.visible
    property alias adapterEnabled: checkbox.checked
    property alias contentItem: contentLoader.sourceComponent
    property alias activeStatus: activeStatusLabel.text

    signal clicked()
    signal editButtonClicked()
    signal adapterSelectionClicked()

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.margin(8)

        MouseArea {
            enabled: selectable
            anchors { fill: parent }

            onClicked: expandableVerificationPanel.clicked()
        }

        ColumnLayout {
            width: parent.width
            anchors { verticalCenter: parent.verticalCenter }
            spacing: 0

            RowLayout {
                Layout.fillWidth: true
                spacing: Theme.margin(1)

                IconImage {
                    rotation: expanded * 90
                    source: "qrc:/icons/chevron-right"
                    sourceSize: Theme.iconSize

                    Behavior on rotation { PropertyAnimation { } }
                }

                Label {
                    id: label
                    Layout.alignment: Qt.AlignVCenter
                    state: "subtitle1"
                    font.bold: true
                }

                LayoutSpacer {

                }

                CheckBox {
                    id: checkbox
                    visible: false
                    Layout.rightMargin: Theme.margin(8)
                    spacing: Theme.margin(1)
                    text: qsTr("Use Adapter")
                    font { pixelSize: 16; bold: false }

                    onToggled: adapterSelectionClicked()


                }

                Button {
                    id: editButton
                    visible: false
                    Layout.preferredWidth: Theme.margin(4)
                    Layout.preferredHeight: Theme.margin(4)
                    state: "icon"
                    icon.source: "qrc:/icons/pencil.svg"

                    onClicked: editButtonClicked()
                }
            }

            Label {
                id: activeStatusLabel
                Layout.fillWidth: true
                Layout.leftMargin: Theme.margin(5)
                Layout.alignment: Qt.AlignVCenter
                state: "body2"
                color: text == "Active" || 
                    text == "Always Active" || 
                    text == "Excelsius Active" || 
                    text == "Power Tools Active" ? Theme.green : Theme.navyLight
            }
        }

        DividerLine {
            anchors { bottom: parent.bottom }
            orientation: Qt.Horizontal
        }
    }

    ColumnLayout {
        visible: expanded
        spacing: 0

        Loader {
            id: contentLoader
            visible: sourceComponent
            active: expanded
            Layout.fillWidth: true
        }
    }
}
