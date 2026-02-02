import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Layouts 1.12
import Theme 1.0
import ViewModels 1.0
import GmQml 1.0
import "../components"

Item {
    PatientListModel {
        id: patientListModel
    }

    Item {
        function select(index) {
            patientList.currentIndex = index;
            // Coming from PatientListModel::RoleNames::PatientId = Qt::UserRole
            // Referring to https://doc.qt.io/qt-5/qt.html#ItemDataRole-enum
            // Qt::UserRole is 256
            let role_id = 256;
            let patientId = patientListModel.data(patientListModel.index(index, 0), role_id);
            patientListModel.selectPatient(patientId);
        }

        objectName: "autoUIDrivePatientSelectObj"
    }

    ListView {
        id: patientList
        property string selectedTimeRole: ""

        anchors.fill: parent
        clip: true
        boundsBehavior: Flickable.DragOverBounds
        headerPositioning: ListView.OverlayHeader
        currentIndex: -1
        interactive: contentHeight > height

        ListModel {
            id: patientHeaderModel

            ListElement {
                role: "role_name"
                displayText: "NAME"
                stateText: "text"
                weight: 1118
            }

            ListElement {
                role: "role_accessedTime,role_createdTime"
                displayText: "Date Opened,Date Created"
                stateText: "dropdown"
                weight: 258
            }

        }

        model: SortFilterProxyModel {
            sourceModel: patientListModel
        }

        header: Rectangle {
            z: 100
            width: patientList.width
            height: Theme.marginSize * 4.5
            color: Theme.backgroundColor
            Component.onCompleted: {
                patientList.model.setSort(patientListModel.patientSortedRoleName, patientListModel.patientSortedOrder);
            }

            RowLayout {
                spacing: 0

                anchors {
                    fill: parent
                    bottomMargin: Theme.marginSize * 0.5
                }

                Repeater {
                    model: patientHeaderModel

                    SortHeader {
                        Layout.alignment: Qt.AlignRight
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.preferredWidth: weight
                        state: stateText
                        sortText: displayText
                        sortRole: role
                        sortedRole: patientList.model.sortedRoleName
                        sortedOrder: patientList.model.sortedOrder
                        onSort: {
                            patientListModel.setPatientSortedRoleName(roleName);
                            patientListModel.setPatientSortedOrder(order);
                            patientList.model.setSort(roleName, order);
                        }
                        onComboBoxRoleChanged: {
                            patientList.selectedTimeRole = comboBoxRole;
                        }
                    }

                }

            }

            DividerLine {
                anchors.bottom: parent.bottom
                anchors.bottomMargin: Theme.marginSize * 0.5
                orientation: Qt.Horizontal
            }

        }

        delegate: Rectangle {
            objectName: "patient_" + index
            width: patientList.width
            height: Theme.marginSize * 4
            radius: 8
            color: (patientListModel.selectedPatientId === role_id) ? Theme.foregroundColor : Theme.backgroundColor

            RowLayout {
                spacing: 0

                anchors {
                    fill: parent
                }

                Repeater {
                    model: patientHeaderModel

                    Item {
                        Layout.alignment: Qt.AlignRight
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.preferredWidth: weight

                        RowLayout {
                            height: parent.height
                            spacing: Theme.marginSize

                            anchors {
                                fill: parent
                                leftMargin: Theme.marginSize * 0.75
                            }

                            IconImage {
                                id: iconImage

                                visible: role === "role_name"
                                sourceSize: Qt.size(40, 40)
                                fillMode: Image.PreserveAspectFit
                                color: (patientListModel.selectedPatientId === role_id) ? Theme.blue : Theme.navyLight
                                source: "qrc:/icons/folder-man.svg"
                            }

                            Label {
                                state: "body1"
                                maximumLineCount: 1
                                Layout.fillWidth: true
                                elide: Label.ElideRight
                                wrapMode: Label.WrapAnywhere
                                text: {
                                    switch (index) {
                                    case 0:
                                        role_name;
                                        break;
                                    case 1:
                                        (patientList.selectedTimeRole === "role_createdTime") ? role_createdTimeStr : role_accessedTimeStr;
                                        break;
                                    }
                                }
                            }

                        }

                    }

                }

            }

            MouseArea {
                z: 100
                onClicked: {
                    patientList.currentIndex = index;
                    patientListModel.selectPatient(role_id);
                }

                anchors {
                    fill: parent
                }

            }

        }

    }

    EmptyItem {
        visible: patientListModel.count == 0
        anchors.centerIn: parent
        state: "patients"
    }

}
