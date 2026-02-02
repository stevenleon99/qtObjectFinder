import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.15
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import SurfaceFiducialPageState 1.0
import GmQml 1.0

import "../.."
import "../../.."
import "../../../tracking"

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    SurfaceFiducialViewModel {
        id: surfaceFiducialViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            state: "Registration Sidebar"
            title: qsTr("Place References")
            pageNumber: 3
            maxPageNumber: 5
            description: qsTr("Set/modify references in the scan and capture placement with probe.")

            SectionHeader {
                Layout.leftMargin: 0
                Layout.rightMargin: 0
                title: qsTr("REFERENCE")
            }

            ColumnLayout {
                spacing: Theme.marginSize
                Layout.preferredWidth: 360

                RowLayout {
                    spacing: Theme.marginSize

                    Rectangle{
                        Layout.preferredHeight: 48
                        Layout.preferredWidth: 120

                        color: (surfaceFiducialViewModel.indexSelected == 1) ? Theme.slate700 : Theme.transparent
                        border.color: (surfaceFiducialViewModel.indexSelected == 1) ? Theme.blue : Theme.navyLight
                        border.width: (surfaceFiducialViewModel.indexSelected == 1) ? 2 : 1
                        radius: 4

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: Theme.margin(1)
                            anchors.fill: parent

                            IconImage {
                                id: crosshairIcon1
                                Layout.leftMargin: Theme.margin(1)
                                Layout.rightMargin: 0
                                source: "qrc:/icons/crosshair.svg"
                                sourceSize: Theme.iconSize
                                color: Theme.magenta
                            }

                            Label {
                                Layout.leftMargin: 0
                                Layout.rightMargin: 37
                                state: "subtitle1"
                                text: "Ref. 1"
                                color: Theme.white
                                font.bold: true
                            }

                            MouseArea {
                                width: parent.width
                                height: parent.height

                                onClicked: {
                                    surfaceFiducialViewModel.setPosition(1)
                                }

                            }
                        }
                    }

                    Button {
                        Layout.preferredWidth: 56
                        Layout.preferredHeight: 48
                        leftPadding: 0
                        rightPadding: 0
                        state: (surfaceFiducialViewModel.isVolumePoint1Set)?"available":"active"
                        text: "Set"
                        font.bold: true

                        onClicked: surfaceFiducialViewModel.setVolumePosition(1)
                    }

                    Button {
                        Layout.preferredWidth: 125
                        Layout.preferredHeight: 48
                        leftPadding: 0
                        rightPadding: 0
                        state: {
                            if (surfaceFiducialViewModel.isPatientPoint1Set)
                            {
                                if (surfaceFiducialViewModel.indexSelected == 1)
                                {
                                    return "hinted"
                                }
                                else
                                {
                                    return "available"
                                }
                            }
                            else
                            {
                                return "active"
                            }
                        }
                        text: "Capture"
                        font.bold: true
                        icon.source: (surfaceFiducialViewModel.indexSelected == 1)?"qrc:/icons/foot-pedal.svg":""

                        onClicked: surfaceFiducialViewModel.setPatientPosition(1)
                    }

                }

                RowLayout {
                    spacing: Theme.marginSize

                    Rectangle{
                        Layout.preferredHeight: 48
                        Layout.preferredWidth: 120

                        color: (surfaceFiducialViewModel.indexSelected == 2) ? Theme.slate700 : Theme.transparent
                        border.color: (surfaceFiducialViewModel.indexSelected == 2) ? Theme.blue : Theme.navyLight
                        border.width: (surfaceFiducialViewModel.indexSelected == 2) ? 2 : 1
                        radius: 4

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: Theme.margin(1)
                            anchors.fill: parent


                            IconImage {
                                id: crosshairIcon2
                                Layout.leftMargin: Theme.margin(1)
                                Layout.rightMargin: 0
                                source: "qrc:/icons/crosshair.svg"
                                sourceSize: Theme.iconSize
                                color: Theme.lime
                            }

                            Label {
                                Layout.leftMargin: 0
                                Layout.rightMargin:37
                                state: "subtitle1"
                                text: "Ref. 2"
                                color: Theme.white
                                font.bold: true
                            }

                            MouseArea {
                                width: parent.width
                                height: parent.height

                                onClicked: {
                                    surfaceFiducialViewModel.setPosition(2)
                                }

                            }
                        }
                    }

                    Button {
                        Layout.preferredWidth: 56
                        Layout.preferredHeight: 48
                        leftPadding: 0
                        rightPadding: 0
                        state: (surfaceFiducialViewModel.isVolumePoint2Set)? "available" : "active"
                        text: "Set"
                        font.bold: true

                        onClicked: surfaceFiducialViewModel.setVolumePosition(2)
                    }

                    Button {
                        Layout.preferredWidth: 125
                        Layout.preferredHeight: 48
                        leftPadding: 0
                        rightPadding: 0
                        state: {
                            if (surfaceFiducialViewModel.isPatientPoint2Set)
                            {
                                if (surfaceFiducialViewModel.indexSelected == 2)
                                {
                                    return "hinted"
                                }
                                else
                                {
                                    return "available"
                                }
                            }
                            else
                            {
                                return "active"
                            }
                        }
                        text: "Capture"
                        font.bold: true
                        icon.source: (surfaceFiducialViewModel.indexSelected == 2)?"qrc:/icons/foot-pedal.svg":""

                        onClicked: surfaceFiducialViewModel.setPatientPosition(2)
                    }

                }

                RowLayout {
                    spacing: Theme.marginSize

                    Rectangle{
                        Layout.preferredHeight: 48
                        Layout.preferredWidth: 120

                        color: (surfaceFiducialViewModel.indexSelected == 3) ? Theme.slate700 : Theme.transparent
                        border.color: (surfaceFiducialViewModel.indexSelected == 3) ? Theme.blue : Theme.navyLight
                        border.width: (surfaceFiducialViewModel.indexSelected == 3) ? 2 : 1
                        radius: 4

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            spacing: Theme.margin(1)
                            anchors.fill: parent


                            IconImage {
                                id: crosshairIcon3
                                Layout.leftMargin: Theme.margin(1)
                                Layout.rightMargin: 0
                                source: "qrc:/icons/crosshair.svg"
                                sourceSize: Theme.iconSize
                                color: Theme.yellow
                            }

                            Label {
                                Layout.leftMargin: 0
                                Layout.rightMargin: 37
                                state: "subtitle1"
                                text: "Ref. 3"
                                color: Theme.white
                                font.bold: true
                            }

                            MouseArea {
                                width: parent.width
                                height: parent.height

                                onClicked: {
                                    surfaceFiducialViewModel.setPosition(3)
                                }
                            }
                        }
                    }

                    Button {
                        Layout.preferredWidth: 56
                        Layout.preferredHeight: 48
                        leftPadding: 0
                        rightPadding: 0
                        state: (surfaceFiducialViewModel.isVolumePoint3Set) ? "available" : "active"
                        text: "Set"
                        font.bold: true

                        onClicked: surfaceFiducialViewModel.setVolumePosition(3)
                    }

                    Button {
                        Layout.preferredWidth: 125
                        Layout.preferredHeight: 48
                        leftPadding: 0
                        rightPadding: 0
                        state: {
                            if (surfaceFiducialViewModel.isPatientPoint3Set)
                            {
                                if (surfaceFiducialViewModel.indexSelected == 3)
                                {
                                    return "hinted"
                                }
                                else
                                {
                                    return "available"
                                }
                            }
                            else
                            {
                                return "active"
                            }
                        }

                        text: "Capture"
                        font.bold: true
                        icon.source: (surfaceFiducialViewModel.indexSelected == 3)?"qrc:/icons/foot-pedal.svg":""

                        onClicked: surfaceFiducialViewModel.setPatientPosition(3)
                    }

                }

            }
        }

        RowLayout{
            Layout.topMargin: Theme.marginSize + 4
            Layout.fillWidth: true
            Layout.preferredWidth: parent.width
            spacing: 0
            visible: surfaceFiducialViewModel.pageState == SurfaceFiducialPageState.Init
                     || surfaceFiducialViewModel.pageState == SurfaceFiducialPageState.WrongInit

            Label {
                Layout.leftMargin: Theme.marginSize

                Layout.alignment: Qt.AlignLeft
                state: "subtitle1"
                text: "Initial Fit"
                color: Theme.white
            }

            IconImage {
                id: checkmark
                Layout.leftMargin: 161

                source: (surfaceFiducialViewModel.pageState == SurfaceFiducialPageState.Init) ? "qrc:/icons/check.svg" : "qrc:/icons/x.svg"
                sourceSize: Theme.iconSize
                color: (surfaceFiducialViewModel.pageState == SurfaceFiducialPageState.Init) ? Theme.green : Theme.red
            }

            Label {
                Layout.alignment: Qt.AlignRight
                Layout.leftMargin: 4
                Layout.rightMargin: Theme.marginSize
                state: "subtitle1"
                text: (surfaceFiducialViewModel.pageState == SurfaceFiducialPageState.Init) ? "Good" : "Bad"
                color: (surfaceFiducialViewModel.pageState == SurfaceFiducialPageState.Init) ? Theme.green : Theme.red
            }

        }

        LayoutSpacer { }

        PageControls {
            Layout.fillHeight: false
            forwardEnabled: surfaceFiducialViewModel.pageState == SurfaceFiducialPageState.Init
            backEnabled: true

            onBackClicked: applicationViewModel.switchToPage(AppPage.SurfaceSetup)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.SurfaceMap)
        }
    }

    DividerLine { }
}
