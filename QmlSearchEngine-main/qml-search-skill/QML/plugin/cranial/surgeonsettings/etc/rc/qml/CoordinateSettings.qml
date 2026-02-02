import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

import "qrc:/common/drive/settings"

ColumnLayout {
    spacing: Theme.margin(4)

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("Preferences")
    }

    SwitchSettingsItem {
        title: qsTr("Trajectory Target Position Coordinates")
        description: qsTr("The trajectory target position will be displayed either in AC-PC (if calculated) or in DICOM coordinates.")

        leftText: "DICOM"
        rightText: "AC-PC"

        isChecked: surgeonSettingsViewModel.isAcpcDisplayTarget 
        onSwitchClicked: surgeonSettingsViewModel.updateIsAcpcDisplayTarget(isChecked)
    }

    SwitchSettingsItem {
        title: qsTr("General Position Coordinates")
        description: qsTr("The general position will be displayed either in AC-PC (if calculated) or in DICOM coordinates.")

        leftText: "DICOM"
        rightText: "AC-PC"

        isChecked: surgeonSettingsViewModel.isAcpcDisplayGeneral 
        onSwitchClicked: surgeonSettingsViewModel.updateIsAcpcDisplayGeneral(isChecked)
    }

    SwitchSettingsItem {
        title: qsTr("DICOM Coordinates")
        description: qsTr("DICOM coordinates origin will either match the Master DICOM or image centered coordinates.")
       
        leftText: "Master"
        rightText: "Image Centered"

        isChecked: !surgeonSettingsViewModel.isOriginalDicomCoord
        onSwitchClicked: surgeonSettingsViewModel.updateIsOriginalDicomCoord(!isChecked)
    }
}
