import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import PatRegSelectPageState 1.0

import ".."
import "../.."

Item {
    Layout.fillHeight: true
    Layout.fillWidth: true

    PatRegSelectViewModel {
        id: patRegSelectViewModel
    }

    ColumnLayout {
        anchors { centerIn: parent; horizontalCenterOffset: 180 }

        spacing: Theme.marginSize

        Label {
            Layout.fillWidth: true
            state: "h6"
            horizontalAlignment: Qt.AlignHCenter
            font.styleName: Theme.regularFont.styleName
            font.family: Theme.fontFamily
            font.pixelSize: 32
            text: qsTr("Select registration method.")
        }


        RowLayout {
            id: workFlowSelectionOptions
            Layout.fillWidth: true
            Layout.topMargin: Theme.marginSize
            spacing: Theme.marginSize
            
            WorkflowSelectionButton {
                id: ict
                Layout.fillHeight: true
                text: qsTr("ICT Array")
                imageIcon: "qrc:/icons/ict-array-2.svg"
                isCompleted: patRegSelectViewModel.hasCompletedIct
                isCurrent: patRegSelectViewModel.isCurrentIct
                isSelected: patRegSelectViewModel.selectedWorkflow == PatRegSelectPageState.ICT_Selected

                onClicked: patRegSelectViewModel.selectIctWorkflow()

                onInfoPressed: regIctRegInfoPopup.open()

                WorkflowStepInfoPopup {
                    id: regIctRegInfoPopup

                    title: qsTr("ICT Fixture Registration Steps")
                    stepModel: [
                        "Ensure the bed is at an appropriate height for acquiring a 3D scan.",
                        "Attach the ICT to the patient fixation instrument.​",
                        "Position the ICT just above the operative levels and ensure it is not touching the patient​.",
                        "Position the camera to ensure the DRB and ICT are visible.",
                        "Proceed to the next page and capture the surgical snapshot.​",
                        "Ensure ICT and DRB are visible after the spin before proceeding to the image loading page."
                    ]
                }
            }

            WorkflowSelectionButton {
                id: fluoro
                Layout.fillHeight: true
                text: qsTr("Fluoroscopy")
                imageIcon: "qrc:/icons/image-fluoro.svg"
                showInfoButton: false
                isCompleted: patRegSelectViewModel.hasCompletedFluoroCt
                isCurrent: patRegSelectViewModel.isCurrentFluoroCt
                isSelected: patRegSelectViewModel.selectedWorkflow == PatRegSelectPageState.FluoroCt_Selected

                onClicked: patRegSelectViewModel.selectFluoroCtWorkflow()
            }

            WorkflowSelectionButton {
                id: surface
                Layout.fillHeight: true
                visible: patRegSelectViewModel.isVisibleSurface
                text: qsTr("Surface Map")
                imageIcon: "qrc:/icons/point-cloud.svg"
                showInfoButton: false
                isCompleted: patRegSelectViewModel.hasCompletedSurface
                isCurrent: patRegSelectViewModel.isCurrentSurface
                isSelected: patRegSelectViewModel.selectedWorkflow == PatRegSelectPageState.Surface_Selected

                onClicked: patRegSelectViewModel.selectSurfaceMapWorkflow()

            }

            WorkflowSelectionButton {
                id: e3d
                visible: patRegSelectViewModel.isVisibleE3D
                Layout.fillHeight: true
                text: qsTr("E3D")
                imageIcon: "qrc:/icons/E3D-C-side-view-left.svg"
                isCompleted: patRegSelectViewModel.hasCompletedE3D
                isCurrent: patRegSelectViewModel.isCurrentE3D
                isSelected: patRegSelectViewModel.selectedWorkflow == PatRegSelectPageState.E3D_Selected
                
                onClicked: patRegSelectViewModel.selectE3DWorkflow()

                onInfoPressed: e3dRegInfoPopup.open()

                WorkflowStepInfoPopup {
                    id: e3dRegInfoPopup

                    title: qsTr("Excelsius3D Automatic Registration Steps")
                    stepModel: [
                        "Ensure the bed is at an appropriate height for acquiring a 3D scan.",
                        "Avoid positioning drape creases over the tracking markers.",
                        "Ensure 3D navigation is enabled in the E3D Study Setup.​",
                        "Connect the ethernet cable to EGPS and the right-hand port on E3D.​",
                        "Position the camera to ensure visibility of the DRB and E3D arrays.​",
                        "Confirm that the Navigation Status icon on E3D contains a green checkmark.",
                        "Proceed to the next page to enable automatic image transfer. The registered scan will automatically transfer after acquisition.",
                    ]
                }
            }

            WorkflowSelectionButton {
                id: landmark
                visible: patRegSelectViewModel.isVisibleFiducial
                Layout.fillWidth: true
                text: qsTr("Landmark")
                imageIcon: "qrc:/icons/landmark.svg"
                showInfoButton: false
                isCompleted: patRegSelectViewModel.hasCompletedFiducial
                isCurrent: patRegSelectViewModel.isCurrentFiducial
                isSelected: patRegSelectViewModel.selectedWorkflow == PatRegSelectPageState.Fiducial_Selected

                onClicked: patRegSelectViewModel.selectFiducialWorkflow()
            }
        }
    }

}
