import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

Popup {
    width: Theme.margin(140)
    height: layout.height

    background: Rectangle { radius: 8; color: Theme.slate500 }

    property alias title: label.text
    property alias stepModel: repeater.model

    ColumnLayout {
        id: layout
        width: parent.width
        spacing: Theme.margin(2)

        RowLayout {
            Layout.topMargin: Theme.margin(5)
            Layout.leftMargin: Theme.margin(4)
            Layout.rightMargin: Theme.margin(4)
            spacing: Theme.margin(4)

            IconImage {
                sourceSize: Qt.size(64, 64)
                color: Theme.blue
                source: "qrc:/icons/info-circle-fill.svg"
            }

            Label {
                id: label
                Layout.fillWidth: true
                state: "h4"
                verticalAlignment: Qt.AlignVCenter
                font.styleName: Theme.mediumFont.styleName
            }
        }

        ColumnLayout {
            Layout.leftMargin: Theme.margin(16)
            Layout.rightMargin: Theme.margin(4)
            Layout.bottomMargin: Theme.margin(4)
            spacing: Theme.margin(1)

            Repeater {
                id: repeater

                RowLayout {
                    spacing: 0
                    Label {
                        Layout.preferredWidth: Theme.margin(6)
                        Layout.alignment: Qt.AlignTop
                        state: "h6"
                        verticalAlignment: Text.AlignTop
                        horizontalAlignment: Text.AlignLeft
                        font.styleName: Theme.regularFont.styleName
                        text: index + 1 + "."
                    }

                    Label {
                        Layout.fillWidth: true
                        state: "h6"
                        horizontalAlignment: Text.AlignLeft
                        font.styleName: Theme.regularFont.styleName
                        wrapMode: Label.Wrap
                        text: modelData
                    }
                }
            }
        }
    }

    MouseArea {
        anchors { fill: parent }

        onClicked: close()
    }
}
