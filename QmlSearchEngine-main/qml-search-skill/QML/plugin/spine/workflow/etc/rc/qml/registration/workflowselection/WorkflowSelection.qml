import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import PageEnum 1.0

import "../../components"
import "../../trackbar"

Item {
    Layout.fillHeight: true
    Layout.fillWidth: true

    PatRegSelectViewModel {
        id: patRegSelectViewModel
    }

    ColumnLayout {
        anchors { centerIn: parent; verticalCenterOffset: -bottomBar.height }
        spacing: Theme.margin(4)

        Label {
            Layout.fillWidth: true
            state: "h5"
            horizontalAlignment: Qt.AlignHCenter
            text: qsTr("Select registration method.")
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.margin(2)

            WorkflowSelectionButton {
                objectName: "workflowSelectionBtn_"+"ICT Array"
                visible: patRegSelectViewModel.ictWorkflowSelectionVisible
                text: qsTr("ICT Array")
                icon: "qrc:/icons/ict-array-2.svg"
                selected: patRegSelectViewModel.ictWorkflowSelected

                onClicked: patRegSelectViewModel.selectIctWorkflow()

                onInfoPressed: ictRegInfoPopupLoader.active = true
            }

            WorkflowSelectionButton {
                objectName: "workflowSelectionBtn_"+"E3D Auto"
                text: qsTr("E3D Auto")
                icon: "qrc:/icons/E3D-C-side-view-left.svg"
                selected: patRegSelectViewModel.e3dWorkflowSelected

                onClicked: patRegSelectViewModel.selectE3dWorkflow()

                onInfoPressed: e3dRegInfoPopupLoader.active = true
            }
        }
    }

    RowLayout {
        id: bottomBar
        anchors.bottom: parent.bottom
        width: parent.width
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            TrackBar { objectName: "workflowSectionTrackBar" }

            DividerLine {
                orientation: Qt.Horizontal
                anchors { top: parent.top }
            }
        }

        Item {
            Layout.preferredWidth: Theme.margin(45)
            Layout.preferredHeight: Theme.margin(8)

            PageControls {
                anchors { verticalCenter: parent.verticalCenter }
                width: parent.width
            }

            DividerLine {
                orientation: Qt.Horizontal
                anchors { top: parent.top }
            }

            DividerLine { anchors.left: parent.left }
        }
    }

    Loader {
        id: ictRegInfoPopupLoader

        anchors { fill: parent }
        active: false
        sourceComponent: ictRegInfoPopupComponent
    }

    Loader {
        id: e3dRegInfoPopupLoader

        anchors { fill: parent }
        active: false
        sourceComponent: e3dRegInfoPopupComponent
    }

    Component {
        id: ictRegInfoPopupComponent

        WorkflowStepInfoPopup {
            title: qsTr("ICT Fixture Registration Steps")
            stepModel: ListModel { id: ictRegModel }

            onClosed: ictRegInfoPopupLoader.active = false

            ListModel { id: ictRegSteps }

            Component.onCompleted: {
                ictRegSteps.append({role_color: Theme.white.toString(), role_step: "Ensure the bed is at an appropriate height for acquiring a 3D scan."})
                ictRegSteps.append({role_color: Theme.white.toString(), role_step: "Attach the ICT to the patient fixation instrument.​"})
                ictRegSteps.append({role_color: Theme.white.toString(), role_step: "Position the ICT just above the operative levels and ensure it is not touching the patient​.​"})
                ictRegSteps.append({role_color: Theme.white.toString(), role_step: "Position the camera to ensure the DRB and ICT are visible.​"})
                ictRegSteps.append({role_color: Theme.white.toString(), role_step: "Proceed to the next page and capture the surgical snapshot.​​"})
                ictRegSteps.append({role_color: Theme.white.toString(), role_step: "Ensure ICT and DRB are visible after the spin before proceeding to the image loading page."})

                ictRegModel.append({role_subTitle: "", role_steps: ictRegSteps})
            }
        }
    }

    Component {
        id: e3dRegInfoPopupComponent

        WorkflowStepInfoPopup {
            title: qsTr("Excelsius3D Registration Steps")
            stepModel: ListModel { id: e3dRegModel }

            onClosed: e3dRegInfoPopupLoader.active = false

            ListModel { id: e3dAutomaticRegSteps }
            ListModel { id: e3dManualRegSteps }

            Component.onCompleted: {
                e3dAutomaticRegSteps.append({role_color: Theme.white.toString(), role_step: "Ensure the bed is at an appropriate height for acquiring a 3D scan."})
                e3dAutomaticRegSteps.append({role_color: Theme.blue.toString(), role_step: "Avoid positioning drape creases over the tracking markers."})
                e3dAutomaticRegSteps.append({role_color: Theme.white.toString(), role_step: "Ensure 3D navigation is enabled in the E3D Study Setup.​"})
                e3dAutomaticRegSteps.append({role_color: Theme.white.toString(), role_step: "Connect the ethernet cable to EGPS and the right-hand port on E3D.​"})
                e3dAutomaticRegSteps.append({role_color: Theme.white.toString(), role_step: "Position the camera to ensure visibility of the DRB and E3D arrays.​"})
                e3dAutomaticRegSteps.append({role_color: Theme.white.toString(), role_step: "Confirm that the Navigation Status icon on E3D contains a green checkmark."})
                e3dAutomaticRegSteps.append({role_color: Theme.white.toString(), role_step: "Proceed to the next page to enable automatic image transfer. The registered scan will automatically transfer after acquisition."})

                e3dRegModel.append({role_subTitle: qsTr("Automatic"), role_steps: e3dAutomaticRegSteps})

                e3dManualRegSteps.append({role_color: Theme.white.toString(), role_step: "Ensure the bed is at an appropriate height for acquiring a 3D scan."})
                e3dManualRegSteps.append({role_color: Theme.blue.toString(), role_step: "Ensure Manual Snapshot mode is enabled in the E3D settings​.​"})
                e3dManualRegSteps.append({role_color: Theme.white.toString(), role_step: "Ensure 3D navigation is enabled in the E3D Study Setup.​"})
                e3dManualRegSteps.append({role_color: Theme.white.toString(), role_step: "Connect the ethernet cable to EGPS and the right-hand port on E3D.​"})
                e3dManualRegSteps.append({role_color: Theme.white.toString(), role_step: "Position the camera to ensure visibility of the DRB and E3D arrays.​"})
                e3dManualRegSteps.append({role_color: Theme.white.toString(), role_step: "Confirm that the Navigation Status icon on E3D contains a green checkmark.​"})
                e3dManualRegSteps.append({role_color: Theme.blue.toString(), role_step: "Confirm the E3D Gantry is set to a -180° Rainbow position and capture a surgical snapshot.​"})
                e3dManualRegSteps.append({role_color: Theme.white.toString(), role_step: "Proceed to the next page to enable automatic image transfer.​ The registered scan will automatically transfer after acquisition​.​"})

                e3dRegModel.append({role_subTitle: qsTr("Manual Snapshot"), role_steps: e3dManualRegSteps})
            }
        }
    }
}
