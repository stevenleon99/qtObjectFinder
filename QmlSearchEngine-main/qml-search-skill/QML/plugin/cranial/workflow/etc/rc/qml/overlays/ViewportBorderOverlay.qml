import QtQuick 2.12
import ViewModels 1.0
import NavigateState 1.0
import Theme 1.0


Item {
    // Unused, but all overlays require this property.
    property var renderer

    ViewportBorderOverlayViewModel {
        id: viewportBorderOverlayVM
    }

    Rectangle {
        width: parent.width + Theme.marginSize / 2
        height: parent.height + Theme.marginSize / 2
        anchors { centerIn: parent }
        color: Theme.transparent
        border {
            width: Theme.marginSize / 4;
            color: {
                if (viewportBorderOverlayVM.navigateState == NavigateState.AtTarget &&
                    viewportBorderOverlayVM.stable)
                {
                    return Theme.green;
                }
                else if (viewportBorderOverlayVM.navigateState == NavigateState.AtTarget ||
                         viewportBorderOverlayVM.navigateState == NavigateState.OnTrajectory)
                {
                    return Theme.yellow;
                }

                return Theme.transparent;
            }
        }
    }
}
