import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import ".."

import Theme 1.0
import ViewModels 1.0

ColumnLayout { 
    spacing: Theme.marginSize
    Layout.fillHeight: false

    property bool areDistancesVisible: true

    RenderPositionViewModel {
        id: renderPositionViewModel
    }

    Loader {
        id: positionCalculatorLoader
        source: renderPositionViewModel.isUsingDicomOriginalCoord?"/cranial/qml/components/Calculator.qml":"/cranial/qml/components/CalculatorLPS.qml"

        onLoaded: {
            if (item) {
                item.positionAbove = true
            }
        }
    }

    RenderPositionToTrajectory {
		areDistancesVisible: parent.areDistancesVisible
        enableDistanceToTarget: renderPositionViewModel.isTargetSet
        enableDistanceToTrajectory: renderPositionViewModel.isTargetSet &&
                                    renderPositionViewModel.isEntrySet
        distanceToTarget: renderPositionViewModel.distanceToTarget
        distanceToTrajectory: renderPositionViewModel.distanceToTrajectory
        acPcDistance: renderPositionViewModel.acpcDistance

        onAcPressed: renderPositionViewModel.goToAC()

        onPcPressed: renderPositionViewModel.goToPC()
    }

    ColumnLayout {
        spacing: Theme.margin(1)

        CoordinateSystemLabel {
            coordinateSystem: renderPositionViewModel.coordinateSystem
        }

        RowLayout {
            spacing: Theme.marginSize

            ValueStepper {
                enableArrows: true
                value: {
                    if (renderPositionViewModel.isUsingDicomOriginalCoord && !renderPositionViewModel.isDisplayingAcpc) {
                        return renderPositionViewModel.renderX
                    }
                    
                    return Math.abs(renderPositionViewModel.renderX)
                }

                valueLabel: {
                    if(renderPositionViewModel.isDisplayingAcpc || !renderPositionViewModel.isUsingDicomOriginalCoord){
                        return renderPositionViewModel.renderX < 0 ? renderPositionViewModel.renderXNegativeLabel
                                                                   :renderPositionViewModel.renderXPositiveLabel

                    }else{
                        return "R"
                    }

                }

                onIncreaseClicked: renderPositionViewModel.increaseX()

                onDecreaseClicked: renderPositionViewModel.decreaseX()

                onLabelClicked: {
                    if (positionCalculatorLoader.item) {
                        if (!renderPositionViewModel.isUsingDicomOriginalCoord)
                        {
                            positionCalculatorLoader.item.setup(parent,
                                                                renderPositionViewModel.renderX,
                                                                renderPositionViewModel.renderXNegativeLabel,
                                                                renderPositionViewModel.renderXPositiveLabel,
                                                                renderPositionViewModel.coordinateSystem,
                                                                (value) => { renderPositionViewModel.setX(value) })
                        }
                        else
                        {
                            positionCalculatorLoader.item.setup(parent,
                                                                renderPositionViewModel.renderX,
                                                                (value) => { renderPositionViewModel.setX(value) })
                        }
                    }
                }
            }

            ValueStepper {
                enableArrows: true
                value: {
                    if (renderPositionViewModel.isUsingDicomOriginalCoord && !renderPositionViewModel.isDisplayingAcpc) {
                        return renderPositionViewModel.renderY
                    }
                    
                    return Math.abs(renderPositionViewModel.renderY)
                }
                valueLabel: {
                    if(renderPositionViewModel.isDisplayingAcpc || !renderPositionViewModel.isUsingDicomOriginalCoord){
                        return renderPositionViewModel.renderY < 0 ? renderPositionViewModel.renderYNegativeLabel
                                                                   : renderPositionViewModel.renderYPositiveLabel
                    }else{
                        return "A"
                    }

                }

                onIncreaseClicked: renderPositionViewModel.increaseY()

                onDecreaseClicked: renderPositionViewModel.decreaseY()

                onLabelClicked: {
                    if (positionCalculatorLoader.item) {
                        if (!renderPositionViewModel.isUsingDicomOriginalCoord)
                        {
                            positionCalculatorLoader.item.setup(parent,
                                                                renderPositionViewModel.renderY,
                                                                renderPositionViewModel.renderYNegativeLabel,
                                                                renderPositionViewModel.renderYPositiveLabel,
                                                                renderPositionViewModel.coordinateSystem,
                                                                (value) => { renderPositionViewModel.setY(value) })
                        } else {
                            positionCalculatorLoader.item.setup(parent,
                                                                renderPositionViewModel.renderY,
                                                                (value) => { renderPositionViewModel.setY(value) })
                        }
                    }
                }
            }

            ValueStepper {
                enableArrows: true
                value: {
                    if (renderPositionViewModel.isUsingDicomOriginalCoord && !renderPositionViewModel.isDisplayingAcpc) {
                        return renderPositionViewModel.renderZ
                    }
                    
                    return Math.abs(renderPositionViewModel.renderZ)
                }
                valueLabel: {

                    if (renderPositionViewModel.isDisplayingAcpc || !renderPositionViewModel.isUsingDicomOriginalCoord) {
                        return renderPositionViewModel.renderZ < 0 ? renderPositionViewModel.renderZNegativeLabel
                                                                   : renderPositionViewModel.renderZPositiveLabel
                    }
                    else{
                        return "S"
                    }
                }

                onIncreaseClicked: renderPositionViewModel.increaseZ()

                onDecreaseClicked: renderPositionViewModel.decreaseZ()

                onLabelClicked: {
                    if (positionCalculatorLoader.item) {
                        if (!renderPositionViewModel.isUsingDicomOriginalCoord)
                        {
                            positionCalculatorLoader.item.setup(parent,
                                                                renderPositionViewModel.renderZ,
                                                                renderPositionViewModel.renderZNegativeLabel,
                                                                renderPositionViewModel.renderZPositiveLabel,
                                                                renderPositionViewModel.coordinateSystem,
                                                                (value) => { renderPositionViewModel.setZ(value) })
                        } else {
                            positionCalculatorLoader.item.setup(parent,
                                                                renderPositionViewModel.renderZ,
                                                                (value) => { renderPositionViewModel.setZ(value) })
                        }
                    }
                }
            }
        }
    }
}
