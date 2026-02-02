import QtQuick 2.12
import ViewModels 1.0

import Theme 1.0


Item {
    visible: ictFiducialOverlayViewModel.isVisible &&
             renderer.viewType !== ImageViewport.ThreeD

    property var renderer

    IctFiducialOverlayViewModel {
        id: ictFiducialOverlayViewModel
        viewport: renderer
    }

    FiducialPositionOverlay {
        id: fiducialPositionOverlay
        positionOverlayX: ictFiducialOverlayViewModel.screenPosition.x
        positionOverlayY: ictFiducialOverlayViewModel.screenPosition.y

        onReleasing: {
            ictFiducialOverlayViewModel.onUpdateFinalPosition()
        }

        onPressedAndHolding: {
            ictFiducialOverlayViewModel.onStartUpdatingPosition(Qt.vector2d(x,y))
        }

        onPositionChanging: {
            ictFiducialOverlayViewModel.onUpdateScreenPosition(Qt.vector2d(x,y));
        }

        onUpArrowClicked: ictFiducialOverlayViewModel.onUpButtonPressed()
        onDownArrowClicked: ictFiducialOverlayViewModel.onDownButtonPressed()
        onLeftArrowClicked: ictFiducialOverlayViewModel.onLeftButtonPressed()
        onRightArrowClicked: ictFiducialOverlayViewModel.onRightButtonPressed()

        onLimitSizeChanged: ictFiducialOverlayViewModel.setLimitSize(limitSize)
    }
}


