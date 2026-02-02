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
    spacing: Theme.margin(3)

    SetupCheckDelegate {
        isInfo: true
        state: "info"
        text: qsTr("<b>Pre-Capture</b>") + qsTr(": Place the patient reference and surveillance marker. Activate the surveillance marker.​​")
    }

    SetupCheckDelegate {
        checked: ictGetSnapshotViewModel.isPatRefVisible == ToolVisibilityStatus.Visible
        text: qsTr("Patient Reference Visible")
    }

    SetupCheckDelegate {
        checked: ictGetSnapshotViewModel.isIctVisible == ToolVisibilityStatus.Visible
        text: qsTr("ICT Visible")
    }

    SetupCheckDelegate {
        checked: ictGetSnapshotViewModel.isIctSnapshotComplete
        text: qsTr("Capture surgical site snapshot and keep steady")
    }

    Button {
        id: captureButtonId
        enabled: (ictGetSnapshotViewModel.isIctVisible == ToolVisibilityStatus.Visible) &&
                 (ictGetSnapshotViewModel.isPatRefVisible == ToolVisibilityStatus.Visible)
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: Theme.marginSize
        state: "active"
        text: iconStable.visible?qsTr("Capture Surgical Snapshot       ")
                                :qsTr("Capture Surgical Snapshot")


        onClicked: ictGetSnapshotViewModel.captureSnapshot()

        IconImage {
            id: iconStable
            visible: captureButtonId.enabled && !ictGetSnapshotViewModel.snapshotStable
            anchors { verticalCenter: parent.verticalCenter; right: parent.right; rightMargin: Theme.marginSize }
            sourceSize: Theme.iconSize
            source: "qrc:/images/motion2.svg"
            color: Theme.yellow
            rotation: -90
        }
    }
}
