import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import ".."

ColumnLayout {
    spacing: Theme.margin(2)

    TrajectoryPositionControlViewModel {
        id: trajectoryPositionControlViewModel
    }

    Loader {
        id: positionCalculatorLoader
        source: trajectoryPositionControlViewModel.isUsingDicomOriginalCoord?"/cranial/qml/components/Calculator.qml":"/cranial/qml/components/CalculatorLPS.qml"

        onLoaded: {
            if (item) {
                item.positionAbove = true
            }
        }
    }

    ColumnLayout {
        spacing: Theme.margin(1)

        CoordinateSystemLabel {
            coordinateSystem: trajectoryPositionControlViewModel.coordinateSystem
        }

        RowLayout {
            spacing: Theme.margin(2)

            ValueStepper {
                enableValue: trajectoryPositionControlViewModel.isTargetSet
                enableArrows: !trajectoryLocked && trajectoryPositionControlViewModel.isTargetSet
                value:{
                    if (trajectoryPositionControlViewModel.isUsingDicomOriginalCoord && !trajectoryPositionControlViewModel.isDisplayingAcpc) {
                        return trajectoryPositionControlViewModel.x
                    }

                    return Math.abs(trajectoryPositionControlViewModel.x)
                }

                valueLabel: {
                    if(trajectoryPositionControlViewModel.isDisplayingAcpc || !trajectoryPositionControlViewModel.isUsingDicomOriginalCoord){
                        return trajectoryPositionControlViewModel.x < 0 ? trajectoryPositionControlViewModel.xNegativeLabel
                                                                        :trajectoryPositionControlViewModel.xPositiveLabel

                    }else{
                        return "R"
                    }

                }

                onIncreaseClicked: trajectoryPositionControlViewModel.increaseX()

                onDecreaseClicked: trajectoryPositionControlViewModel.decreaseX()

                onLabelClicked: {
                    if (positionCalculatorLoader.item && !trajectoryLocked) {
                        if (!trajectoryPositionControlViewModel.isUsingDicomOriginalCoord)
                        {
                            positionCalculatorLoader.item.setup(parent,
                                                                trajectoryPositionControlViewModel.x,
                                                                trajectoryPositionControlViewModel.xNegativeLabel,
                                                                trajectoryPositionControlViewModel.xPositiveLabel,
                                                                trajectoryPositionControlViewModel.coordinateSystem,
                                                                (value) => { trajectoryPositionControlViewModel.setX(value) })
                        }
                        else
                        {
                            positionCalculatorLoader.item.setup(parent,
                                                                trajectoryPositionControlViewModel.x,
                                                                (value) => { trajectoryPositionControlViewModel.setX(value) })
                        }
                    }
                }
            }

            ValueStepper {
                enableValue: trajectoryPositionControlViewModel.isTargetSet
                enableArrows: !trajectoryLocked && trajectoryPositionControlViewModel.isTargetSet
                value: {
                    if (trajectoryPositionControlViewModel.isUsingDicomOriginalCoord && !trajectoryPositionControlViewModel.isDisplayingAcpc) {
                        return trajectoryPositionControlViewModel.y
                    }

                    return Math.abs(trajectoryPositionControlViewModel.y)
                }
                valueLabel: {
                    if(trajectoryPositionControlViewModel.isDisplayingAcpc || !trajectoryPositionControlViewModel.isUsingDicomOriginalCoord){
                        return trajectoryPositionControlViewModel.y < 0 ? trajectoryPositionControlViewModel.yNegativeLabel
                                                                        :trajectoryPositionControlViewModel.yPositiveLabel

                    }else{
                        return "A"
                    }

                }

                onIncreaseClicked: trajectoryPositionControlViewModel.increaseY()

                onDecreaseClicked: trajectoryPositionControlViewModel.decreaseY()

                onLabelClicked: {
                    if (positionCalculatorLoader.item && !trajectoryLocked) {
                        if (!trajectoryPositionControlViewModel.isUsingDicomOriginalCoord)
                        {
                            positionCalculatorLoader.item.setup(parent,
                                                                trajectoryPositionControlViewModel.y,
                                                                trajectoryPositionControlViewModel.yNegativeLabel,
                                                                trajectoryPositionControlViewModel.yPositiveLabel,
                                                                trajectoryPositionControlViewModel.coordinateSystem,
                                                                (value) => { trajectoryPositionControlViewModel.setY(value) })
                        }
                        else
                        {
                            positionCalculatorLoader.item.setup(parent,
                                                                trajectoryPositionControlViewModel.y,
                                                                (value) => { trajectoryPositionControlViewModel.setY(value) })
                        }
                    }
                }
            }

            ValueStepper {
                enableValue: trajectoryPositionControlViewModel.isTargetSet
                enableArrows: !trajectoryLocked && trajectoryPositionControlViewModel.isTargetSet
                value: {
                    if (trajectoryPositionControlViewModel.isUsingDicomOriginalCoord && !trajectoryPositionControlViewModel.isDisplayingAcpc) {
                        return trajectoryPositionControlViewModel.z
                    }

                    return Math.abs(trajectoryPositionControlViewModel.z)
                }
                valueLabel: {
                    if(trajectoryPositionControlViewModel.isDisplayingAcpc || !trajectoryPositionControlViewModel.isUsingDicomOriginalCoord){
                        return trajectoryPositionControlViewModel.z < 0 ? trajectoryPositionControlViewModel.zNegativeLabel
                                                                        :trajectoryPositionControlViewModel.zPositiveLabel

                    }else{
                        return "S"
                    }

                }

                onIncreaseClicked: trajectoryPositionControlViewModel.increaseZ()

                onDecreaseClicked: trajectoryPositionControlViewModel.decreaseZ()

                onLabelClicked: {
                    if (positionCalculatorLoader.item && !trajectoryLocked) {
                        if (!trajectoryPositionControlViewModel.isUsingDicomOriginalCoord)
                        {
                            positionCalculatorLoader.item.setup(parent,
                                                                trajectoryPositionControlViewModel.z,
                                                                trajectoryPositionControlViewModel.zNegativeLabel,
                                                                trajectoryPositionControlViewModel.zPositiveLabel,
                                                                trajectoryPositionControlViewModel.coordinateSystem,
                                                                (value) => { trajectoryPositionControlViewModel.setZ(value) })
                        }
                        else
                        {
                            positionCalculatorLoader.item.setup(parent,
                                                                trajectoryPositionControlViewModel.z,
                                                                (value) => { trajectoryPositionControlViewModel.setZ(value) })
                        }
                    }
                }
            }
        }
    }

    RowLayout {
        spacing: Theme.margin(2)

        TrajectoryAngleStepper {
            state: "Coronal"
            enableValue: trajectoryPositionControlViewModel.isEntrySet
            value: trajectoryPositionControlViewModel.coronalAngleDeg
            valueLabel: trajectoryPositionControlViewModel.coronalAngleDeg < 0 ? "°L" : "°R"
            absolute: true

            enableArrows: !trajectoryLocked && trajectoryPositionControlViewModel.isEntrySet
            onIncreaseClicked: trajectoryPositionControlViewModel.increaseCoronalAngle()

            onDecreaseClicked: trajectoryPositionControlViewModel.decreaseCoronalAngle()

            onLabelClicked: {
                if (!trajectoryLocked)
                {
                    positionCalculator.setup(parent,
                                             trajectoryPositionControlViewModel.coronalAngleDeg,
                                             "°L",
                                             "°R",
                                             trajectoryPositionControlViewModel.coordinateSystem,
                                             (value) => { trajectoryPositionControlViewModel.setCoronalAngle(value) })
                }
            }
        }

        TrajectoryAngleStepper {
            state: "Sagittal"
            enableValue: trajectoryPositionControlViewModel.isEntrySet
            value: trajectoryPositionControlViewModel.sagittalAngleDeg
            valueLabel: "°"

            enableArrows: !trajectoryLocked && trajectoryPositionControlViewModel.isEntrySet
            onIncreaseClicked: trajectoryPositionControlViewModel.increaseSagittalAngle()

            onDecreaseClicked: trajectoryPositionControlViewModel.decreaseSagittalAngle()

            onLabelClicked: {
                if (!trajectoryLocked)
                {
                    positionCalculator.setup(parent,
                                             trajectoryPositionControlViewModel.sagittalAngleDeg,
                                             "°P",
                                             "°A",
                                             trajectoryPositionControlViewModel.coordinateSystem,
                                             (value) => { trajectoryPositionControlViewModel.setSagittalAngle(value) })
                }
            }
        }
    }

    RowLayout {
        visible: setEntryTargetVisible
        spacing: Theme.margin(2)

        DelayButton {
            Layout.fillWidth: true
            text: "Set Target"
            state: "active"
            delay: 1000
            enabled: !trajectoryLocked

            onActivated: trajectoryPositionControlViewModel.setTarget()
        }

        DelayButton {
            Layout.fillWidth: true
            text: "Set Entry"
            state: "active"
            delay: 1000
            enabled: !trajectoryLocked && trajectoryPositionControlViewModel.isTargetSet

            onActivated: trajectoryPositionControlViewModel.setEntry()
        }
    }
}
