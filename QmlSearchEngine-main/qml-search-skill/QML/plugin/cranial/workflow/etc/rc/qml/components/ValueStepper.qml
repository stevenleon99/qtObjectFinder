import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Rectangle {
    Layout.preferredHeight: Theme.marginSize * 5
    Layout.fillWidth: true
    radius: 4
    border { width: 1; color: selected ? Theme.blue : Theme.lineColor }
    color: Theme.backgroundColor

    property alias labelTitle: labelTitleId.text
    property bool selected: false
    property bool enableValue: true
    property bool enableArrows: false
    property real value
    property string valueLabel

    property int displayPrecision: 2

    signal increaseClicked()
    signal decreaseClicked()
    signal labelClicked()

    ColumnLayout {
        anchors { fill: parent }
        spacing: -Theme.marginSize / 2

        Label {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 1
            state: "h6"
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
            color: selected ? Theme.blue : Theme.white
            //text: enableValue ? displayValue + " " + displayLabel : "---"
            text: enableValue ? displayValue : "---"

            readonly property string displayValue: value.toFixed(displayPrecision)
            //readonly property string displayLabel: valueLabel.charAt(0).toUpperCase()

            MouseArea {
                anchors { fill: parent }

                onClicked: labelClicked()
            }
        }

        Label {
            id: labelTitleId
            visible: labelTitle.length > 0
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 1
            state: "caption"
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
            color: selected ? Theme.blue : Theme.white
        }

        Item {
            visible: enabled
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredHeight: 1

            RowLayout {
                anchors { centerIn: parent }
                spacing: 0

                Button {
                    enabled: enableArrows
                    rotation: 180
                    icon.source: "qrc:/icons/arrow-small.svg"
                    color: Theme.navyLight
                    state: "icon"

                    onClicked: decreaseClicked()
                }

                Label {
                    state: "h6"
                    verticalAlignment: Label.AlignVCenter
                    horizontalAlignment: Label.AlignHCenter
                    color: Theme.white
                    text: displayLabel

                    readonly property string displayLabel: valueLabel.charAt(0).toUpperCase()
                }

                Button {
                    enabled: enableArrows
                    icon.source: "qrc:/icons/arrow-small.svg"
                    color: Theme.navyLight
                    state: "icon"

                    onClicked: increaseClicked()
                }
            }
        }
    }
}
