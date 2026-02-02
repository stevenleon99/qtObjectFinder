import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0
import Enums 1.0
import AppPage 1.0

ColumnLayout {
    Layout.preferredHeight: 64
    Layout.fillWidth: true
    spacing: 0

    DividerLine { }

    RowLayout {
        Layout.preferredHeight: 64
        Layout.fillWidth: true
        spacing: Theme.margin(1)

        property bool regTransferEnabled: false

        ToolsVisibilityViewModel {
            id: toolsVisibilityViewModel
        }

        FluoroMeterViewModel {
            id: fluoroMeterViewModel
        }

        SurveillanceMarkerViewModel {
            id: surveillanceMarkerViewModel
        }

        LoadCellMeterViewModel {
            id: loadCellMeterViewModel
        }

        Label {
            Layout.fillWidth: false
            Layout.alignment: Qt.AlignVCenter
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.margin(1)
            state: "body1"
            font { bold: true; letterSpacing: 1; capitalization: Font.AllUppercase }
            color: Theme.navyLight
            text: qsTr("Track")
        }


        TrackingPanelDelegate {
            Layout.rightMargin: Theme.margin(1)
            objectName: qsTr(toolsVisibilityViewModel.patRefLabel)
            source: toolsVisibilityViewModel.patRefIsFra ? "qrc:/icons/fr-array.svg" : "qrc:/icons/drb-array-2.svg"
            visibilityStatus: toolsVisibilityViewModel.patRefVisibilityStatus

            barValue: surveillanceMarkerViewModel.isMarkerSet ? surveillanceMarkerViewModel.valueMeterValue : NaN
            barText: qsTr("Surveillance")
            barVisible: toolsVisibilityViewModel.isPatRefSetByUser & surveillanceMarkerViewModel.isMarkerSet
            barEnabled: surveillanceMarkerViewModel.isMarkerSet & surveillanceMarkerViewModel.isMarkerVisible
            barClearable: surveillanceMarkerViewModel.isMarkerSet
            barPlusButtonEnabled: false

            onCleared: surveillanceMarkerViewModel.clearMarker()

            transferVisible: toolsVisibilityViewModel.isTransferVisible

        }

        TrackingPanelDelegate {
            Layout.rightMargin: Theme.margin(1)
            visible: toolsVisibilityViewModel.isProbeDisplayed
            objectName: qsTr("Probe")
            barVisible: false
            source: "qrc:/icons/probe.svg"
            visibilityStatus: toolsVisibilityViewModel.actProbeVisibilityStatus
            transferVisible: false
        }

        TrackingPanelDelegate {
            Layout.rightMargin: Theme.margin(1)
            id: ict
            visible: toolsVisibilityViewModel.isIctDisplayed
            objectName: qsTr("ICT")
            barVisible: false
            source: "qrc:/icons/ict-array-2.svg"
            visibilityStatus: toolsVisibilityViewModel.ictVisibilityStatus
            transferVisible: false
        }

        TrackingPanelDelegate {
            Layout.rightMargin: Theme.margin(1)
            id: fluoro
            visible: toolsVisibilityViewModel.isFluoroCtDisplayed && !toolsVisibilityViewModel.isE3DConnected
            objectName: qsTr("Fluoro")
            source: "qrc:/icons/array-fluoroscopy.svg"
            visibilityStatus: toolsVisibilityViewModel.fluoroFixtureVisibilityStatus

            barValue: fluoroMeterViewModel.valueMeterValue
            barText: qsTr("Movement")
            barVisible: fluoroMeterViewModel.isComponentVisible
            barEnabled: fluoro.visibilityStatus == ToolVisibilityStatus.Visible

            barClearable: false
            barPlusButtonEnabled: false

            transferVisible: false

            hasConnection: true
            isInitializing: toolsVisibilityViewModel.fluoroStreamConnection == FluoroStreamStatus.INITIALIZING

            connectionSource: {
                if (toolsVisibilityViewModel.fluoroStreamConnection == FluoroStreamStatus.CONNECTED)
                    return "qrc:/images/auxiliary-input.svg"
                else
                    return "qrc:/images/auxiliary-input-disconnected.svg"
            }

            connectionColor: {
                if (toolsVisibilityViewModel.fluoroStreamConnection == FluoroStreamStatus.CONNECTED)
                {
                    return Theme.green
                }
                else if (toolsVisibilityViewModel.fluoroStreamConnection == FluoroStreamStatus.NOSIGNAL)
                {
                    return Theme.yellow
                }
                else
                {
                    return Theme.red
                }
            }
        }

        TrackingPanelDelegate {
            Layout.rightMargin: Theme.margin(1)
            id: e3d
            visible: toolsVisibilityViewModel.isE3DVisibilityDisplayed
            objectName: qsTr("E3D")
            barVisible: false
            source: "qrc:/icons/E3D-C-side-view-left.svg"
            visibilityStatus: toolsVisibilityViewModel.e3DVisibilityStatus
            transferVisible: false

            hasConnection: true
            isInitializing: false

            connectionSource: {
                if (toolsVisibilityViewModel.isE3DConnected)
                    return "qrc:/images/auxiliary-input.svg"
                else
                    return "qrc:/images/auxiliary-input-disconnected.svg"
            }

            connectionColor: {
                if (toolsVisibilityViewModel.isE3DConnected)
                {
                    return Theme.green
                }
                else
                {
                    return Theme.red
                }
            }

        }

        LayoutSpacer {}

        TrackingPanelDelegate {
            id: igee
            Layout.rightMargin: Theme.margin(1)
            visible: true
            enabled: true
            objectName: qsTr("IGEE")
            transferVisible: false
            source: {
                if (eeConnected)
                {
                    if (eeHoldingTool)
                    {
                        return "qrc:/icons/end_effector_cranial_tool.svg";
                    }
                    else
                    {
                        return "qrc:/icons/end-effector-cranial.svg";
                    }
                }
                else
                {
                    return "qrc:/icons/end_effector_cranial_disconnected.svg";
                }
            }
            visibilityStatus: toolsVisibilityViewModel.igeeVisibilityStatus
            barValue: loadCellMeterViewModel.valueMeterValue
            barText: qsTr(loadCellMeterViewModel.meterLabel)
            barVisible: true
            barEnabled: igee.enabled & eeConnected
            barClearable: false
            barPlusButtonEnabled: false

            property bool eeConnected: toolsVisibilityViewModel.eeConnectionState == EndEffectorConnectionState.Connected
            property bool eeHoldingTool: toolsVisibilityViewModel.eeToolState == EndEffectorToolState.ToolPresent

            onClicked: toolsVisibilityViewModel.setActiveToolToIgee()
        }

        Button {
            state: "icon"
            icon.source: "qrc:/icons/tracking-camera"
            onClicked: trackingPopup.setup(this)

            TrackingPopup {
                id: trackingPopup
                visible: false
            }
        }

        DividerLine {
            Layout.margins: 0
            visible: applicationViewModel.currentPage == AppPage.PatientRegistrationSelect
        }
    }
}
