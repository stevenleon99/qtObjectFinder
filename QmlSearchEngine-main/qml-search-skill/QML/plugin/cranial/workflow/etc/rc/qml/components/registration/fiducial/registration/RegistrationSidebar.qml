import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4
import QtGraphicalEffects 1.15

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import FiducialRegistrationPageState 1.0
import GmQml 1.0

import "../.."
import "../../.."
import "../../../tracking"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    FiducialRegistrationViewModel {
        id: fiducialRegistrationViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            state: "Registration Sidebar"
            title: qsTr("Place References")
            pageNumber: 3
            maxPageNumber: 3
            description: qsTr("Set/modify references in the scan and capture with probe.")

            SectionHeader {
                Layout.leftMargin: 0
                Layout.rightMargin: 0
                title: qsTr("REFERENCE")

                Button {
                    enabled: fiducialRegistrationViewModel.fiducialCount > 0
                    icon.source: "qrc:/icons/trash.svg"
                    state: "icon"

                    onClicked: fiducialRegistrationViewModel.deleteSelectedPair()
                }
            }

            ListView {
                Layout.fillWidth: true
                Layout.preferredHeight: 629
                spacing: Theme.marginSize
                z: -1
                clip: true

                model: fiducialRegistrationViewModel.pointsPairList

                ScrollBar.vertical: ScrollBar {
                    id: scrollBar
                    policy: ScrollBar.AlwaysOn
                    anchors { right: parent.right }
                    padding: Theme.margin(1)
                }

                delegate:

                    Rectangle{
                    width: Theme.margin(37)
                    height: Theme.margin(8)

                    color: role_isSelected?Theme.slate700:Theme.transparent
                    border.color: {
                        if (role_isSelected)
                            return Theme.blue
                        else
                            return Theme.navyLight
                    }
                    border.width: role_isSelected? 2:1
                    radius: 6

                    MouseArea {
                        anchors.fill: parent

                        onClicked: {
                            if (role_hasData)
                                fiducialRegistrationViewModel.setPosition(role_volumePosition)
                        }

                    }

                    RowLayout {
                        anchors.fill: parent
                        spacing: 0
                        visible: role_hasData

                        RowLayout {
                            Layout.leftMargin: Theme.margin(2)
                            
                            IconImage {
                                id: crosshairIcon
                                source: role_hasPatientPosition?"qrc:/images/landmark-placed.svg":"qrc:/images/landmark.svg"
                                sourceSize: Theme.iconSize
                                color: role_color
                            }

                            ColumnLayout {
                                spacing: 0
                                Layout.leftMargin: Theme.margin(1)/2

                                Label {
                                    state: "subtitle1"
                                    text: "Ref. " + role_index
                                    color: Theme.white
                                }

                                Label {
                                    state: "subtitle1"
                                    visible: (role_freScore>=0)
                                    text: "~" + role_freScore
                                    color: {
                                        if (role_freScore >= (2/3))
                                            return Theme.red
                                        else if (role_freScore >= (1/3))
                                            return Theme.yellow
                                        else
                                            return Theme.green
                                    }
                                }
                            }

    			            LayoutSpacer { }

                            Button {
                                Layout.rightMargin: Theme.margin(1)
                                Layout.preferredWidth: Theme.margin(15)
                                Layout.preferredHeight: 48//Theme.margin(3)
                                leftPadding: 0
                                rightPadding: 0
                                state: role_hasPatientPosition?"available":"active"
                                text: qsTr("Capture")
                                icon.source: role_isSelected?"qrc:/icons/foot-pedal.svg":""

                                onClicked: {
                                    if (role_isSelected)
                                    {
                                        fiducialRegistrationViewModel.setProbePosition(role_index);
                                        mouse.accepted = false;    
                                    }
                                    else 
                                    {
                                        fiducialRegistrationViewModel.setPosition(role_volumePosition);
                                    }
                                }

                            }
                        }
                    }

                    RowLayout {
                        spacing: 0
                        anchors.fill: parent
                        visible: !role_hasData

                        IconImage {
                            id: crosshairOffIcon
                            Layout.alignment: Qt.AlignLeft
                            Layout.leftMargin: Theme.marginSize
                            Layout.rightMargin: Theme.margin(1)
                            source: "qrc:/icons/crosshair-off.svg"
                            sourceSize: Theme.iconSize
                            color: Theme.navyLight
                        }

                        Label {
                            Layout.rightMargin: Theme.marginSize
                            Layout.alignment: Qt.AlignLeft
                            state: "body1"
                            text: role_index >2 ?qsTr("No Ref."):qsTr("Required Ref.")
                            color: Theme.white
                        }

                        LayoutSpacer { }

                        Button {
                            visible: role_addDisplayed
                            Layout.preferredWidth: 88
                            Layout.preferredHeight: 48
                            Layout.rightMargin: Theme.marginSize/2
                            leftPadding: 0
                            rightPadding: 0
                            state: "active"
                            font.bold: true
                            text: qsTr("Set")

                            onClicked: fiducialRegistrationViewModel.addNewVolumePoint()
                        }

                    }
                }
            } 
        }
        LayoutSpacer { }

        DividerLine { }

        ValueMeter {
            id: valueMeterLandmarkFreId
            Layout.preferredWidth: 328
            Layout.topMargin: Theme.marginSize
            Layout.bottomMargin: Theme.marginSize
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            value: fiducialRegistrationViewModel.freScore
            disabled: (fiducialRegistrationViewModel.freScore >= 0)?false:true
            text: qsTr("Total Registration Fit")
        }

        CheckDelegate {
            enabled: fiducialRegistrationViewModel.pageState == FiducialRegistrationPageState.FreLow || fiducialRegistrationViewModel.pageState == FiducialRegistrationPageState.Verified
            Layout.fillWidth: true
            Layout.bottomMargin: Theme.marginSize
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            text: qsTr("Check Anatomical Landmarks")
            checked: fiducialRegistrationViewModel.areLandmarksChecked

            onToggled: fiducialRegistrationViewModel.areLandmarksChecked = !fiducialRegistrationViewModel.areLandmarksChecked
        }


        PageControls {
            Layout.fillHeight: false
            forwardEnabled: fiducialRegistrationViewModel.pageState == FiducialRegistrationPageState.Verified
            backEnabled: true

            onBackClicked: applicationViewModel.switchToPage(AppPage.FiducialSetup)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.Navigate)
        }
    }

    DividerLine { }
}
