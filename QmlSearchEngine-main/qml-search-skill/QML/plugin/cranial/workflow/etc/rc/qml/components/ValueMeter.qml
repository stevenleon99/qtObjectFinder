import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4

import Theme 1.0

Item {
    opacity: disabled ? 0.25 : 1
    Layout.preferredHeight: layout.height

    property real value: 0
    property real minValueYellow: 1 / 3
    property real minValueRed: 2 / 3

    property alias text: text.text

    property bool misc: true
    property bool disabled: false
    property bool clearable: false
    property bool loading: false

    ColumnLayout {
        id: layout
        width: parent.width
        anchors { centerIn: parent }
        spacing: 0

        RowLayout {
            visible: misc
            Layout.alignment: Qt.AlignHCenter
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.iconSize.height
            Layout.maximumHeight: Theme.iconSize.height
            spacing: Theme.marginSize / 4

            BusyIndicator {
                Layout.alignment: Qt.AlignVCenter
                width: Theme.iconSize.width
                height: Theme.iconSize.height
                visible: loading
            }

            Label {
                Layout.alignment: Qt.AlignVCenter
                id: text
                font { bold: true }
                color: Theme.white
                state: "body1"
            }

            IconImage {
                Layout.alignment: Qt.AlignVCenter
                Layout.fillHeight: true
                visible: clearable
                source: "qrc:/icons/x.svg"
                sourceSize: Theme.iconSize
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.marginSize / 2
            color: Theme.headerColor
            radius: height / 2

            Rectangle {
                width: value * parent.width
                height: parent.height
                radius: parent.height
                color: {
                    if (disabled)
                        return Theme.disabledColor
                    else if (value >= minValueRed)
                        return Theme.red
                    else if (value >= minValueYellow)
                        return Theme.yellow
                    else
                        return Theme.green
                }
            }
        }
    }
}
