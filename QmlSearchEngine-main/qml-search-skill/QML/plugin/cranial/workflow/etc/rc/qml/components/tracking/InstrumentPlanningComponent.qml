import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

RowLayout {
    property bool isCreatevisible: instrumentPlanningViewModel.isCreateVisible

    InstrumentPlanningViewModel {
        id: instrumentPlanningViewModel
    }

    DelayButton {
        id: delayButton
        Layout.fillWidth: true
        enabled: instrumentPlanningViewModel.isCreateEnabled
        state: "active"
        text: qsTr("Create Trajectory")
        delay: 1000

        onActivated: instrumentPlanningViewModel.createTrajectory(
            Theme.trajectoriesColorList[instrumentPlanningViewModel.trajectoryCount %
                                        Theme.trajectoriesColorList.length]);
    }
}
