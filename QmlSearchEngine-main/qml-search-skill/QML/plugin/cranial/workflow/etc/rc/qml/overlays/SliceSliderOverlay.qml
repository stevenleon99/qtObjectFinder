import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import ViewModels 1.0
import Theme 1.0

Item {
    id: line
    visible: sliceSliderOverlayViewModel.isVisible

    property var renderer

    SliceSliderOverlayViewModel {
        id: sliceSliderOverlayViewModel
        viewport: renderer
    }

    Rectangle {
        id: bar
        visible: true
        width: 4
        radius: width / 2
        height: parent.height * (2 / 3)
        anchors { right: parent.right; verticalCenter: parent.verticalCenter; margins: Theme.marginSize * 2.5 }


        Rectangle {
            visible: sliderMA.pressed
            opacity: 0.5
            width: Theme.marginSize * 3
            height: width
            radius: width / 2
            anchors { centerIn: slider }
            color: Theme.blue
        }

        Rectangle {
            id: sliderIcon
            width: 36
            height: width
            radius: width / 2
            anchors { centerIn: slider }

            IconImage {
                anchors { fill: parent; margins: Theme.marginSize / 4 }
                source: "qrc:/images/image-thru.svg"
                color: Theme.black
            }
        }

        Rectangle {
            id: slider
            width: 1
            height: 2
            y: sliceSliderOverlayViewModel.sliderPosition*bar.height
            anchors { horizontalCenter: parent.horizontalCenter }
            color: Theme.transparent
        }

        Rectangle {
            width: 36
            height: width
            radius: width / 2
            anchors { horizontalCenter: slider.horizontalCenter; bottom: sliderIcon.top; bottomMargin: Theme.marginSize / 2}
            color: Theme.slate900
            opacity: 0.9

            Button {
                anchors { centerIn: parent }
                rotation: 180
                icon.source: "qrc:/icons/arrow-down-stemless.svg"
                state: "icon"
                autoRepeat: true

                onClicked: sliceSliderOverlayViewModel.setSliderPosition((slider.y-0.5)/bar.height)
            }
        }

        Rectangle {
            width: 36
            height: width
            radius: width / 2
            anchors { horizontalCenter: slider.horizontalCenter; top: sliderIcon.bottom; topMargin: Theme.marginSize / 2}
            color: Theme.slate900
            opacity: 0.9

            Button {
                anchors { centerIn: parent }
                rotation: 0
                icon.source: "qrc:/icons/arrow-down-stemless.svg"
                state: "icon"
                autoRepeat: true

                onClicked: sliceSliderOverlayViewModel.setSliderPosition((slider.y+0.5)/bar.height)
            }
        }

        MouseArea {
            id: sliderMA
            width: 50
            height: 50
            anchors { centerIn: slider }
            drag { target: slider; axis: Drag.YAxis; minimumY: 0; maximumY:  bar.height }

            onPositionChanged: {
                sliceSliderOverlayViewModel.setSliderPosition(slider.y/bar.height);
            }
        }

    }
}


