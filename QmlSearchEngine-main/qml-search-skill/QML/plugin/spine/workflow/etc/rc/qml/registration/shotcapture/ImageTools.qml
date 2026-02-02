import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import GmFluoroVisualizer 1.0

import ViewModels 1.0
import Enums 1.0

import "qrc:/uicom/fluorovisualizer/qml"
import "../../trackbar" 


Item {
    Layout.fillWidth: true
    Layout.preferredHeight: columnLayout.height

    ImageToolsViewModel {
        id: imageToolsViewModel

        property bool isEmitterAnterior: !isDetectorAnterior
    }

    ColumnLayout {
        id: columnLayout
        width: parent.width
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Layout.leftMargin

            Label {
                state: "body1"
                color: Theme.navyLight
                text: "Capture Tools"
                font {
                    bold: true
                    capitalization: Font.AllUppercase
                }
            }

            LayoutSpacer {}

            RowLayout {
                IconImage {
                    Layout.alignment: Qt.AlignHCenter
                    source: {
                        if (imageToolsViewModel.streamStatus == FluoroStreamStatus.CONNECTED || imageToolsViewModel.streamStatus == FluoroStreamStatus.NOSIGNAL)
                        {
                            return "qrc:/icons/check.svg"
                        }
                        else
                        {
                            return "qrc:/icons/x.svg"
                        }
                    }
                    sourceSize: Qt.size(32, 32)
                    color: {
                        if (imageToolsViewModel.streamStatus == FluoroStreamStatus.CONNECTED)
                        {
                            return Theme.green
                        }
                        else if (imageToolsViewModel.streamStatus == FluoroStreamStatus.NOSIGNAL)
                        {
                            return Theme.yellow
                        }
                        else
                        {
                            return Theme.red
                        }
                    }
                }

                Label {
                    state: "body2"
                    color: {
                        if (imageToolsViewModel.streamStatus == FluoroStreamStatus.CONNECTED)
                        {
                            return Theme.green
                        }
                        else if (imageToolsViewModel.streamStatus == FluoroStreamStatus.NOSIGNAL)
                        {
                            return Theme.yellow
                        }
                        else
                        {
                            return Theme.red
                        }
                    }
                    text: {
                        if (imageToolsViewModel.streamStatus == FluoroStreamStatus.CONNECTED)
                        {
                            return qsTr("Connected")
                        }
                        else if (imageToolsViewModel.streamStatus == FluoroStreamStatus.NOSIGNAL)
                        {
                            return qsTr("No Signal")
                        }
                        else
                        {
                            return qsTr("Disconnected")
                        }
                    }
                }
            }
        }

        GridLayout {
            Layout.preferredWidth: parent.width - Theme.margin(1)
            Layout.leftMargin: Theme.margin(1)
            columns: 2
            columnSpacing: Theme.margin(2)

            RowLayout {
                visible: imageToolsViewModel.videoInButtonVisible
                spacing: Theme.margin(1)

                Button {
                    state: "icon"
                    icon.source: "qrc:/icons/video-in.svg"

                    onVisibleChanged: {
                        if(!visible && fluoroVisualizerPopup.open)
                            fluoroVisualizerPopup.close()
                    }

                    onClicked: fluoroVisualizerPopup.open()

                    FluoroVisualizerPopup {
                        id: fluoroVisualizerPopup
                    }
                }

                Label {
                    state: "body2"
                    horizontalAlignment: Label.AlignHCenter
                    text: qsTr("Video-In")
                }
            }

            RowLayout {
                spacing: Theme.margin(1)
                visible: imageToolsViewModel.refreshShotVisible

                Button {
                    Layout.alignment: Qt.AlignHCenter
                    state: "icon"
                    icon.source: "qrc:/icons/refresh.svg"
                    enabled: imageToolsViewModel.refreshShotEnabled

                    onClicked: { 
                        imageToolsViewModel.refreshShot()
                    }
                }

                Label {
                    state: "body2"
                    horizontalAlignment: Label.AlignHCenter
                    text: qsTr("Refresh")
                }
            }

            RowLayout {
                visible: imageToolsViewModel.detectorSelectionEnabled
                spacing: Theme.margin(1)

                Button {
                    Layout.alignment: Qt.AlignHCenter
                    state: "icon"
                    color: Theme.transparent
                    icon.source: imageToolsViewModel.isEmitterAnterior ?
                                     "qrc:/icons/AP.svg":"qrc:/icons/PA.svg"

                    onClicked: { imageToolsViewModel.toggleDetectorAnterior() }
                }

                Label {
                    Layout.preferredWidth: Theme.margin(8)
                    state: "body2"
                    color: Theme.navyLight
                    horizontalAlignment: Label.AlignHCenter
                    textFormat: Text.RichText
                    text: {
                        if (imageToolsViewModel.isEmitterAnterior)
                            return qsTr("View: ") + "<font color=\"" + Theme.white + "\">" + qsTr("AP") + "</font>"
                        else
                            qsTr("View: ") + "<font color=\"" + Theme.white + "\">" + qsTr("PA") + "</font>"
                    }
                }
            }

            RowLayout {
                visible: imageToolsViewModel.hardwareAddedSelectionEnabled
                spacing: Theme.margin(1)

                Item {
                    Layout.preferredWidth: Theme.margin(6)
                    Layout.preferredHeight: Theme.margin(6)

                    CheckBox {
                        anchors { fill: parent; margins: 12 }
                        checked: imageToolsViewModel.isHardwareAdded
                        checkable: false

                        onClicked: { imageToolsViewModel.toggleHardwareAdded() }
                    }
                }

                Label {
                    state: "body2"
                    text: qsTr("Added Hardware?")
                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.margins: Theme.margin(2)
            spacing: Theme.margin(2)

            BarMeter {
                id: fluoroBarMeter
                Layout.fillWidth: true
                text: "Fluoro Movement"
                value: imageToolsViewModel.ffMeterValue
                visible: imageToolsViewModel.ffMeterVisible
                meterValid: imageToolsViewModel.ffMeterEnabled
            }

            BarMeter {
                id: drbBarMeter
                Layout.fillWidth: true
                text: "Patient Movement"
                value: imageToolsViewModel.drbMeterValue
                visible: imageToolsViewModel.drbMeterVisible
                // Note: intentionally tied to ffMeterEnabled for now. Fluoro
                // capture service is not sending drb movement updates if the
                // fixture is not visible.
                meterValid: imageToolsViewModel.drbMeterEnabled && imageToolsViewModel.ffMeterEnabled
            }
        }
    }

    DividerLine {
        orientation: Qt.Horizontal
        anchors { top: parent.top }
    }
}
