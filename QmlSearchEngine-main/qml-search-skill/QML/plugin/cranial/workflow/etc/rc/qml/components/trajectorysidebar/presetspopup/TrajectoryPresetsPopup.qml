import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import "../.."

Popup {
    width: Theme.margin(207)
    height: Theme.margin(121)
    closePolicy: Popup.NoAutoClose

    TrajectoryPresetsViewModel {
        id: presetsVM
        nextTrajectoryColor: Theme.trajectoriesColorList[presetsVM.trajectoryCount %
                                                      Theme.trajectoriesColorList.length]
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        RowLayout {
            Layout.fillHeight: false
            Layout.preferredHeight: Theme.margin(8)

            Label {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.leftMargin: Theme.margin(3)
                state: "h6"
                font.styleName: Theme.regularFont.styleName
                verticalAlignment: Label.AlignVCenter
                text: qsTr("Saved Trajectories")
            }

            Button {
                state: "icon"
                icon.source: "qrc:/icons/x.svg"

                onClicked: close()
            }
        }

        DividerLine { }

        RowLayout {
            spacing: 0
            Layout.leftMargin: Theme.margin(3)

            ColumnLayout {
                spacing: 0
                Layout.preferredWidth: 1

                Label {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Theme.margin(10)
                    state: "subtitle1"
                    font.bold: true
                    verticalAlignment: Label.AlignVCenter
                    text: "Presets"
                }

                DividerLine { }

                TrajectoryPresetsList {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.preferredWidth: 1
                    Layout.leftMargin: Theme.margin(3)
                    model: presetsVM.presetListModel
                }
            }

            DividerLine { }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1

                TrajectoryPresetsDetails {
                    visible: presetsVM.presetSelected
                    anchors { fill: parent; leftMargin: Theme.margin(3); rightMargin: Theme.margin(3) }
                    name: presetsVM.presetSelected ? presetsVM.presetListModel.getRoleData(presetsVM.presetListModel.currentIndex, "role_name") : ""
                    description: presetsVM.presetSelected ? presetsVM.presetListModel.getRoleData(presetsVM.presetListModel.currentIndex, "role_description") : ""
                    targetPosRas: presetsVM.presetSelected ? presetsVM.presetListModel.getRoleData(presetsVM.presetListModel.currentIndex, "role_targetPosRas") : Qt.vector3d(0, 0, 0)
                    coronalAngle: presetsVM.presetSelected ? presetsVM.presetListModel.getRoleData(presetsVM.presetListModel.currentIndex, "role_coronalAngle") : 0
                    sagittalAngle: presetsVM.presetSelected ? presetsVM.presetListModel.getRoleData(presetsVM.presetListModel.currentIndex, "role_sagittalAngle") : 0
                    labelLR: presetsVM.presetSelected ? presetsVM.presetListModel.getRoleData(presetsVM.presetListModel.currentIndex, "role_targetLRlabel") : ""
                    labelPA: presetsVM.presetSelected ? presetsVM.presetListModel.getRoleData(presetsVM.presetListModel.currentIndex, "role_targetPSlabel") : ""
                    labelSI: presetsVM.presetSelected ? presetsVM.presetListModel.getRoleData(presetsVM.presetListModel.currentIndex, "role_targetSIlabel") : ""
                }
            }
        }

        DividerLine { }

        RowLayout {
            Layout.fillHeight: false
            Layout.margins: spacing
            spacing: Theme.margin(2)

            LayoutSpacer { }

            Button {
                state: "available"
                text: "Cancel"

                onClicked: close()
            }

            Button {
                state: "available"
                text: "New Empty Trajectory"

                onClicked: {
                    presetsVM.addEmptyTrajectory();
                    close();
                }
            }

            Button {
                state: "active"
                enabled: presetsVM.presetSelected
                text: "Select"

                onClicked: {
                    presetsVM.loadSelectedPreset();
                    close();
                }
            }
        }
    }
}
