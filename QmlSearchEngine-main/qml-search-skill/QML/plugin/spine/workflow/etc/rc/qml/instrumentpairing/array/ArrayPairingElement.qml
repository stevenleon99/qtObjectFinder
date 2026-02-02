import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0
import GmQml 1.0

Rectangle {
    id: arrayPairingElem
    width: ListView.view.width
    height: Theme.margin(10)
    radius: Theme.margin(1)
    color: Theme.transparent
    border { width: 1; color: Theme.lineColor }

    property bool selected
    property color arrayColor
    property int arrayNum
    property bool displayArrayNum
    property string instrumentName
    property string instrumentPartNum
    property string iconSource

    signal clicked()

    Rectangle {
        anchors { fill: parent }
        color: Theme.blue
        opacity: selected ? 0.16 : 0
        radius: Theme.margin(1)
    }

    RowLayout {
        anchors { fill: parent; leftMargin: Theme.marginSize; rightMargin: Theme.marginSize }
        spacing: Theme.margin(1)

        IconImage {
            Layout.preferredWidth: Theme.margin(4)
            Layout.preferredHeight: width
            sourceSize: Theme.iconSize
            source: iconSource
            color: arrayColor

            Label {
                visible: displayArrayNum
                anchors { centerIn: parent }
                state: "subtitle2"
                text: arrayNum.toString()
            }
        }

        Item {
            Layout.preferredWidth: Theme.margin(12.5)
            Layout.preferredHeight: label.height

            Label {
                id: label
                width: parent.width
                state: "body1"
                color: Theme.headerTextColor
                text: instrumentPartNum
                leftPadding: Theme.margin(1)
                wrapMode: Label.Wrap
                maximumLineCount: 2
            }
        }

        Label {
            Layout.fillWidth: true
            state: "subtitle2"
            text: instrumentName
            wrapMode: Label.Wrap
            maximumLineCount: 2
        }
    }

    MouseArea {
        anchors { fill: parent }
        onClicked: arrayPairingElem.clicked()
    }
}
