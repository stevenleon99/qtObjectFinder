import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import ".."

import Theme 1.0
import ViewModels 1.0

ColumnLayout {
    spacing: Theme.marginSize / 2

    property real _repeatDelay: 500
    property real _repeatInterval: 10

    TrajectorySliderViewModel {
        id: trajectorySliderViewModel
    }

    RowLayout {
        spacing: 0

        Button {
            rotation: 90
            icon.source: "qrc:/icons/double-arrow-down-stemless.svg"
            state: "icon"
            autoRepeat: true
            autoRepeatDelay: _repeatDelay
            autoRepeatInterval: _repeatInterval

            onClicked: trajectorySliderViewModel.stepViewPositionAlongTrajectory(-1)
        }

        Button {
            rotation: 90
            icon.source: "qrc:/icons/arrow-down-stemless.svg"
            state: "icon"
            autoRepeat: true
            autoRepeatDelay: _repeatDelay
            autoRepeatInterval: _repeatInterval

            onClicked: trajectorySliderViewModel.stepViewPositionAlongTrajectory(-0.1)
        }

        Label {
            Layout.fillWidth: true
            verticalAlignment: Label.AlignVCenter
            horizontalAlignment: Label.AlignHCenter
            state: "h6"
            color: !trajectorySliderViewModel.onTrajectory ? Theme.slate300
                                                           : trajectorySliderViewModel.positionAlongTrajectory < 0 ? Theme.red
                                                                                                                   : Theme.white
            text: trajectorySliderViewModel.positionAlongTrajectory
        }

        Button {
            rotation: -90
            icon.source: "qrc:/icons/arrow-down-stemless.svg"
            state: "icon"
            autoRepeat: true
            autoRepeatDelay: _repeatDelay
            autoRepeatInterval: _repeatInterval

            onClicked: trajectorySliderViewModel.stepViewPositionAlongTrajectory(0.1)
        }

        Button {
            rotation: -90
            icon.source: "qrc:/icons/double-arrow-down-stemless.svg"
            state: "icon"
            autoRepeat: true
            autoRepeatDelay: _repeatDelay
            autoRepeatInterval: _repeatInterval

            onClicked: trajectorySliderViewModel.stepViewPositionAlongTrajectory(1)
        }
    }

    ExtendedSlider {
        Layout.fillWidth: true
        Layout.leftMargin: Theme.marginSize
        Layout.rightMargin: Theme.marginSize
        active: trajectorySliderViewModel.onTrajectory
        handleActive: trajectorySliderViewModel.isTargetAndEntrySet
        outerMin: -10
        innerMin: 0
        innerMax: trajectorySliderViewModel.trajectoryLength
        outerMax: trajectorySliderViewModel.trajectoryLength + 10
        value: trajectorySliderViewModel.positionAlongTrajectory

        onValueChangeRequested: trajectorySliderViewModel.setViewPositionAlongTrajectory(newValue)
    }
}
