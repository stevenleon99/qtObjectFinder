import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Layouts 1.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import AccTestPageState 1.0

import GmQml 1.0

import ".."
import "../.."

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    AccTestSetupViewModel {
        id: accTestSetupViewModel
    }

    states: [
        State {
            when: accTestSetupViewModel.isTaskRunning
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: busyIndicator; visible: true }
            PropertyChanges { target: detectText; text: qsTr("Analyzing for fiducials...") }
        },
        State {
            when: accTestSetupViewModel.pageState == AccTestPageState.PatternDetected
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: checkmark; source: "qrc:/icons/check.svg"; color: Theme.green; visible: true }
            PropertyChanges { target: detectText; text: qsTr("Fiducials found.") }
            PropertyChanges { target: resetButton; visible: true }
            PropertyChanges { target: normalRow; visible: true }
        },
        State {
            when: accTestSetupViewModel.pageState == AccTestPageState.NoPatternDetected
            PropertyChanges { target: detectRow; visible: true }
            PropertyChanges { target: checkmark; source: "qrc:/icons/x.svg"; color: Theme.red; visible: true }
            PropertyChanges { target: detectText; text: qsTr("Not Enought fiducials found.") }
            PropertyChanges { target: resetButton; visible: true }
        },
        State {
            when: accTestSetupViewModel.pageState == AccTestPageState.NormalGenerated
            PropertyChanges { target: trajButton; visible: true }
        }
    ]

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            state: "Test Sidebar"
            title: qsTr("Test Sidebar")
            description: qsTr("Select image with fiducials.")
        }



        OptionsDropdown {
            id: comboBox
            Layout.fillWidth: true
            Layout.preferredHeight: 64
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            textRole: "role_label"
            currentIndex: -1

            model: accTestSetupViewModel.ctVolumeListModel

            onActivated: {
                var index = accTestSetupViewModel.ctVolumeListModel.index(index, 0)
                accTestSetupViewModel.selectVolume(model.data(index,256))
            }
        }


        RowLayout {
            id: detectRow
            visible: false
            Layout.preferredHeight: Theme.marginSize * 4
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            spacing: Theme.marginSize

            BusyIndicator {
                id: busyIndicator
                visible: false
                Layout.preferredWidth: Theme.marginSize * 2
                Layout.preferredHeight: Theme.marginSize * 2
            }

            IconImage {
                id: checkmark
                visible: false
                source: "qrc:/icons/check.svg"
                sourceSize: Theme.iconSize
                color: Theme.green
            }

            Label {
                id: detectText
                Layout.fillWidth: true
                state: "subtitle1"
            }

            Button {
                visible: false
                id: resetButton
                state: "icon"
                icon.source: "qrc:/icons/reset.svg"

                onClicked: {
                    accTestSetupViewModel.detectFiducials()
                }
            }
        }

        RowLayout {
            id: selectRow
            visible: comboBox.currentIndex > -1
            Layout.preferredHeight: Theme.marginSize * 4
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            spacing: Theme.marginSize
            Button {
                Layout.fillWidth: true
                state: "active"
                text: qsTr("One Plate")

                onClicked: {
                    accTestSetupViewModel.detectAplateFiducials()
                }
            }

            Button {
                Layout.fillWidth: true
                state: "active"
                text: qsTr("All Plates")

                onClicked: {
                    accTestSetupViewModel.detectAllPlatesFiducials()
                }
            }
        }

        RowLayout {
            id: normalRow
            visible: false
            Layout.preferredHeight: Theme.marginSize * 4
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            spacing: Theme.marginSize

            Button {
                Layout.fillWidth: true
                state: "active"
                text: qsTr("Select Superior\n in real world")

                onClicked: {
                    accTestSetupViewModel.selectSuperior()
                    enabled = false
                }
            }

            Button {
                Layout.fillWidth: true
                state: "active"
                text: qsTr("Select Inferior\n in real world")

                onClicked: {
                    accTestSetupViewModel.selectInferior();
                    enabled = false
                }
            }
        }

        Button {
            id: trajButton
            visible: false
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            state: "active"
            text: qsTr("Generate Trajectories")

            onClicked: {
                accTestSetupViewModel.generateTrajectories()
            }
        }



        LayoutSpacer { }

        PageControls {
            Layout.fillHeight: false
            forwardEnabled: accTestSetupViewModel.pageState != AccTestPageState.TrajectoriesDone

            onBackClicked: applicationViewModel.switchToPage(AppPage.Merge)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.Trajectory)
        }
    }

    DividerLine { }
}
