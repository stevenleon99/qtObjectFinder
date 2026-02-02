import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import GmQml 1.0

import ".."
import "presetspopup"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    TrajectoryViewModel {
        id: trajectoryViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: Theme.marginSize

        ColumnLayout {
            spacing: 0

            TrajectoryHeader {
                presetTrajVisible: trajectoryViewModel.hasAcpc
                onAddTrajectoryButtonClicked: {
                    trajectoryPresetsPopup.open();
                }
                onNewTrajectoryButtonClicked :{
                    trajectoryViewModel.createTrajectory(Theme.trajectoriesColorList[trajectoryViewModel.trajectoryCount %
                                                                                  Theme.trajectoriesColorList.length]);
                }
            }

            TrajectoryList {
                id: trajectoryList
                visible: trajectoryCount
                Layout.fillHeight: false
            }
        }

        ColumnLayout {
            visible: trajectoryList.trajectorySelected
            spacing: 0

            DividerLine { }

            TrajectoryControls { }

            DividerLine { }

            TrajectorySlider { }

            ImplantLength { }
        }

        LayoutSpacer {

            DescriptiveBackground {
                visible: !trajectoryList.trajectoryCount
                icon: "qrc:/icons/trajectory-empty.svg"
                title: qsTr("No Trajectories")

                RowLayout {
                    Layout.topMargin: Theme.marginSize
                    Layout.alignment: Qt.AlignHCenter
                    spacing: Theme.marginSize

                    Button {
                        icon.source: "qrc:/icons/plus.svg"
                        state: "available"
                        text: qsTr("New")

                        onClicked: trajectoryViewModel.createTrajectory(Theme.trajectoriesColorList[0])
                    }

                    Button {
                        enabled: trajectoryViewModel.hasAcpc
                        icon.source: "qrc:/icons/trajectory-add.svg"
                        state: "available"
                        text: qsTr("Preset")

                        onClicked: trajectoryPresetsPopup.open()

                        TrajectoryPresetsPopup {
                            id: trajectoryPresetsPopup
                        }
                    }
                }
            }
        }

        DividerLine { }

        RenderPosition {
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
        }

        PageControls {
            Layout.fillHeight: false

            onBackClicked: applicationViewModel.testModeEnabled?applicationViewModel.switchToPage(AppPage.AccTestSetup):applicationViewModel.switchToPage(AppPage.AcPc)

            onForwardClicked: applicationViewModel.laptopTypeEnabled?applicationViewModel.switchToPage(AppPage.PostOpCt):applicationViewModel.switchToPage(AppPage.InstrumentVerification)
        }
    }

    DividerLine {
        anchors { left: parent.left }
    }
}
