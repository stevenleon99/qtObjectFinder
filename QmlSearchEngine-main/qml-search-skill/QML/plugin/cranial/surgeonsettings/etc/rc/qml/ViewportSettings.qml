import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

import "qrc:/common/drive/settings"

ColumnLayout {
    spacing: Theme.marginSize

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("Viewports")
    }

    SliderSettingsItem {
        title: qsTr("3D Sphere Opacity")
        description: qsTr("Change the opacity of the 3D sphere in the 3D views.")
        from: 0
        to: 100
        value: surgeonSettingsViewModel.crosshairs3dOpacity

        onSliderMoved: {
            surgeonSettingsViewModel.updateCrosshairs3dOpacity(position)
            value = Qt.binding(function() { return surgeonSettingsViewModel.crosshairs3dOpacity })
        }
    }

    CheckableSettingsItem {
        title: qsTr("Interpolation Mode")
        description: qsTr("Render using interpolation")
        checkState: surgeonSettingsViewModel.isInterpolationMode ? Qt.Checked : Qt.Unchecked

        onCheckBoxClicked: surgeonSettingsViewModel.toggleInterpolationMode()
    }
}
