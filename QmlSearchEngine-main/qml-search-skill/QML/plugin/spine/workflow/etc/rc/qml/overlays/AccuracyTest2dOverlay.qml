import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

Item {
    id: accuracyTest2dOverlay
    visible: renderer.scanList.length && accuracyTest2dOverlayViewModel.overlayEnabled
    anchors { fill: parent }

    property var renderer

    AccuracyTest2dOverlayViewModel {
        id: accuracyTest2dOverlayViewModel
        viewport: renderer
    }

    ColumnLayout {
        anchors { top: parent.top; topMargin: Theme.margin(1); right: parent.right; rightMargin: Theme.margin(2) }
        spacing: Theme.margin(1)

        Label {
            state: "subtitle1"
            font.bold: true
            text: accuracyTest2dOverlayViewModel.shotFileName
            color: Theme.green

        }
    }

    ColumnLayout {
        anchors { bottom: parent.bottom; bottomMargin: Theme.margin(2) + 70; left: parent.left; leftMargin: Theme.margin(2) }
        spacing: Theme.margin(1)

        Label {
            visible: accuracyTest2dOverlayViewModel.errorStatisticsAvailable;
            state: "subtitle1"
            font.bold: true
            font.pixelSize: 20
            text: "Errors (mm): 99CI = " + (accuracyTest2dOverlayViewModel.error99ci).toFixed(3) +
                    ", 95TI = " + (accuracyTest2dOverlayViewModel.error95ti).toFixed(3)
            color: Theme.red
            background: Rectangle {
                color: Theme.white
                opacity: 0.6
            }
        }

        Label {
            visible: accuracyTest2dOverlayViewModel.errorStatisticsAvailable;
            state: "subtitle1"
            font.bold: true
            font.pixelSize: 20
            text: "MIN = " + (accuracyTest2dOverlayViewModel.minError).toFixed(3) + 
                    ", MAX = " + (accuracyTest2dOverlayViewModel.maxError).toFixed(3) +
                    ", AVG = " + (accuracyTest2dOverlayViewModel.errorAverage).toFixed(3) +
                    ", STD = " + (accuracyTest2dOverlayViewModel.errorSTD).toFixed(3) +
                    " (n = " + (accuracyTest2dOverlayViewModel.bbCount) + ")" 
            color: Theme.red
            background: Rectangle {
                color: Theme.white
                opacity: 0.6
            }
        }
    }

    Repeater {
        model: accuracyTest2dOverlayViewModel.accTestResults

        Rectangle {
            x: markerPosition.x - (width / 2)
            y: markerPosition.y - (height / 2)
            width: (accuracyTest2dOverlayViewModel.minDetFidRadius / renderer.viewMmPerPixel)
            height: width
            radius: width/2
            color: Theme.transparent
            border.color: Theme.blue

            property var markerPosition: role_expectedPos_screen

            Label {
                visible: text
                anchors { bottom: parent.top; bottomMargin: -8; left: parent.right; }
                state: "body1"
                color: Theme.blue
                text: (role_error).toFixed(3)
            }

            MouseArea {
                anchors.fill: parent
                onClicked: if(accuracyTest2dOverlayViewModel.removeResultEnabled) accuracyTest2dOverlayViewModel.detCircleClicked(markerPosition.x, markerPosition.y)
            }
        }
    }

    RowLayout {
        anchors { right: parent.right; margins: Theme.margin(2); bottom: parent.bottom }
        spacing: Theme.margin(2)

        Button {
            enabled: accuracyTest2dOverlayViewModel.errorStatisticsAvailable || accuracyTest2dOverlayViewModel.removeResultEnabled
            state: accuracyTest2dOverlayViewModel.removeResultEnabled ? "warning" : "active"
            text: accuracyTest2dOverlayViewModel.removeResultEnabled ? qsTr("Click to remove") : qsTr("Remove Point(s)")

            onClicked: accuracyTest2dOverlayViewModel.switchEnableRemoveResult()
        }

        Button {
            enabled: accuracyTest2dOverlayViewModel.canRunTest && !accuracyTest2dOverlayViewModel.removeResultEnabled
            
            state: "active"
            text: qsTr("Start ACC Test")

            onClicked: accuracyTest2dOverlayViewModel.runAccuracyTest()
        }

        Button {
            enabled: accuracyTest2dOverlayViewModel.errorStatisticsAvailable
            state: "active"
            text: qsTr("Save Results")

            onClicked: accuracyTest2dOverlayViewModel.saveAccuracyTestResults()
        }
    }
}
