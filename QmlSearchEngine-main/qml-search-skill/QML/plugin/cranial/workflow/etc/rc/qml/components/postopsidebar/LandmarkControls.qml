import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0

import ".."


ColumnLayout {
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.leftMargin: Theme.margin(2)
    spacing: 0

    RowLayout {
        spacing: 0

        Label {
            state: "body2"
            font { bold: true }
            color: Theme.headerTextColor
            text: qsTr("REFERENCE")
        }

        Item {
            Layout.fillWidth: true
        }

        Button {
            state: "icon"
            enabled: trajectoryViewModel.landmarkCount > 0
            icon.source: trajectoryViewModel.areLandmarksVisible ? "qrc:/icons/visibility-on.svg"
                                                                      : "qrc:/icons/visibility-off.svg"

            onClicked: trajectoryViewModel.toggleLandmarksVisibility()
        }

        Button {
            id: trashButton
            icon.source: "qrc:/icons/trash.svg"
            state: "icon"
            enabled: trajectoryViewModel.isActiveLandmark

            onClicked: trajectoryViewModel.deleteActiveLandmark()
        }

        Button {
            state: "icon"
            icon.source: "qrc:/icons/plus.svg"
            onClicked: trajectoryViewModel.addLandmark()
            enabled: trajectoryViewModel.areViewportsLinked
        }
    }

    ListView {
        id: leadList
        Layout.fillWidth: true
        Layout.fillHeight: true
        model: trajectoryViewModel.trajectoryLandmarks
        clip: true
        spacing: Theme.margin(2)

        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            visible: leadList.count
            policy: ScrollBar.AsNeeded
        }

        delegate: LandmarkDelegate {
            width: leadList.width - scrollBar.width
            distanceFromTarget: role_distanceFromTarget
            distanceFromTrajectory: role_distanceFromTrajectory
            isSetEnabled: trajectoryViewModel.areViewportsLinked
            isSelected: trajectoryViewModel.activeLandmark == role_uid
            onSetButtonClicked: trajectoryViewModel.setLandmarkPosition(role_uid)
            onLandmarkClicked: trajectoryViewModel.goToLandmark(role_uid)
        }
    }
}
