import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import PatientRegistrationCategory 1.0
import ViewModels 1.0

import Theme 1.0
import GmQml 1.0

Item {
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.margin(24)
    
    CaseSetupCategorySelectViewModel {
        id: caseSetupWorkflowSelectionViewModel
    }

    ColumnLayout {
        anchors { fill: parent; leftMargin: Theme.marginSize; rightMargin: Theme.marginSize }
        spacing: 0

        Label {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(7)
            state: "subtitle2"
            font { bold: true; letterSpacing: 1; capitalization: Font.AllUppercase }
            verticalAlignment : Text.AlignVCenter
            color: Theme.headerTextColor
            text: qsTr("Registration")
        }
        
        RowLayout {
            Layout.alignment: Qt.AlignTop
            Layout.fillHeight: true
            spacing: Theme.marginSize
            
            WorkflowCategorySelectionButton {
                objectName: "reg2DButton"  
                text: qsTr("2D")
                icon: "qrc:/icons/image-fluoro.svg"
                enabled: caseSetupWorkflowSelectionViewModel.isRegSelectionAllowed &&  caseSetupWorkflowSelectionViewModel.isReg2dLicenseEnabled
                selected: caseSetupWorkflowSelectionViewModel.selectedRegistrationCategory == PatientRegistrationCategory.Reg2D

                onClicked: caseSetupWorkflowSelectionViewModel.selectedRegistrationCategory = PatientRegistrationCategory.Reg2D
            }
            
            WorkflowCategorySelectionButton {
                objectName: "preOpButton"  
                text: qsTr("Pre-Op")
                icon: "qrc:/icons/image-3d-past2"
                enabled: caseSetupWorkflowSelectionViewModel.isRegSelectionAllowed
                selected: caseSetupWorkflowSelectionViewModel.selectedRegistrationCategory == PatientRegistrationCategory.Reg2D3D

                onClicked: caseSetupWorkflowSelectionViewModel.selectedRegistrationCategory = PatientRegistrationCategory.Reg2D3D
            }
            
            WorkflowCategorySelectionButton {
                objectName: "intraOpButton"  
                text: qsTr("Intra-Op")
                icon: "qrc:/icons/image-3d"
                enabled: caseSetupWorkflowSelectionViewModel.isRegSelectionAllowed
                selected: caseSetupWorkflowSelectionViewModel.selectedRegistrationCategory == PatientRegistrationCategory.Reg3D

                onClicked: caseSetupWorkflowSelectionViewModel.selectedRegistrationCategory = PatientRegistrationCategory.Reg3D
            }
        }
    }

    DividerLine {
        anchors { bottom: parent.bottom }
        orientation: Qt.Horizontal
    }
}
