import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

ColumnLayout {
    spacing: 0

    Label {
        Layout.preferredHeight: Theme.margin(10)
        state: "h6"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text: qsTr("Optical Calibration")
    }

    RowLayout{
        spacing: Theme.margin(4)
        SettingsDescription {
            Layout.alignment: Qt.AlignTop
            title: qsTr("Headset")
            description: qsTr("Select the Headset to calibrate")
        }

        ComboBox {
            id: comboBox
            Layout.preferredWidth: Theme.margin(25)
            Layout.preferredHeight: Theme.margin(6)
            model: headsetCalibrationViewModel.headsetTypeStrs
            Component.onCompleted:  currentIndex = model.indexOf(headsetCalibrationViewModel.curHeadsetTypeStr)
            onActivated: headsetCalibrationViewModel.curHeadsetTypeStr = comboBox.currentText
        }

        ComboBox {
            Layout.preferredWidth: Theme.margin(25)
            Layout.preferredHeight: Theme.margin(6)
            model: headsetCalibrationViewModel.calPlateStrs
            Component.onCompleted: {
                 headsetCalibrationViewModel.curCalPlate =  headsetCalibrationViewModel.calPlateStrs[currentIndex]
            }
            onActivated: {
                headsetCalibrationViewModel.curCalPlate =  headsetCalibrationViewModel.calPlateStrs[currentIndex]
            }
        }

        Button {
            Layout.alignment: Qt.AlignVCenter
            state: headsetCalibrationViewModel.showCalPopup ? "disabled" : "active"
            text: qsTr("Calibrate")
            onClicked: {
                headsetCalibrationViewModel.startCalibration();
            }
        }
    }

    Loader {
        active: headsetCalibrationViewModel.showCalPopup
        source: "HeadsetCalibrationPopup.qml"
    }
}
