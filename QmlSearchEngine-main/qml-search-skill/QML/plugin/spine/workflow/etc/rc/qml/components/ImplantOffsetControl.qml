import QtQuick 2.12
import QtQml.Models 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Rectangle {
    id: implantOffsetControl
    Layout.preferredWidth: Theme.margin(25)
    Layout.preferredHeight: Theme.margin(6)

    radius: 4
    border { color: offsetCalculator.visible ? Theme.blue : Theme.navyLight }
    color: Theme.transparent

    readonly property int minimum: -999
    readonly property int maximum: 999

    property int offset: 0

    signal offsetValueChanged(int offsetValue)

    function updateOffset(change) {
        var result  = offset + change
        if ((result >= minimum) && (result <= maximum)) {
            offsetValueChanged(result)
        }
    }

    OffsetCalculator {
        id: offsetCalculator

        onEnterPressed: offsetValueChanged(offsetValue)
    }

    RowLayout {
        id: rowLayout
        anchors { fill: parent; leftMargin: 4; rightMargin: 4 }
        spacing: 0

        Button {
            Layout.preferredHeight: Theme.margin(4.5)
            Layout.preferredWidth: Theme.margin(4.5)
            rotation: 90
            icon.source: "qrc:/icons/double-arrow-down-stemless.svg"
            state: "icon"

            onClicked: updateOffset(-5)
        }

        Button {
            Layout.preferredHeight: Theme.margin(4.5)
            Layout.preferredWidth: Theme.margin(4.5)
            rotation: 90
            icon.source: "qrc:/icons/arrow-down-stemless.svg"
            state: "icon"

            onClicked: updateOffset(-1)
        }

        Label {
            Layout.fillWidth: true
            Layout.fillHeight: true
            state: "subtitle2"
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
            elide: Text.ElideNone
            text: offset
            color: offsetCalculator.visible ? Theme.blue : Theme.white

            background: Rectangle { visible: offsetCalculator.visible; anchors.fill: parent; anchors.topMargin: 6; anchors.bottomMargin: 6; color: Theme.blue; opacity: .32; radius: 4 }

            MouseArea {
                anchors.fill: parent
                onClicked: offsetCalculator.setup(implantOffsetControl, offset)
            }
        }

        Button {
            Layout.preferredHeight: Theme.margin(4.5)
            Layout.preferredWidth: Theme.margin(4.5)
            rotation: -90
            icon.source: "qrc:/icons/arrow-down-stemless.svg"
            state: "icon"

            onClicked: updateOffset(1)
        }

        Button {
            Layout.preferredHeight: Theme.margin(4.5)
            Layout.preferredWidth: Theme.margin(4.5)
            rotation: -90
            icon.source: "qrc:/icons/double-arrow-down-stemless.svg"
            state: "icon"

            onClicked: updateOffset(5)
        }
    }
}
