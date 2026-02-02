import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import ".."

Rectangle {
    id: volumeMergeListDelegate
    height: contentItem.height + Theme.marginSize
    radius: 8
    border { width: (selected ||compareSelected)  ? 2 : 1;
        color: {
            if (selected)
                return Theme.blue
            else if (compareSelected)
                return Theme.green
            else
                return Theme.gunmetal
        }
    }
    color: (selected ||compareSelected) ? Theme.slate800
                                        : Theme.transparent

    property bool selected: false
    property bool compareSelected: false

    property bool taskRunning: false
    property bool isStudyMode: false
    property bool isDisabled: (algorithmLabel == "Manual" && taskRunning)
    property var indexPositionLabel
    property var algorithmLabel


    signal thumbnailClicked()
    signal reRegisterClicked()
    signal studyClicked()
    signal verifyClicked()

    RowLayout {
        id: contentItem
        anchors { centerIn: parent }
        width: parent.width - Theme.margin(2)
        spacing: 0

        IconImage {
            enabled: selected
            Layout.alignment: Qt.AlignHCenter
            source: "qrc:/images/merge-fill.svg"
            sourceSize: Theme.iconSize
            color: isDisabled? Theme.disabledColor: Theme.white

            MouseArea {
                anchors { fill: parent }
                onClicked: studyClicked()
            }

            Text {
                id: text
                text: indexPositionLabel
                color: Theme.black
                font.pixelSize: 12
                font.bold: true
                anchors.centerIn: parent
            }
        }

        Label {
            visible: isStudyMode
            Layout.fillWidth: true
            state: "body1"
            text: algorithmLabel
            font.bold: true
            color: isDisabled? Theme.disabledColor: Theme.white
        }

        Button {
            enabled: selected && !taskRunning
            visible: algorithmLabel != "Manual" && !taskRunning
            state: "icon"
            icon.source: "qrc:/icons/refresh.svg"

            onClicked: {
                if (enabled)
                {
                    reRegisterClicked()
                }
            }
        }

        BusyIndicator {
            id: busyIndicator
            visible: algorithmLabel != "Manual" && taskRunning
            Layout.preferredWidth: Theme.marginSize * 2
            Layout.preferredHeight: Theme.marginSize * 2
            Layout.rightMargin: 6
        }


        Button {
            Layout.preferredWidth: Theme.margin(10)
            enabled: selected && !taskRunning
            visible: isStudyMode
            state: "active"
            text: "Set"

            onClicked: verifyClicked()
        }
    }

    MouseArea {
        enabled: (!selected && algorithmLabel != "Manual") || (!selected && algorithmLabel == "Manual" && !taskRunning)
        anchors { fill: parent }
        propagateComposedEvents: false

        onClicked: thumbnailClicked()
    }
}
