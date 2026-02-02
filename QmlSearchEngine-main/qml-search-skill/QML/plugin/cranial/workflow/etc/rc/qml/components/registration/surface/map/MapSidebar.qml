import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.15
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0
import SurfaceMapPageState 1.0
import GmQml 1.0

import "../.."
import "../../.."
import "../../../tracking"
import "."

Item {
    Layout.preferredWidth: 360
    Layout.fillHeight: true

    SurfaceMapViewModel {
        id: surfaceMapViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        SidebarHeader {
            Layout.rightMargin: Theme.marginSize
            state: "Registration Sidebar"
            title: qsTr("Surface Map")
            pageNumber: 4
            maxPageNumber: 5
            description: qsTr("Trace surface map until sufficient fit has been reached.")

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                spacing: Theme.margin(4)

                Label {
                    state: "body1"
                    verticalAlignment: Label.AlignVCenter
                    text: qsTr("SURFACE MAP \n(" + surfaceMapViewModel.allTrackPointsCount + "/100 PTS.)")
                    color: Theme.navyLight
                    font.bold: true
                }

                Button {
                    enabled: surfaceMapViewModel.isCaptureButtonEnabled
                    Layout.preferredWidth: 147
                    Layout.preferredHeight: 46
                    // Layour.rightMargin: Theme.marginSize
                    Layout.alignment: Qt.AlignRight
                    leftPadding: 0
                    rightPadding: 0
                    state: surfaceMapViewModel.isTakingPoints?"disabled":"active"
                    text: "Capture"
                    font.bold: true
                    font.pixelSize: 21
                    icon.source: "qrc:/icons/foot-pedal.svg"

                    onClicked: {
                        surfaceMapViewModel.obtainPatientPoints()
                    }
                }
            }
        }

        ListView {
            id: trackList
            Layout.fillWidth: true
            //Layout.fillHeight: true
            Layout.preferredHeight: 80 * surfaceMapViewModel.trackPointList.trackPointsCount
            Layout.leftMargin: Theme.marginSize
            Layout.bottomMargin: 0
            model: surfaceMapViewModel.trackPointList

            delegate:
                TrackDelegate {
                isSelected: role_trackNumber == surfaceMapViewModel.trackSelected
                isValid: role_isValid
                trackRms: role_trackRms
                trackNumber: role_trackNumber
                trackColor: role_color
                trackSize: role_size
                trackDuration: role_duration

                onDeleteTrackPoints : {
                    surfaceMapViewModel.deleteTrackPoints(role_trackNumber)
                }
            }
        }

        Repeater {
            Layout.preferredWidth: 328
            Layout.leftMargin: Theme.marginSize
            Layout.preferredHeight: 80*(3 - surfaceMapViewModel.trackPointList.trackPointsCount)
            Layout.topMargin: 0
            model: 3 - surfaceMapViewModel.trackPointList.trackPointsCount

            delegate:
                ColumnLayout {
                Layout.preferredHeight: 80
                Layout.fillWidth: true
                spacing: 0

                RowLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignCenter

                    IconImage {
                        source: "qrc:/images/multi-line.svg"
                        sourceSize: Theme.iconSize
                        color:  Theme.navyLight
                    }

                    Label {
                        state: "body1"
                        text: qsTr("No Trace")
                        color: Theme.white
                    }
                }

                DividerLine {
                    Layout.fillWidth: true
                    Layout.leftMargin: Theme.marginSize
                    Layout.rightMargin: Theme.marginSize
                    orientation: Qt.Horizontal
                }
            }

        }

        IconImage {
            id: img
            Layout.alignment: Qt.AlignCenter
            Layout.preferredWidth: 214
            Layout.preferredHeight: 258
            source:  "qrc:/images/Face-Trace-Areas-Cranial.png"

            Label {
                anchors.centerIn: parent
                state: "button1"
                text: "RECOMMENDED"
                font.bold: true
            }
        }

        Label {
            Layout.alignment: Qt.AlignCenter
            Layout.topMargin: -100
            state: "body1"
            text: "Total Registration Fit"
            font.bold: true
        }

        ValueMeter {
            id: fit
            Layout.topMargin: -50
            Layout.bottomMargin: Theme.margin(1)
            Layout.fillWidth: true
            Layout.rightMargin: Theme.marginSize
            Layout.leftMargin: Theme.marginSize
            Layout.preferredHeight: 8

            value: surfaceMapViewModel.rmsScaled
            disabled: (surfaceMapViewModel.rmsScaled < 0)?true:false
            misc: false
        }

        Button {
            id: reg
            Layout.preferredHeight: 48
            Layout.fillWidth: true
            Layout.rightMargin: Theme.marginSize
            Layout.leftMargin: Theme.marginSize
            Layout.bottomMargin: Theme.marginSize
            leftPadding: 0
            rightPadding: 0
            state: surfaceMapViewModel.isRegisterButtonEnabled?"active":"disabled"
            text: "Register"
            font.pixelSize: 21
            font.bold: true

            onClicked: {
                surfaceMapViewModel.registerSurfacePoints()
            }
        }

        LayoutSpacer {
            visible: !surfaceMapViewModel.isRangeEnabled
        }

        RangeSlider {
            visible: surfaceMapViewModel.isRangeEnabled
            Layout.fillWidth: true
            Layout.rightMargin: Theme.marginSize
            Layout.leftMargin: Theme.marginSize
            Layout.bottomMargin: Theme.marginSize
            Layout.topMargin: Theme.marginSize
            from: 1
            to: surfaceMapViewModel.numPointsTrack + 1
            first.value: 0
            second.value: 0

            first.onMoved: surfaceMapViewModel.setMinIndexDeletion( first.value)
            second.onMoved: surfaceMapViewModel.setMaxIndexDeletion( second.value)

            onToChanged: {
                first.value = 0;
                second.value = to;
            }
        }

        DividerLine { }

        CheckDelegate {
            enabled: surfaceMapViewModel.pageState == SurfaceMapPageState.RmsLow || surfaceMapViewModel.pageState == SurfaceMapPageState.Verified
            Layout.fillWidth: true
            Layout.topMargin: Theme.marginSize
            Layout.bottomMargin: Theme.marginSize
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.marginSize
            text: qsTr("Check Anatomical Landmarks")
            checked: surfaceMapViewModel.areLandmarksChecked

            onToggled: surfaceMapViewModel.areLandmarksChecked = !surfaceMapViewModel.areLandmarksChecked
        }

        PageControls {
            Layout.fillHeight: false
            forwardEnabled: surfaceMapViewModel.pageState == SurfaceMapPageState.Verified
            backEnabled: true

            onBackClicked: applicationViewModel.switchToPage(AppPage.SurfaceFiducial)

            onForwardClicked: applicationViewModel.switchToPage(AppPage.Navigate)
        }
    }

    DividerLine { }
}
