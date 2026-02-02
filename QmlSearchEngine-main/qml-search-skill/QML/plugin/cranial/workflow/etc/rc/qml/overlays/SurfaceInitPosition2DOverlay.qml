import QtQuick 2.12
import ViewModels 1.0

import Theme 1.0

Item {
    visible: surfaceInitOverlayViewModel.isVisible &&
             renderer.viewType !== ImageViewport.ThreeD

    property var renderer

    SurfaceInitOverlay2DViewModel {
        id: surfaceInitOverlayViewModel
        viewport: renderer
    }

    FiducialPositionOverlayType {
        positionOverlayX: surfaceInitOverlayViewModel.screenPosition.x
        positionOverlayY: surfaceInitOverlayViewModel.screenPosition.y

        onReleasing: {
            surfaceInitOverlayViewModel.onUpdateFinalPosition()
        }

        onPressedAndHolding: {
            surfaceInitOverlayViewModel.onStartUpdatingPosition(Qt.vector2d(x,y))
        }

        onPositionChanging: {
            surfaceInitOverlayViewModel.onUpdateScreenPosition(Qt.vector2d(x,y));
        }

        onUpArrowClicked: surfaceInitOverlayViewModel.onUpButtonPressed()
        onDownArrowClicked: surfaceInitOverlayViewModel.onDownButtonPressed()
        onLeftArrowClicked: surfaceInitOverlayViewModel.onLeftButtonPressed()
        onRightArrowClicked: surfaceInitOverlayViewModel.onRightButtonPressed()

        onLimitSizeChanged: surfaceInitOverlayViewModel.setLimitSize(limitSize)
    }
}


