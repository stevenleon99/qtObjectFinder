import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import ".."

SectionHeader {
    id: sectionHeader
    title: qsTr("TRAJECTORIES")

    readonly property bool reachabilityCheckEnabled: navigateHeaderViewModel.reachabilityCheckEnabled

    NavigateHeaderViewModel {
        id: navigateHeaderViewModel
    }

    Button {
        Layout.fillWidth: false
        icon.source: "qrc:/icons/visibility-on.svg"
        state: "icon"
        color: trajectoryVisibilityOptions.visible ? Theme.blue : Theme.white
        onClicked: trajectoryVisibilityOptions.attachAndOpen(this)

        TrajectoryVisibilityOptions {
            id: trajectoryVisibilityOptions
            visible: false
            width: sectionHeader.width
        }
    }

    Button {
        Layout.fillWidth: false
        icon.source: "qrc:/icons/measure-line.svg"
        state: "icon"
        color: parent.reachabilityCheckEnabled ? Theme.blue : Theme.white
        onClicked: navigateHeaderViewModel.toggleReachabilityCheck()
    }
}
