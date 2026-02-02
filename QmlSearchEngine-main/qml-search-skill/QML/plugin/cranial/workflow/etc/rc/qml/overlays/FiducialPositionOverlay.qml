import QtQuick 2.12
import ViewModels 1.0

import Theme 1.0

Item {
    visible: fiducialOverlayViewModel.isVisible &&
             renderer.viewType !== ImageViewport.ThreeD

    property var renderer

    FiducialOverlayViewModel {
        id: fiducialOverlayViewModel
        viewport: renderer
    }

    FiducialPositionOverlayType {
        positionOverlayX: fiducialOverlayViewModel.screenPosition.x
        positionOverlayY: fiducialOverlayViewModel.screenPosition.y

        onReleasing: {
            fiducialOverlayViewModel.onUpdateFinalPosition()
        }

        onPressedAndHolding: {
            fiducialOverlayViewModel.onStartUpdatingPosition(Qt.vector2d(x,y))
        }

        onPositionChanging: {
            fiducialOverlayViewModel.onUpdateScreenPosition(Qt.vector2d(x,y));
        }

        onUpArrowClicked: fiducialOverlayViewModel.onUpButtonPressed()
        onDownArrowClicked: fiducialOverlayViewModel.onDownButtonPressed()
        onLeftArrowClicked: fiducialOverlayViewModel.onLeftButtonPressed()
        onRightArrowClicked: fiducialOverlayViewModel.onRightButtonPressed()

        onLimitSizeChanged: fiducialOverlayViewModel.setLimitSize(limitSize)
    }
}


