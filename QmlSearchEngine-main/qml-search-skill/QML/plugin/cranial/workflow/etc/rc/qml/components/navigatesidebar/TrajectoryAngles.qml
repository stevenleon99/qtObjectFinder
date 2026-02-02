import QtQuick 2.12
import QtQuick.Layouts 1.12

import Theme 1.0
import ViewModels 1.0

import ".."
import "../trajectorysidebar"


ColumnLayout {
    Layout.fillWidth: true
    Layout.leftMargin: Theme.marginSize
    Layout.rightMargin: Theme.marginSize
    spacing: Theme.marginSize / 2

    TrajectoryPositionControlViewModel {
        id: trajPosControlVM
    }

    CoordinateSystemLabel {
        coordinateSystem: trajPosControlVM.coordinateSystem
    }

    RowLayout {
        spacing: Theme.marginSize

        TrajectoryAngleStepper {
            enabled: false
            state: "Coronal"
            value: trajPosControlVM.coronalAngleDeg
            valueLabel: trajPosControlVM.coronalAngleDeg < 0 ? "°L" : "°R"
            absolute: true
        }

        TrajectoryAngleStepper {
            enabled: false
            state: "Sagittal"
            value: trajPosControlVM.sagittalAngleDeg
            valueLabel: "°"
        }
    }
}
