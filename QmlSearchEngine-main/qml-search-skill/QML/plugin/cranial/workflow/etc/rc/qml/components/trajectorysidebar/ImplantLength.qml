import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import ".."
import "distancepopup"

RowLayout {
    Layout.leftMargin: Theme.margin(2)
    spacing: 0

    RowLayout {
        Layout.alignment: Qt.AlignVCenter
        spacing: Theme.margin(1)

        IconImage {
            source: "qrc:/icons/measure.svg"
            sourceSize: Theme.iconSize
            color: Theme.lineColor
        }

        Label {
            state: "body1"
            color: Theme.headerTextColor
            text: "EE Top to Target"
        }

        Label {
            Layout.fillWidth: true
            state: "h6"
            text: trajectoryViewModel.activeTrajectory.implantLengthMm.toFixed(1)
        }
    }

    Button {
        state: "icon"
        icon.source: "qrc:/icons/pencil.svg"
        color: Theme.headerTextColor

        onClicked: distancePopup.open()

        DistancePopup {
            id: distancePopup
        }
    }
}
