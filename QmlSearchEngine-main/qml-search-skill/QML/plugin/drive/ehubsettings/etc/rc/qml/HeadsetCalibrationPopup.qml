import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

Popup {
    id: progressValueDialog
    visible: true
    closePolicy: Popup.NoAutoClose

    Rectangle {
        id: container
        width: Theme.margin(143)
        height: contentColumn.height + (Theme.marginSize * 4)
        anchors { centerIn: parent }
        radius: 8
        color: Theme.foregroundColor

        ColumnLayout {
            id: contentColumn
            width: container.width - Theme.margin(8)
            anchors { centerIn: parent }
            spacing: Theme.margin(2)

            Label {
                Layout.fillWidth: true
                elide: Text.ElideRight
                state: "body2"
                font.styleName: Theme.mediumFont.styleName
                color: Theme.navyLight
                text: headsetCalibrationViewModel.curHeadsetTypeStr
            }

            RowLayout {
                Layout.fillWidth: true
                Label {
                    id: statusLabel
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    state: "h4"
                    font.bold: true
                    text: headsetCalibrationViewModel.calState
                }
                Label {
                    visible: progressBar.visible
                    elide: Text.ElideRight
                    state: "h4"
                    font.styleName: Theme.mediumFont.styleName
                    color: Theme.navyLight
                    text: progressBar.value + "/" + progressBar.to + " Images"
                }
            }

            Label {
                id: calStatusLabel
                Layout.fillWidth: true
                visible: !(headsetCalibrationViewModel.calInProgress ||
                    headsetCalibrationViewModel.successfulCompletion)
                elide: Text.ElideRight
                state: "subtitle1"
                color: Theme.navyLight
                text: headsetCalibrationViewModel.calStatus
            }

            ProgressBar {
                id: progressBar
                visible: headsetCalibrationViewModel.numImgSaved > 0 ||
                    headsetCalibrationViewModel.calInProgress
                padding: Theme.margin(1)
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(3)
                from: 0
                to: headsetCalibrationViewModel.reqdNumImages
                value: headsetCalibrationViewModel.numImgSaved
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(90)
                radius: 4
                color: Theme.black

                RowLayout {
                    anchors { fill: parent; margins: 6 }
                    spacing: 6

                    Repeater {
                        model: headsetCalibrationViewModel.getVideoFeedsVariantList(headsetCalibrationViewModel.headsetType)
                        delegate: Item {
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            property var feedVisualizer: modelData
                            property bool connected: feedVisualizer.connected

                            Label {
                                visible: !connected
                                Layout.alignment: Qt.AlignHCenter
                                text : qsTr("No headset feed detected")
                                state: "body1"
                                color: Theme.disabledColor
                                anchors { centerIn: parent }
                            }

                            Image {
                                id: imageFeed
                                visible: connected
                                anchors { fill: parent }
                                fillMode: height > sourceSize.height ? Image.Pad : Image.PreserveAspectFit
                                cache: false
                                Connections {
                                    target: feedVisualizer
                                    onFrameChanged: {
                                        imageFeed.source = "image://headsetfeedprovider/" + index + "/" + feedVisualizer.frame
                                    }
                                }
                            }
                        }
                    }
                }
            }

            RowLayout {
                Layout.alignment: Qt.AlignRight
                Button {
                    id: exportResultsButton
                    Layout.alignment: Qt.AlignLeft
                    state: "active"
                    enabled: headsetCalibrationViewModel.allowExport
                    text: headsetCalibrationViewModel.exportMessage
                    onClicked: {
                        headsetCalibrationViewModel.exportResults();
                    }
                }

                Button {
                    id: extendCalibrationButton
                    Layout.alignment: Qt.AlignRight
                    state: "active"
                    enabled: headsetCalibrationViewModel.canExtendCalibration
                    visible: headsetCalibrationViewModel.canExtendCalibration
                    text: qsTr("Collect Additional Images")
                    onClicked: {
                        headsetCalibrationViewModel.extendCalibration();
                    }
                }

                Button {
                    id: calActionButton
                    Layout.alignment: Qt.AlignRight
                    state: "active"
                    text: qsTr(headsetCalibrationViewModel.calInProgress ? "Cancel" : "Close")
                    property bool forceClose: false
                    onClicked:{
                        if (headsetCalibrationViewModel.calInProgress) {
                            statusLabel.text = qsTr("Cancelling...");
                        }
                        headsetCalibrationViewModel.calActionButton(forceClose);
                        state = "disabled";
                        timer.restart();
                    }

                    // Give some time for SH to process the cancel request before allowing another retry
                    Timer {
                        id: timer
                        interval: 2000
                        running: false
                        repeat: false
                        onTriggered: {
                            calActionButton.state = "active";
                            calActionButton.forceClose = true;
                            calActionButton.text = qsTr("Close");
                            statusLabel.text = qsTr("Cancellation Failed");
                            calStatusLabel.text = qsTr("Please close the dialog and perform a software reset");
                        }
                    }
                }
            }
        }
    }
}
