import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import ".."
import "../trajectorysidebar"
import "../trajectorysidebar/distancepopup"

ColumnLayout {
    spacing: 0

    DividerLine { }

    SectionHeader {
        title: trajectoryViewModel.activeTrajectory.name
        textState: "h6"
        textColor: Theme.white
    }

    ColumnLayout {
        Layout.leftMargin: Theme.marginSize
        Layout.rightMargin: Theme.marginSize
        spacing: Theme.marginSize

        TrajectorySliderControl { }

        TrajectoryAngles { }
    }
}
