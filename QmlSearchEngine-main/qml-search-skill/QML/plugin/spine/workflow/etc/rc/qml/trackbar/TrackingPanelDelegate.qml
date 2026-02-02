import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0

import "../components"

RowLayout {
    id: trackingPanelDelegate
    spacing: -visibilityIcon.width / 2

    property bool active: false
    property bool trackingValid: false
    property bool displayArrayInfo: false
    property bool displayArrayIndex: false
    property bool displayContent: true
    property bool barActive: false
    property bool overrideBarTracking: false
    property color arrayColor: "#FF0000"
    property int arrayIndex
    property string rotationPosition: ""
    property string infoText: ""

    property alias source: image.source
    property alias objectName: label.text
    property alias barText: bar.text
    property alias barValue: bar.value
    property alias barClearable: bar.clearable
    property alias barPlusButtonEnabled: bar.plusButtonEnabled
    property alias statusIconVisible: statusIcon.visible
    property alias statusIconPath: statusIcon.source
    property alias statusIconColor: statusIcon.color
    property alias barDisplayed: bar.visible

    readonly property color delegateColor: {
        if (active && displayContent) {
            if (trackingValid) {
                return Theme.green;
            } else {
                return Theme.red;
            }
        }
        else {
            return Theme.navy;
        }
    }
    
    signal cleared()
    signal plusButtonClicked()
    signal rotationPositionClicked()

    Rectangle {
        id: visibilityIcon
        Layout.preferredWidth: Theme.margin(4)
        Layout.preferredHeight: Layout.preferredWidth
        z: 100
        radius: Layout.preferredWidth / 2
        color: Theme.backgroundColor

        Rectangle {
            opacity: active ? 1.0 : 0.32
            anchors { fill: parent }
            radius: parent.radius
            color: displayContent ? delegateColor : Theme.backgroundColor
            border.color: delegateColor


            IconImage {
                visible: displayContent
                anchors { centerIn: parent }
                sourceSize: Qt.size(parent.width, parent.height)
                source: trackingValid ? "qrc:/icons/visibility-on" : "qrc:/icons/visibility-off"
                color: Theme.black
            }
        }
    }

    Rectangle {
        opacity: active ? 1.0 : 0.32
        Layout.preferredWidth: layout.width + Theme.margin(2)
        Layout.preferredHeight: layout.height

        radius: 4
        border { color: delegateColor }
        color: Theme.transparent

        RowLayout {
            id: layout
            anchors { centerIn: parent }

            RowLayout {
                Layout.minimumWidth: Theme.margin(38)
                Layout.minimumHeight: Theme.margin(6)
                spacing: Theme.margin(1)

                IconImage {
                    id: image
                    visible: displayContent
                    Layout.leftMargin: Theme.margin(1.5)
                    sourceSize: Theme.iconSize
                    color: arrayColor

                    Label {
                        id: arrayLabel
                        visible: displayArrayIndex
                        anchors {centerIn: parent}
                        text: arrayIndex
                        state: "body1"
                    }
                }

                RowLayout {
                    visible: displayContent
                    spacing: 0

                    Label {
                        id: label
                        Layout.maximumWidth: Theme.margin(19)
                        state: "body1"
                        font.bold: true
                    }

                    LayoutSpacer {}

                    BarMeter {
                        id: bar
                        Layout.leftMargin: Theme.margin(1)
                        meterValid: {
                            // ignore bar meter active and tracking valid if the tracking item is inactive to display correct opacity
                            if (active)
                            {
                                return ((overrideBarTracking || trackingValid) && barActive)
                            }
                            return true
                        }

                        onCleared: trackingPanelDelegate.cleared()
                        onPlusButtonClicked: trackingPanelDelegate.plusButtonClicked()
                    }
                }

                IconImage {
                    id: statusIcon
                    sourceSize: Theme.iconSize
                }

                IconButton {
                    id: infoButton
                    visible: displayContent && infoText
                    enabled: trackingPanelDelegate.active
                    icon.source: "qrc:/icons/info-circle-fill.svg"
                    active: infoBubble.visible

                    onPressed: {
                        if (!infoBubble.visible)
                            infoBubble.setup(infoButton)
                    }

                    onVisibleChanged: {
                        if (infoBubble.visible)
                            infoBubble.close()
                    }
                }

                InfoBubble {
                    id: infoBubble
                    text: infoText

                    onWidthChanged: {
                        if (visible && infoText)
                            setup(infoButton)
                    }
                }

                Rectangle {
                    id: rotationPositionBox
                    visible: displayContent && rotationPosition
                    Layout.preferredWidth: Theme.margin(3)
                    Layout.preferredHeight: Layout.preferredWidth
                    color: Theme.transparent
                    border { width: 1; color: Theme.navy }
                    radius: 4

                    Label {
                        text: rotationPosition
                        state: "body1"
                        anchors {centerIn: parent}
                    }

                    MouseArea {
                        anchors { fill: parent }
                        onClicked: rotationPositionClicked()
                    }
                }
            }
        }
    }

    onActiveChanged: {
        if (!active && infoBubble.visible)
            infoBubble.close()
    }
}
