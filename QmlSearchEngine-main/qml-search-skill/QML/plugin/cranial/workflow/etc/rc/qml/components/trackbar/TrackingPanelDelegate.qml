import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0
import Enums 1.0

RowLayout {
    id: trackingPanelDelegate
    spacing: -visibilityIcon.width / 2
    Layout.preferredWidth: 320
    Layout.preferredHeight: 48

    opacity: enabled? 1 : .32

    property int visibilityStatus: ToolVisibilityStatus.NoVisible

    property bool trackingValid: visibilityStatus == ToolVisibilityStatus.Visible
    property bool isInitializing: false
    property bool hasConnection: false
    property bool enabled: true

    property alias source: image.source
    property alias objectName: label.text
    property alias barText: bar.text
    property alias barValue: bar.value
    property alias barClearable: bar.clearable
    property alias barVisible: bar.visible
    property alias barEnabled: bar.enabled
    property alias barPlusButtonEnabled: bar.plusButtonEnabled

    property alias transferVisible: transferButton.visible

    property alias connectionSource: connectImage.source
    property alias connectionColor: connectImage.color

    property color borderColor: {
        if (!enabled) return Theme.navy
        else{
            if (visibilityStatus == ToolVisibilityStatus.Visible) return Theme.green
            else if (visibilityStatus == ToolVisibilityStatus.NoVerified) return Theme.yellow
            else if (visibilityStatus == ToolVisibilityStatus.NoCalibration) return Theme.yellow
            else return Theme.red
        }
    }

    signal cleared()
    signal plusButtonClicked()
    signal clicked()

    MouseArea {
        anchors { fill: parent }

        onClicked: trackingPanelDelegate.clicked()
    }

    Rectangle {
        id: visibilityIcon
        Layout.preferredWidth: Theme.margin(4)
        Layout.preferredHeight: Layout.preferredWidth
        z: 100
        radius: Layout.preferredWidth / 2
        color: borderColor

        IconImage {
            visible: true
            anchors { centerIn: parent }
            sourceSize: Qt.size(parent.width, parent.height)
            source: trackingValid ? "qrc:/icons/visibility-on" : "qrc:/icons/visibility-off"
            color: Theme.black
        }
    }

    Rectangle {
        Layout.preferredWidth: 320
        Layout.preferredHeight: 48
        radius: 4
        border { width: 2; color: borderColor }
        color: Theme.transparent

        RowLayout {
            id: layout
            RowLayout {

                Layout.leftMargin: Theme.margin(3)
                Layout.topMargin: 8
                spacing: Theme.margin(1)
                Image {
                    id: image
                    sourceSize: Theme.iconSize
                }

                Rectangle {
                    Layout.minimumWidth: Theme.margin(4)
                    Layout.preferredHeight: Theme.margin(3)
                    color: Theme.transparent

                    Label {
                        id: label
                        state: "body1"
                        font.bold: true
                    }
                }
            }

            RowLayout {
                spacing: Theme.margin(1)
                Layout.rightMargin: Theme.margin(1)

                BarMeter {
                    id: bar
                    Layout.preferredWidth: 144
                    Layout.topMargin: 8
                    Layout.leftMargin: connectImage.visible || transferButton.visible || busyIndicator.visible ? 25 : 60
                    onCleared: trackingPanelDelegate.cleared()
                    onPlusButtonClicked: trackingPanelDelegate.plusButtonClicked()
                }

                IconImage {
                    id: transferButton
                    visible: transferVisible
                    Layout.topMargin: 8
                    Layout.leftMargin: bar.visible? Theme.margin(0) : 177
                    sourceSize: Theme.iconSize
                    source: "qrc:/icons/NewWindow.svg"

                    MouseArea {
                        anchors { fill: parent }

                        onClicked: transferPopup.visible = true
                    }

                    TransferPopup {
                        id: transferPopup
                        visible: false
                    }
                }

                Rectangle {
                    visible: true
                    Layout.preferredWidth: Theme.margin(4)
                    Layout.preferredHeight: Layout.preferredWidth
                    Layout.leftMargin: bar.visible ? Theme.margin(0) : 177
                    Layout.topMargin: 8
                    color: Theme.transparent

                    IconImage {
                        id: connectImage
                        visible: hasConnection && !isInitializing
                        anchors { centerIn: parent }
                        sourceSize: Theme.iconSize
                    }

                    BusyIndicator {
                        id: busyIndicator
                        visible: isInitializing
                        width: Theme.iconSize.width
                        height: Theme.iconSize.height
                        anchors { centerIn: parent }
                    }
                }
            }
        }
    }
}
