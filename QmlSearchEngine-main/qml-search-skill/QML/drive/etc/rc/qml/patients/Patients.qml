import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0
import DriveImport 1.0

import "../components"

Item {
    id: patientsPage
    RowLayout {
        anchors { fill: parent }
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
                    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                    Layout.fillWidth: true
                    text: qsTr("Patients")
                    font { pixelSize: 27; weight: Font.Medium }
                }

                Button {
                    objectName: "autoImportPatientBtnObj"
                    width: 100
                    height: 48
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    state: "available"
                    text: qsTr("Import")
                    icon.source: "qrc:/icons/import.svg"
                    content.color: Theme.blue
                    onClicked: {
                        importViewModel.patientActive = false;
                        importPopup.open();
                    }

                    ImportPopup {
                        id: importPopup
                        caseImportEnabled: true
                    }

                    Loader {
                        active: importViewModel.patientMatchFound
                        sourceComponent: PatientMatchPopup {}
                    }
                }

                Button {
                    objectName: "autoUINewPatientBtnObj"
                    width: 100
                    height: 48
                    Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                    state: "active"
                    text: qsTr("New Patient")
                    icon.source: "qrc:/icons/plus.svg"
                    content.color: Theme.blue
                    onClicked: newPatientPopup.open();

                    NewPatientPopup {
                        id: newPatientPopup
                        onCreateClicked: patientsModel.addPatient(patientLastName, patientFirstName, dob);
                    }
                }
            }

            PatientList {
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
                sourceComponent: (patientsModel.selectedPatientId != "")
                                             ? patientDetails : noItemSelected
            }
        }

        Component {
            id: noItemSelected

            EmptyItem {}
        }

        Component {
            id: patientDetails

            ColumnLayout {
                Layout.fillWidth: true

                PatientDetails { }
            }
        }
    }

    TutorialLoader {
        active: !userViewModel.activeUser.isServiceUser
                && !userViewModel.tutorialViewed

        onTutorialClosed: userViewModel.setTutorialViewed(true)
    }

    PatientsModel { id: patientsModel }
}
