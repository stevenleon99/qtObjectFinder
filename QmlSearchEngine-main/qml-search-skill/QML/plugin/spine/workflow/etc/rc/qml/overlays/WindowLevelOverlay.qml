import QtQuick 2.12
import ViewModels 1.0
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.impl 2.4

import "../components"

import Theme 1.0

Item {
    id: windowLevelOverlay
    visible: windowLevelOverlayViewModel.display

    property var renderer

    WindowLevelOverlayViewModel {
        id: windowLevelOverlayViewModel
        viewport: renderer
        dragging: windowLevelSlider.dragging
    }

// This will be worked as part of SPINE-1864
//    Switch {
//        id: sliderModeSwitch
//        anchors {
//            horizontalCenter: parent.horizontalCenter
//            top: parent.top
//            margins: Theme.margin(4)
//        }

//        checked: surgeonSettings.windowLevelSliderModeEnabled

//        onReleased: {
//            surgeonSettings.windowLevelSliderModeEnabled = !surgeonSettings.windowLevelSliderModeEnabled
//        }
//    }

    Item {
        id: windowLevelOverlay2D
        anchors { fill: parent; }
        visible: surgeonSettings.windowLevelSliderModeEnabled

        Rectangle {
            id: widthBar
            width: parent.width / 4
            radius: height / 2
            height: 4
            anchors {
                verticalCenter: refreshButton.verticalCenter
                left: refreshButton.right
                leftMargin: Theme.marginSize
            }
            color: Theme.blue

            Rectangle {
                visible: widthSliderMA.pressed
                opacity: 0.5
                width: Theme.marginSize * 3
                height: width
                radius: width / 2
                anchors { centerIn: widthSlider }
                color: Theme.blue
            }

            Rectangle {
                width: 24
                height: width
                radius: width / 2
                anchors { centerIn: widthSlider }
                color: Theme.blue
            }

            Rectangle {
                id: widthSlider
                x: locX
                width: 1
                height: 2
                anchors { verticalCenter: parent.verticalCenter }
                color: Theme.transparent

                property double locX: (windowLevelOverlayViewModel.widthRatio *
                                       (widthBar.width - widthSlider.width))
            }

            MouseArea {
                id: widthSliderMA
                width: 100
                height: 100
                anchors { centerIn: widthSlider }
                drag { target: widthSlider; axis: Drag.XAxis; minimumX: 0; maximumX: widthBar.width }

                onPositionChanged: {
                    windowLevelOverlayViewModel.setWidthRatio(widthSlider.x /
                                                              (widthBar.width - widthSlider.width))
                }

                onReleased: {
                    widthSlider.x = Qt.binding(function() { return widthSlider.locX })

                }
            }
        }

        Rectangle {
            id: levelBar
            width: 4
            height: parent.width / 4
            radius: width / 2
            anchors {
                bottom: refreshButton.top
                bottomMargin: Theme.marginSize
                horizontalCenter: refreshButton.horizontalCenter
            }
            color: Theme.blue

            Rectangle {
                visible: levelSliderMA.pressed
                opacity: 0.5
                width: Theme.marginSize * 3
                height: width
                radius: width / 2
                anchors { centerIn: levelSlider }
                color: Theme.blue
            }

            Rectangle {
                width: 24
                height: width
                radius: width / 2
                anchors { centerIn: levelSlider }
                color: Theme.blue
            }

            Rectangle {
                id: levelSlider
                y: locY
                width: 1
                height: 2
                anchors { horizontalCenter: parent.horizontalCenter }
                color: Theme.transparent

                property double locY: ((1 - windowLevelOverlayViewModel.levelRatio) *
                                       (levelBar.height - levelSlider.height))
            }

            MouseArea {
                id: levelSliderMA
                width: 100
                height: 100
                anchors { centerIn: levelSlider }
                drag { target: levelSlider; axis: Drag.YAxis; minimumY: 0; maximumY: levelBar.height }

                onPositionChanged: {
                    windowLevelOverlayViewModel.setLevelRatio(1 - (levelSlider.y /
                                                                   (levelBar.height - levelSlider.height)))
                }

                onReleased: {
                    levelSlider.y = Qt.binding(function() { return levelSlider.locY })
                }
            }
        }

        Button {
            id: refreshButton
            anchors { bottom: parent.bottom }
            icon.source: "qrc:/icons/refresh.svg"
            icon.color: Theme.blue
            state: "icon"

            onClicked: windowLevelOverlayViewModel.reset()
        }

        IconImage {
            id: levelWidthSlider
            x: locX
            y: locY
            source: "qrc:/icons/puck.svg"
            fillMode: Image.PreserveAspectFit
            antialiasing: true
            color: Theme.blue

            MouseArea {
                id: levelWidthSliderMouseArea
                anchors { fill: levelWidthSlider }
                drag {
                    target: levelWidthSlider
                    axis: Drag.XAndYAxis
                    minimumX: 0
                    maximumX: windowLevelOverlay.width - levelWidthSlider.width
                    minimumY: 0
                    maximumY: windowLevelOverlay.height - levelWidthSlider.height
                }

                onPositionChanged: {
                    var widthVal = levelWidthSlider.x / (windowLevelOverlay.width - levelWidthSlider.width)
                    windowLevelOverlayViewModel.setWidthRatio(widthVal)

                    var levelVal = 1 - (levelWidthSlider.y /
                                        (windowLevelOverlay.height - levelWidthSlider.height))
                    windowLevelOverlayViewModel.setLevelRatio(levelVal)
                }

                onReleased: {
                    levelWidthSlider.x = Qt.binding(function() { return levelWidthSlider.locX })
                    levelWidthSlider.y = Qt.binding(function() { return levelWidthSlider.locY })
                }
            }

            property double locX: (windowLevelOverlayViewModel.widthRatio *
                                   (parent.width - levelWidthSlider.width))
            property double locY: ((1.0 - windowLevelOverlayViewModel.levelRatio) *
                                   (parent.height - levelWidthSlider.height))
        }
    }

    Item {
        id: windowLevelSliderContainer
        anchors { fill: parent; }
        visible: !surgeonSettings.windowLevelSliderModeEnabled

        WindowLevelSlider {
            id: windowLevelSlider
            anchors {
                bottom: parent.bottom
                left: parent.left
                right: parent.right
                margins: 30
                leftMargin: 80
                bottomMargin: Theme.margin(10)
            }
            height: 40

            minValue: windowLevelOverlayViewModel.windowMinMax.x
            maxValue: windowLevelOverlayViewModel.windowMinMax.y

            onMinShift: windowLevelOverlayViewModel.shiftMinWindow(shift)
            onMaxShift: windowLevelOverlayViewModel.shiftMaxWindow(shift)
            onMinMaxShift: windowLevelOverlayViewModel.shiftWindow(shift)
        }

        RowLayout {
            anchors { right: parent.right }

            Button {
                id: resetId
                state: "icon"
                icon.source: "qrc:/icons/reset.svg"

                onClicked: windowLevelOverlayViewModel.reset()
            }

            Item {
                visible: true
                width: resetId.width
                height: resetId.height
            }

            Item {
                visible: viewType === ImageViewport.ThreeD
                width: resetId.width
                height: resetId.height
            }
        }
    }

// This will be worked as part of SPINE-1864
//    WindowLevelHistogram {
//        width: windowLevelOverlay.width / 2
//        height: 80
//        anchors {
//            left: parent.horizontalCenter
//            right: parent.right
//            bottom: parent.bottom
//            leftMargin: Theme.margin(2)
//            rightMargin: Theme.margin(2)
//            bottomMargin: Theme.margin(0.5)
//        }
//        histXMin: windowLevelOverlayViewModel.histXMin
//        histXMax: windowLevelOverlayViewModel.histXMax
//        histYMin: windowLevelOverlayViewModel.histYMin
//        histYMax: windowLevelOverlayViewModel.histYMax
//        histogramPoints: windowLevelOverlayViewModel.histogramSeriesPoints
//        histogramWindowPoints: windowLevelOverlayViewModel.histogramWindowSeriesPoints
//    }
}
