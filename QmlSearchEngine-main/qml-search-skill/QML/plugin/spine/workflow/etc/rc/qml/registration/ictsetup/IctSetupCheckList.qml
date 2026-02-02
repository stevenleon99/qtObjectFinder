import QtQuick 2.12
import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import Enums 1.0

ColumnLayout {

    IctGetSnapshotViewModel {
        id: ictGetSnapshotViewModel
    }

    Layout.fillWidth: false
    spacing: Theme.margin(4)

    IctSetupCheckDelegate {
        checked: ictGetSnapshotViewModel.isPatRefVisible == ToolVisibilityStatus.Visible
        text: qsTr("DRB and Registration Fixture within camera view")
        index: 1
    }

    IctSetupCheckDelegate {
        checked: ictGetSnapshotViewModel.isIctSnapshotComplete
        text: qsTr("Capture surgical site snapshot and keep steady")
        index: 2
    }

    IctSetupCheckDelegate {
        state: "info"
        text: qsTr("Place the DRB and surveillance marker. Activate the surveillance marker.​")
        iconSource: "qrc:/icons/case-info.svg"
        color: Theme.blue
    }

    IctSetupCheckDelegate {
        state: "info"
        text: qsTr("<b>Post-Capture</b>") + qsTr(": Carefully remove the drape to avoid disruption to the DRB and surveillance marker.​​")
        iconSource: "qrc:/icons/alert-caution.svg"
        color: Theme.yellow
    }

    RowLayout {
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: Theme.marginSize
        spacing: Theme.marginSize

        Button {
            id: captureButtonId
            enabled: (ictGetSnapshotViewModel.isIctVisible == ToolVisibilityStatus.Visible) &&
                     (ictGetSnapshotViewModel.isPatRefVisible == ToolVisibilityStatus.Visible) &&
                     !ictGetSnapshotViewModel.isIctSnapshotComplete

            state: "active"
            rightPadding: iconStable.visible ? Theme.margin(7) : leftPadding
            text: qsTr("Capture Surgical Snapshot")

            onClicked: ictGetSnapshotViewModel.captureSnapshot()

            IconImage {
                id: iconStable
                visible: captureButtonId.enabled
                         && !ictGetSnapshotViewModel.snapshotStable
                anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: Theme.marginSize }
                sourceSize: Theme.iconSize
                source: "qrc:/images/motion2.svg"
                color: Theme.yellow
                rotation: -90
            }
        }

        Button {
            visible: ictGetSnapshotViewModel.isIctSnapshotComplete
            state: "available"
            text: qsTr("Clear")

            onClicked: ictGetSnapshotViewModel.clearSnapshot()
        }
    }
}
