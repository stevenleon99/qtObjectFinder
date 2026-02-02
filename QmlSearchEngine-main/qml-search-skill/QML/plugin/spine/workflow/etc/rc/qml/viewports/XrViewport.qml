/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
import QtQuick 2.12
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import ViewportEnums 1.0
import Enums 1.0
import GmQml 1.0
import "../viewports"
import "../overlays"

Item {
    id: xrViewportOverlay
    signal expandButtonClicked();
    
    property var viewportUid

    Rectangle {
        anchors { fill: parent }
        color: Theme.black
    }

    XrViewModel {
        id: xrViewModel
    }

    Component.onCompleted: {
        xrViewModel.init(viewportUid)
    }

    ColumnLayout {

        id: layout
        height: parent.height
        anchors { fill: parent;  topMargin: 4; bottomMargin: 4}

        RowLayout {

            id: headerLayout
            Layout.fillHeight: false
            Layout.fillWidth: true


            Item {
                width: rowLayout.width
                height: Theme.margin(5)
                Layout.leftMargin: Theme.marginSize

                Rectangle {
                    opacity: 0.16
                    radius: 4
                    anchors { fill: parent }
                    color: orientationPopup.visible ? Theme.blue : Theme.transparent
                }

                RowLayout {
                    id: rowLayout
                    spacing: 0

                    View2DOrientationPopup {
                        id: orientationPopup
                        visible: false
                        viewportUuid: viewportUid
                    }

                    Label {
                        id: label
                        Layout.preferredHeight: Theme.margin(5)
                        leftPadding: Theme.margin(1)
                        state: "subtitle2"
                        color: Theme.white
                        text: "XR Feed"
                        verticalAlignment: Text.AlignVCenter

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                if (orientationPopup.isVolumeView && !orientationPopup.visible) {
                                    orientationPopup.setup(this)
                                }
                            }
                        }
                    }

                    IconImage {
                        sourceSize: Theme.iconSize
                        source: "qrc:/icons/caret-down"
                        color: orientationPopup.visible ? Theme.blue : Theme.white

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                if (orientationPopup.isVolumeView && !orientationPopup.visible) {
                                    orientationPopup.setup(label)
                                }
                            }
                        }
                    }
                }
            }
        
            ComboBox {
                id: headsetAssignment
                Layout.preferredWidth: 235
                Layout.leftMargin:0
                Layout.rightMargin: 0
                model: xrViewModel.headsetAssignmentModel
                currentIndex: xrViewModel.activeHeadsetFeedType
                onCurrentIndexChanged: xrViewModel.selectFeed(currentIndex)
            }

            LayoutSpacer {}

            ComboBox {
                id: headsetLayoutSelector
                Layout.preferredWidth: 140
                Layout.leftMargin: 0
                Layout.rightMargin: 0
                textRole: "text"
                currentIndex: xrViewModel.headsetLayout

                model: ListModel {
                    id: layoutModel
                    ListElement { text: qsTr("Disp: None"); value: HeadsetLayout.None }
                    ListElement { text: qsTr("Disp: 2D"); value: HeadsetLayout.TwoDOnly }
                    ListElement { text: qsTr("Disp: 3D"); value: HeadsetLayout.ThreeDOnly }
                    ListElement { text: qsTr("Disp: 2D+3D"); value: HeadsetLayout.TwoDAndThreeD }
                }

                onCurrentIndexChanged: xrViewModel.headsetLayout = layoutModel.get(currentIndex).value

                Connections {
                    target: xrViewModel
                    onHeadsetLayoutChanged: headsetLayoutSelector.currentIndex = xrViewModel.headsetLayout
                }
            }

            Button {
                height: 48
                width: 48
                icon.source: xrViewModel.handInteractionEnabled ? "qrc:/icons/hand.svg" : "qrc:/icons/hand-off.svg"
                state: "icon"
                onClicked: xrViewModel.handInteractionEnabled = !xrViewModel.handInteractionEnabled
            }

            Button {
                height: 48
                width: 48
                icon.source: "qrc:/icons/refresh.svg"
                state: "icon"
                onClicked: xrViewModel.resetHeadsetZoom()
            }

            Button {
                height: 48
                width: 48
                icon.source: "qrc:/icons/expand.svg"
                state: "icon"
                onClicked: xrViewModel.toggleFullScreen()
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.preferredWidth: parent.width
            Layout.margins: 0

            RowLayout {
                anchors { fill: parent }

                Repeater {
                    model: xrViewModel.getVideoFeedsVariantList(headsetAssignment.currentIndex)
                    delegate: Item {  
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        property var feedVisualizer: modelData
                        property bool connected: feedVisualizer.connected
                        property bool showFeed: connected

                        onConnectedChanged: {
                            if (connected) {
                                timer.stop();
                                showFeed = true;
                            }
                            else {
                                timer.start();
                            }
                        }

                        //Check if the feed is connected every 100ms
                        Timer {
                            id: timer
                            triggeredOnStart: false
                            interval: 100

                            onTriggered: showFeed = connected
                        }

                        Label {
                            visible: !showFeed
                            Layout.alignment: Qt.AlignHCenter
                            text : qsTr("No headset feed detected")
                            state: "body1"
                            color: Theme.disabledColor
                            anchors { centerIn: parent }
                        }

                        Image {
                            id: imageFeed
                            visible: showFeed
                            anchors { fill: parent }
                            fillMode: height > sourceSize.height ? Image.Pad : Image.PreserveAspectFit
                            cache: false
                            Connections {
                                target: feedVisualizer
                                onFrameChanged: {
                                    imageFeed.source = "image://headsetfeed/" + index + "/" + feedVisualizer.frame
                                }
                            }
                        }

                        MouseArea {
                            anchors.centerIn: parent
                            enabled: showFeed
                            hoverEnabled: true
                            width: imageFeed.paintedWidth
                            height: imageFeed.paintedHeight

                            onPositionChanged: { handleMouseEvent(mouse) }
                            onPressed: { handleMouseEvent(mouse) }
                            onReleased: { handleMouseEvent(mouse) }

                            function handleMouseEvent(mouse) {
                                mouse.accepted = true;
                                feedVisualizer.onMouseEvent(mouse.buttons & Qt.LeftButton, mouse.x / width, mouse.y / height);
                            }
                        }
                    }
                }
            }
        }
    }

    ViewportBorderOverlay
    {   
        anchors.fill: parent
    }
}