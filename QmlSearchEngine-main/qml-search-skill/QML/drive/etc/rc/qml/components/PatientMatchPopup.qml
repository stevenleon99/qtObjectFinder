import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

Popup {
    id: patientMatchPopup

    visible: true
    width: parent.width - Theme.margin(105)
    height: parent.height - Theme.margin(63)
    closePolicy: Popup.NoAutoClose

    modal: true
    Overlay.modal: Rectangle { color: Qt.rgba(0, 0, 0, 0.75) }

    signal createClicked(string patientName)

    contentItem: Rectangle {
        width: patientMatchPopup.width
        height: patientMatchPopup.height
        color: Theme.backgroundColor
        radius: Theme.margin(1)
        ColumnLayout {
            anchors {
                fill: parent
                margins: Theme.margin(3)
            }
            spacing: Theme.marginSize

            Label {
                Layout.fillWidth: true
                text: qsTr("Patient Import has Potential Match")
                state: "h4"
            }

            Label {
                Layout.fillWidth: true
                text: qsTr("The patient information for \"") + importViewModel.patientName +
                      qsTr("\" is similar to other patient records. Merge with an existing patient or create a new patient?")
                state: "h6"
                maximumLineCount: 2
                wrapMode: TextInput.WordWrap
            }

            ListView {
                id: patientList
                Layout.fillWidth: true
                Layout.preferredHeight: 254
                headerPositioning: ListView.OverlayHeader
                clip: true

                model: SortFilterProxyModel { sourceModel: importViewModel.patientMatchList }

                ListModel {
                    id: patientHeader
                    ListElement { role_role: "role_name"; role_text: "NAME"; role_weight: 388 }
                    ListElement { role_role: "role_medicalId"; role_text: "Medical ID"; role_weight: 166 }
                    ListElement { role_role: "role_dateOfBirth"; role_text: "Date of Birth"; role_weight: 198 }
                }

                header: Rectangle {
                    z: 100
                    height: Theme.margin(8)
                    width: patientList.width
                    color: Theme.backgroundColor

                    RowLayout {
                        anchors { fill: parent }
                        spacing: Theme.margin(11)

                        Repeater {
                            model: patientHeader

                            SortHeader {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.preferredWidth: role_weight

                                sortText: role_text
                                sortRole: role_role
                                sortedRole: patientList.model.sortedRoleName
                                sortedOrder: patientList.model.sortedOrder
                                onSort: patientList.model.setSort(roleName, order)
                            }
                        }
                    }

                    DividerLine {
                        anchors { bottom: parent.bottom }
                        orientation: Qt.Horizontal
                    }
                }

                delegate: Item {
                    height: Theme.margin(8) + (!index ? Theme.margin(1) : 0)
                    width: patientList.width

                    Rectangle {
                        width: parent.width
                        height: Theme.margin(8)
                        anchors { bottom: parent.bottom }
                        radius: Theme.margin(1)
                        color: (importViewModel.patientMatchList.selectedPatientId === role_id) ?
                                                     Theme.foregroundColor : Theme.backgroundColor

                        MouseArea {
                            anchors.fill: parent
                            onClicked: importViewModel.patientMatchList.selectPatient(role_id)
                        }

                        RowLayout {
                            anchors { fill: parent; leftMargin: Theme.marginSize }
                            spacing: Theme.margin(11)

                            RowLayout {
                                Layout.fillWidth: true
                                Layout.preferredWidth: patientHeader.get(0).role_weight - Theme.margin(2)
                                spacing: Theme.margin(2)

                                IconImage {
                                    sourceSize: Theme.iconSize
                                    source: "qrc:/icons/folder-man.svg"
                                }

                                Label {
                                    Layout.fillWidth: true
                                    state: "body1"
                                    text: role_name
                                }
                            }

                            Label {
                                Layout.fillWidth: true
                                Layout.preferredWidth: patientHeader.get(1).role_weight
                                state: "body1"
                                padding: Theme.marginSize
                                text: role_medicalId ? role_medicalId : "-"
                            }

                            Label {
                                Layout.fillWidth: true
                                Layout.preferredWidth: patientHeader.get(2).role_weight
                                padding: Theme.marginSize
                                state: "body1"
                                text: role_dateOfBirth.toLocaleString(Qt.locale(), "d MMM yyyy")
                            }
                        }
                    }
                }
            }

            RowLayout {
                id: layout
                Layout.alignment: Qt.AlignRight
                spacing: Theme.marginSize

                Button {
                    state: "available"
                    text: qsTr("Cancel")

                    onClicked: close()
                }

                Button {
                    state: "active"
                    text: qsTr("Create New")
                    onClicked:  {
                        importViewModel.addNewPatientScan();
                        close();
                    }
                }

                Button {
                    enabled: importViewModel.patientMatchList.selectedPatientId
                    state: "active"
                    text: qsTr("Merge with Selection")

                    onClicked: {
                        importViewModel.mergePatientScan(importViewModel.patientMatchList.selectedPatientId);
                        close();
                    }
                }
            }
        }
    }

    onClosed: importViewModel.clearPatientMatch();
}
