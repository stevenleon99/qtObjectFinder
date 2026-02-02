import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

ColumnLayout {
    spacing: Theme.marginSize

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("Viewports")
    }

    ViewportLayoutSettings {}

    SliderSettingsItem {
        title: qsTr("Crosshair Opacity")
        description: qsTr("Change the opacity of the crosshair in the views.")
        from: surgeonSettingsViewModel.minimumOpacity
        to: surgeonSettingsViewModel.maximumOpacity
        value: surgeonSettingsViewModel.crosshairsOpacity

        onSliderMoved: {
            surgeonSettingsViewModel.updateCrosshairsOpacity(position)
            value = Qt.binding(function() { return surgeonSettingsViewModel.crosshairsOpacity })
        }
    }

    SliderSettingsItem {
        title: qsTr("Implant Opacity")
        description: qsTr("Change the opacity of the implants in the views.")
        from: surgeonSettingsViewModel.minimumCadOpacity
        to: surgeonSettingsViewModel.maximumOpacity
        value: surgeonSettingsViewModel.implantCadOpacity

        onSliderMoved:  {
            surgeonSettingsViewModel.updateimplantCadOpacity(position)
            value = Qt.binding(function() { return surgeonSettingsViewModel.implantCadOpacity })
        }
    }

    SliderSettingsItem {
        title: qsTr("Instrument Opacity")
        description: qsTr("Change the opacity of the instruments in the views.")
        from: surgeonSettingsViewModel.minimumCadOpacity
        to: surgeonSettingsViewModel.maximumOpacity
        value: surgeonSettingsViewModel.instrumentCadOpacity

        onSliderMoved: {
            surgeonSettingsViewModel.updateinstrumentCadOpacity(position)
            value = Qt.binding(function() { return surgeonSettingsViewModel.instrumentCadOpacity })
        }
    }

    CheckableSettingsItem {
        title: qsTr("Trajectory Line")
        description: qsTr("Show the trajectory line off the tip of the active tool.")
        checkState: surgeonSettingsViewModel.displayTrajectoryLine ? Qt.Checked : Qt.Unchecked

        onCheckBoxClicked: surgeonSettingsViewModel.toggleDisplayTrajectoryLine()
    }
}
