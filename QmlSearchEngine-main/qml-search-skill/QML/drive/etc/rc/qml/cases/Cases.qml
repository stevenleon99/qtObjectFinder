import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0
import DriveEnums 1.0
import DriveImport 1.0

import "../components"

Item {
    id: cases

    Connections {
        target: pluginModel

        onOpenWorkflowPlugin: {
            var pluginInfo = pluginInfoListModel.pluginInfoForWorkflow(workflow)
            if(pluginInfo){
                if (pluginInfo.licensed) {
                    drivePageViewModel.workflowPluginName = pluginInfo.pluginName
                    drivePageViewModel.currentPage = DrivePage.Workflow
                }
                else {
                    licenseManagerViewModel.alertInvalidLicense()
                }
            }
        }
    }

    RowLayout {
        anchors { fill: parent; }
        spacing: 0

        ColumnLayout {
            Layout.preferredWidth: 1408
            Layout.fillHeight: true
            spacing: 0

            RowLayout {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.marginSize
                Layout.rightMargin: Theme.marginSize
                Layout.preferredHeight: Theme.marginSize * 5
                spacing: Theme.marginSize

                Label {
                    objectName: "casesPatientBtn"
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    color: Theme.navyLight
                    text: qsTr("Patients")
                    font { pixelSize: 27; weight: Font.Medium }
                    MouseArea {
                        anchors { fill: parent }
                        onClicked: drivePageViewModel.currentPage = DrivePage.Patients
                    }
                }

                IconImage {
                    sourceSize: Qt.size(24, 24)
                    source: "qrc:/icons/carrot.svg"
                    color: Theme.navyLight
                    rotation: 270

                    MouseArea {
                        anchors { fill: parent }
                        onClicked: drivePageViewModel.currentPage = DrivePage.Patients
                    }
                }

                Label {
                    Layout.fillWidth: true
                    font { pixelSize: 27; weight: Font.Medium }
                    text: casesModel.patientName
                }

                Button {
                    objectName: "autoImportCaseBtnObj"
                    state: "available"
                    icon.source: "qrc:/icons/import.svg"
                    text: qsTr("Import")

                    onClicked: {
                        importViewModel.patientActive = true
                        importPopup.open()
                    }

                    ImportPopup {
                        id: importPopup
                        caseImportEnabled: true
                        patientName: casesModel.patientName
                    }
                }

                Rectangle {
                    id: newCaseRectangle
                    width: newCaseButton.width + radius
                    height: newCaseButton.height + radius
                    radius: Theme.margin(.5)
                    color: newCaseButton.pressed || caseSelectionPopup.visible ? Theme.navy : Theme.transparent

                    Button {
                        id: newCaseButton
                        anchors { centerIn: parent }
                        state: "active"
                        icon.source: "qrc:/icons/plus.svg"
                        text: qsTr("New case")

                        onPressed: {
                            if (!caseSelectionPopup.visible)
                                caseSelectionPopup.setup(newCaseRectangle)
                        }

                        CaseSelectionPopup {
                            id: caseSelectionPopup

                            onSelected: pluginModel.newCase(pluginName)
                        }
                    }
                }
            }

            CaseList {
                id: autoUIDriveMainCasesListId
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: Theme.marginSize
                Layout.rightMargin: Theme.marginSize
            }
        }

        DividerLine {}

        ColumnLayout {
            Layout.preferredWidth: 512
            Layout.alignment: Qt.AlignTop

            Loader {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.leftMargin: Theme.marginSize
                Layout.rightMargin: Theme.marginSize
                sourceComponent: (casesModel.selectedCaseId === "") ?
                                     noItemSelected : (casesModel.selectedCaseType === "Study") ?
                                         studySummaryItem : caseSummaryItem
            }

            Component {
                id: caseSummaryItem
                CaseSummary {}
            }

            Component {
                id: studySummaryItem
                StudySummary {}
            }

            Component {
                id: noItemSelected
                EmptyItem {}
            }
        }
    }

    CasesModel { id: casesModel }
}
