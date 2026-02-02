import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4
import QtQuick.Layouts 1.12
import Theme 1.0
import GmQml 1.0
import ViewModels 1.0
import "../components"

Item {
    CaseListModel {
        id: caseListModel
    }

    ListView {
        id: caseList
        objectName: "caseListContainer"
        property string selectedTimeRole: ""

        anchors.fill: parent
        clip: true
        boundsBehavior: Flickable.DragOverBounds
        headerPositioning: ListView.OverlayHeader
        currentIndex: -1
        interactive: contentHeight > height

        ListModel {
            id: caseHeaderModel

            ListElement {
                role: "role_name"
                displayText: "NAME"
                stateText: "text"
                weight: 1016
            }

            ListElement {
                role: ""
                displayText: "IMAGES"
                stateText: "text"
                weight: 102
            }

            ListElement {
                role: "role_accessedTime,role_createdTime"
                displayText: "Date Opened,Date Created"
                stateText: "dropdown"
                weight: 258
            }

        }

        model: SortFilterProxyModel {
            sourceModel: caseListModel
        }

        header: Rectangle {
            z: 100
            width: caseList.width
            height: Theme.marginSize * 4.5
            color: Theme.backgroundColor
            Component.onCompleted: {
                caseList.model.setSort(caseListModel.caseSortedRoleName, caseListModel.caseSortedOrder);
            }

            RowLayout {
                spacing: 0

                anchors {
                    fill: parent
                    bottomMargin: Theme.marginSize * 0.5
                }

                Repeater {
                    property int selectedRole: -1

                    model: caseHeaderModel

                    SortHeader {
                        Layout.alignment: Qt.AlignRight
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        Layout.preferredWidth: weight
                        state: stateText
                        sortText: displayText
                        sortRole: role
                        sortedRole: caseList.model.sortedRoleName
                        sortedOrder: caseList.model.sortedOrder
                        onSort: {
                            caseListModel.setCaseSortedRoleName(roleName);
                            caseListModel.setCaseSortedOrder(order);
                            caseList.model.setSort(roleName, order);
                        }
                        onComboBoxRoleChanged: caseList.selectedTimeRole = comboBoxRole
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
            objectName: "case_" + index
            width: caseList.width
            height: Theme.marginSize * 4
            radius: 8
            color: (caseListModel.selectedCaseId === role_id) ? Theme.foregroundColor : Theme.backgroundColor

            RowLayout {
                spacing: 0

                anchors {
                    fill: parent
                }

                Repeater {
                    model: caseHeaderModel

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
                                objectName: "case_" + index + "_icon"
                                readonly property var casePluginInfo: pluginInfoListModel.pluginInfoForWorkflow(role_type)

                                visible: role === "role_name"
                                sourceSize: Qt.size(40, 40)
                                fillMode: Image.PreserveAspectFit
                                color: (caseListModel.selectedCaseId === role_id) ? Theme.blue : Theme.navyLight
                                source: casePluginInfo ? casePluginInfo.pluginIcon : "qrc:/icons/image-study.svg"
                            }

                            Label {
                                objectName: "caseLabelInfo_" + index
                                state: "body1"
                                maximumLineCount: 1
                                Layout.fillWidth: true
                                elide: Label.ElideRight
                                wrapMode: Label.WrapAnywhere
                                horizontalAlignment: (displayText === "IMAGES") ? Text.AlignHCenter : Text.AlignLeft
                                text: {
                                    switch (index) {
                                    case 0:
                                        role_name;
                                        break;
                                    case 1:
                                        role_totalImages;
                                        break;
                                    case 2:
                                        (caseList.selectedTimeRole === "role_createdTime") ? role_createdTimeStr : role_accessedTimeStr;
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
                    caseList.currentIndex = index;
                    caseListModel.selectCase(role_id);
                }

                anchors {
                    fill: parent
                }

            }

        }

    }

    EmptyItem {
        visible: caseListModel.count == 0
        anchors.centerIn: parent
        state: "cases"
    }

}
