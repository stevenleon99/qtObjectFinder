import QtQuick 2.12

import ViewModels 1.0
import Theme 1.0
import Enums 1.0



Item {
    ViewportBorderViewModel {
        id: viewportBorderVM
    }

    Rectangle {
        width: parent.width + Theme.marginSize * 3/4
        height: parent.height + Theme.marginSize * 3/4
        anchors { centerIn: parent }
        radius: Theme.marginSize / 2
        color: Theme.transparent
        border {
            width: Theme.marginSize / 3;
            color: {
                if (viewportBorderVM.trajectoryStatus == TrajectoryDeviationStatus.AtTrajectory && viewportBorderVM.visible)
                {
                    return Theme.green;
                }
                else if (viewportBorderVM.trajectoryStatus == TrajectoryDeviationStatus.OnTrajectory && viewportBorderVM.visible)
                {
                    return Theme.yellow;
                }

                return Theme.transparent;
            }
        }
    }
}
