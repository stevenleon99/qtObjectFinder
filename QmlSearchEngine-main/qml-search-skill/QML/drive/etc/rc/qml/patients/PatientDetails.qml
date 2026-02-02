import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import "../components"

ColumnLayout {
    id: patientDetailsContainer
    objectName: "patientDetails"
    Layout.alignment: Qt.AlignTop
    spacing: 0

    PatientDetailsModel {
        id: patientDetailsModel

        onPatientIdChanged: {
            if (loader.sourceComponent === patientEditor) {
                loader.sourceComponent = patientView
            }
        }
    }

    Component {
        id: patientView

        PatientView {
            patientDetails: patientDetailsModel
        }
    }

    Component {
        id: patientEditor

        PatientEditor {
            patientDetails: patientDetailsModel

            onSaveClicked: loader.sourceComponent = patientView
        }
    }

    RowLayout {
        Layout.preferredHeight: Theme.margin(10)
        spacing: Theme.margin(2)

        RowLayout {
            spacing: 0

            IconImage {
                color: Theme.blue
                fillMode: Image.PreserveAspectFit
                sourceSize: Theme.iconSize
                source: "qrc:/icons/folder-man.svg"
            }

            Label {
                objectName: "patientDetailsPatientFolderBtn"
                Layout.fillWidth: true
                Layout.leftMargin: Theme.margin(2)
                state: "h6"
                font.bold: true
                maximumLineCount: 1
                text: patientDetailsModel.patientName

                Rectangle {
                    width: parent.contentWidth
                    height: 1
                    anchors { bottom: parent.bottom; bottomMargin: -Theme.margin(1) }
                    color: Theme.navy
                }

                MouseArea {
                    width: parent.contentWidth
                    height: parent.height

                    onClicked: {
                        renamePopup.firstName = patientDetailsModel.patientFirstName;
                        renamePopup.lastName = patientDetailsModel.patientLastName;
                        renamePopup.open();
                    }

                    RenamePatientPopup {
                        id: renamePopup

                        onSaveClicked: patientDetailsModel.setPatientFullName(firstName, lastName)
                    }
                }
            }
        }

        Button {
            objectName: "patientDetailsModifyBtn"
            state: "icon"
            icon.source: "qrc:/icons/pencil.svg"
            highlighted: loader.sourceComponent === patientEditor

            onClicked: loader.sourceComponent = patientEditor
        }

        Button {
            objectName: "patientDetailsTrashBtn"
            enabled: loader.sourceComponent !== patientEditor
            state: "icon"
            icon.source: "qrc:/icons/trash.svg"
            highlighted: deletePopup.visible

            onClicked: deletePopup.open()

            DeleteItemPopup {
                id: deletePopup
                itemName: patientDetailsModel.patientName

                onDeleteClicked:
                {
                    pluginModel.deleteAllCases();
                    patientDetailsModel.deletePatient()
                }
            }
        }
    }

    Loader {
        id: loader
        Layout.fillWidth: true
        Layout.fillHeight: true
        sourceComponent: patientView
    }
}

