import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

import ".."

ColumnLayout {
    spacing: 0

    SectionHeader {
        id: header
        title: "TRAJECTORY"

        ColumnLayout {
            spacing: 0

            Label {
                Layout.alignment: Qt.AlignHCenter
                state: "body1"
                font.bold: true
                text: trajectoryViewModel.activeTrajectory.diameterMm.toFixed(1)

                MouseArea {
                    anchors { fill: parent }

                    onClicked: editDiameterPopup.open()
                }

                TrajectoryLengthPopup {
                    id: editDiameterPopup
                    initialText: trajectoryViewModel.activeTrajectory.diameterMm.toFixed(1)
                    maxTextLength: 5
                    popupTitle: qsTr("Set Trajectory Diameter")
                    textValidator: DoubleValidator {
                        top: 100
                        bottom: 0.01
                        notation: DoubleValidator.StandardNotation
                    }

                    onConfirmClicked: trajectoryViewModel.activeTrajectory.setDiameterMm(parseFloat(confirmedText))

                    onConfirmClickedAll: trajectoryViewModel.setDiameterMmAll(parseFloat(confirmedText))
                }
            }

            Image {
                Layout.alignment: Qt.AlignHCenter
                state: "icon"
                source: "qrc:/icons/measure-underline48x24.svg"
                sourceSize: Qt.size(48, 24)
            }
        }

        Button {
            enabled: trajectoryViewModel.isModifyOverlayEnabled
            state: "icon"
            icon.source: trajectoryViewModel.trajectoryModifyOverlayEnable ? "qrc:/icons/crosshair.svg"
                                                                           : "qrc:/icons/crosshair-off.svg"

            onClicked: trajectoryViewModel.toggleTrajectoryModifyOverlayEnable()
        }
    }

    TrajectorySliderControl { }
}
