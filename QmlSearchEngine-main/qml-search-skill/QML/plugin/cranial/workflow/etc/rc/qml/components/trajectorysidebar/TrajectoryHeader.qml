import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import ".."
import "presetspopup"
import "../navigatesidebar"

SectionHeader {
    title: qsTr("TRAJECTORIES")

    property bool presetTrajVisible: true
    property bool newTrajVisible: true

    signal addTrajectoryButtonClicked()
    signal newTrajectoryButtonClicked()

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
        visible: presetTrajVisible
        Layout.fillWidth: false
        icon.source: "qrc:/icons/trajectory-add.svg"
        state: "icon"

        onClicked: addTrajectoryButtonClicked()
    }

    Button {
        visible: newTrajVisible
        Layout.fillWidth: false
        icon.source: "qrc:/icons/plus.svg"
        state: "icon"

        onClicked: newTrajectoryButtonClicked()
    }
}
