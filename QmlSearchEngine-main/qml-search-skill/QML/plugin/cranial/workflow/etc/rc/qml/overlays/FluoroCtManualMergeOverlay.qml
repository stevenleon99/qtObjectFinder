import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtGraphicalEffects 1.0

import Theme 1.0
import ViewModels 1.0

import "../components"

Item {
    visible: fluoroCtManualMergeOverlayViewModel.isVisible
    anchors { fill: parent }
    
    property var renderer

    FluoroCtManualMergeOverlayViewModel {
        id: fluoroCtManualMergeOverlayViewModel
        viewport: renderer
    }

    GridLayout {
        anchors { left: parent.left; bottom: parent.bottom; margins: Theme.margin(1) }
        columnSpacing: 0
        rowSpacing: 0
        columns: 3

        FluoroCtManualMergeButton {
            Layout.fillWidth: true
            Layout.columnSpan: parent.columns
            rotation: 90
            icon.source: "qrc:/icons/arrow-increment.svg"

            onClicked: fluoroCtManualMergeOverlayViewModel.shiftUp()
        }

        FluoroCtManualMergeButton {
            icon.source: "qrc:/icons/arrow-increment.svg"

            onClicked: fluoroCtManualMergeOverlayViewModel.shiftLeft()
        }

        Item {
            Layout.preferredWidth: Theme.margin(6)
            height: width

            IconImage {
                anchors { centerIn: parent }
                source: "qrc:/images/face.svg"
                sourceSize: Qt.size(Theme.margin(5), Theme.margin(5))
            }
        }

        FluoroCtManualMergeButton {
            rotation: 180
            icon.source: "qrc:/icons/arrow-increment.svg"

            onClicked: fluoroCtManualMergeOverlayViewModel.shiftRight()
        }

        FluoroCtManualMergeButton {
            icon.source: "qrc:/images/arrow-in-increment.svg"

            onClicked: fluoroCtManualMergeOverlayViewModel.shiftOutOfScreen()
        }

        FluoroCtManualMergeButton {
            rotation: -90
            icon.source: "qrc:/icons/arrow-increment.svg"

            onClicked: fluoroCtManualMergeOverlayViewModel.shiftDown()
        }

        FluoroCtManualMergeButton {
            icon.source: "qrc:/images/arrow-out-increment.svg"

            onClicked: fluoroCtManualMergeOverlayViewModel.shiftInToScreen()
        }
    }

    GridLayout {
        anchors { right: parent.right; bottom: parent.bottom; margins: Theme.margin(1) }
        columnSpacing: 0
        rowSpacing: 0
        columns: 3

        FluoroCtManualMergeButton {
            icon.source: "qrc:/images/rotate-90-increment.svg"

            onClicked: fluoroCtManualMergeOverlayViewModel.rotateCounterClockwise()
        }

        FluoroCtManualMergeButton {
            icon.source: "qrc:/images/rotate-around-increment.svg"

            onClicked: fluoroCtManualMergeOverlayViewModel.rotateRighOutOfScreen()
        }

        FluoroCtManualMergeButton {
            icon.source: "qrc:/images/rotate-90-increment.svg"
            transform: Rotation { origin.x: 24; origin.y: 24; axis { x: 0; y: 1; z: 0 } angle: 180 }

            onClicked: fluoroCtManualMergeOverlayViewModel.rotateClockwise()
        }

        FluoroCtManualMergeButton {
            rotation: -90
            icon.source: "qrc:/images/rotate-around-increment.svg"

            onClicked: fluoroCtManualMergeOverlayViewModel.rotateBottomOutOfScreen()
        }

        Item {
            Layout.preferredWidth: Theme.margin(6)
            height: width

            IconImage {
                anchors { centerIn: parent }
                source: "qrc:/images/face.svg"
                sourceSize: Qt.size(Theme.margin(5), Theme.margin(5))
            }
        }

        FluoroCtManualMergeButton {
            icon.source: "qrc:/images/rotate-around-increment.svg"
            transform: [
                Rotation { origin.x: 24; origin.y: 24; axis { x: 0; y: 0; z: 1 } angle: -90 },
                Rotation { origin.x: 24; origin.y: 24; axis { x: 0; y: 1; z: 0 } angle: 180 }
            ]

            onClicked: fluoroCtManualMergeOverlayViewModel.rotateTopOutOfScreen()
        }

        FluoroCtManualMergeButton {
            id: bottomButton
            Layout.fillWidth: true
            Layout.columnSpan: parent.columns
            icon.source: "qrc:/images/rotate-around-increment.svg"
            transform: Rotation { origin.x: bottomButton.width / 2; origin.y: bottomButton.height / 2; axis { x: 1; y: 0; z: 0 } angle: 180 }

            onClicked: fluoroCtManualMergeOverlayViewModel.rotateLeftOutOfScreen()
        }
    }
}
