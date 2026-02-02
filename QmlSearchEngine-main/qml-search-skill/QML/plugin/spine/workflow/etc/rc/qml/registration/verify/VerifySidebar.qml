import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import PageEnum 1.0
import PatientRegistrationCategory 1.0

import "../../components"


Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    VerifyAnatomyListViewModel {
        id: verifyAnatomyListViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            title: qsTr("Verify")
            pageNumber: 2
            maxPageNumber: 2
            description: qsTr("Verify merged levels")
        }

        Item {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize
            Layout.preferredHeight: Theme.margin(8)

            Label {
                anchors { left: parent.left; verticalCenter: parent.verticalCenter }
                state: "body1"
                text: qsTr("Levels")
                color: Theme.navyLight
                font { bold: true; capitalization: Font.AllUppercase }
            }
        }

        VerifyLevelList {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(40)
            Layout.bottomMargin: Theme.margin(1)
            verifyLevelListVM: verifyAnatomyListViewModel
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            Label {
                anchors { left: parent.left; leftMargin: Theme.marginSize; verticalCenter: parent.verticalCenter }
                state: "h5"
                font { bold: true; capitalization: Font.AllUppercase }
                text: verifyAnatomyListViewModel.selectedAnatomy
            }

            DividerLine {
                orientation: Qt.Horizontal
                anchors { top: parent.top }
            }
        }

        Button {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(6)
            Layout.margins: Theme.marginSize
            state: verifyAnatomyListViewModel.currentRegVerified ? "available" : "active"
            text: verifyAnatomyListViewModel.currentRegVerified ? qsTr("Unverify Level") : qsTr("Verify Level")

            onClicked: verifyAnatomyListViewModel.toggleCurrentRegVerified()

            property bool setValid: verifyAnatomyListViewModel.currentRegVerified ? false : true
        }

        ColumnLayout {
            visible: verifyAnatomyListViewModel.regAlgoSelectionEnabled
            Layout.fillWidth: true
            Layout.margins: Theme.marginSize
            spacing: Theme.margin(1)

            Label {
                state: "body1"
                color: Theme.navyLight
                text: qsTr("Registration Type")
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(6)
                color: Theme.transparent
                border.color: Theme.navyLight
                radius: 4

                RowLayout {
                    anchors { fill: parent; leftMargin: Theme.margin(2); rightMargin: Theme.margin(1) }
                    spacing: 0

                    Label {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        state: "subtitle1"
                        verticalAlignment : Text.AlignVCenter
                        text: verifyAnatomyListViewModel.selectedAlgorithm
                    }

                    IconImage {
                        Layout.alignment: Qt.AlignVCenter
                        fillMode: Image.PreserveAspectFit
                        source: "qrc:/icons/caret-down.svg"
                        sourceSize: Theme.iconSize
                        color: registrationTypeDropdown.opened ? Theme.blue : Theme.white
                    }
                }

                MouseArea {
                    anchors { fill: parent }
                    onPressed: {
                        if (!registrationTypeDropdown.visible)
                            registrationTypeDropdown.setup(this)
                    }
                }

                RegistrationTypeDropdown {
                    id: registrationTypeDropdown
                    scoreVisible: verifyAnatomyListViewModel.scoreDisplayEnabled

                    model: verifyAnatomyListViewModel.regAlgorithmList

                    onTypeClicked: verifyAnatomyListViewModel.selectAlgorithm(type);
                }
            }
        }

        LayoutSpacer { }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            PageControls {
                anchors { verticalCenter: parent.verticalCenter }
                width: parent.width
            }

            DividerLine {
                orientation: Qt.Horizontal
                anchors { top: parent.top }
            }
        }
    }

    DividerLine { }
}
