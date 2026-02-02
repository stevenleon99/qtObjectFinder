import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.15
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import "../../.."

Rectangle {
    width: 328
    height: 80

    property bool isSelected: false
    property bool isValid: false
    property real trackRms: 0.0
    property int trackNumber: 0
    property int trackSize: 0
    property real trackDuration: 0.0
    property string trackColor: Theme.navyLight

    signal deleteTrackPoints()

    color: isSelected?Theme.slate700:Theme.transparent
    border.color: isSelected?Theme.blue:Theme.transparent
    border.width: isSelected?2:1
    radius: 4

    Loader {
        active: isValid
        sourceComponent:

            ColumnLayout {
            id: c
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: Theme.margin(1)

            RowLayout {
                id: r
                Layout.topMargin: Theme.margin(2)
                Layout.fillWidth: true
                spacing: Theme.margin(1)

                IconImage {
                    id: crosshairIcon
                    source: "qrc:/images/multi-line.svg"
                    sourceSize: Theme.iconSize
                    color: trackColor
                }

                Label {
                    state: "subtitle2"
                    text: "Trace " + trackNumber
                    color: Theme.white
                }

                LayoutSpacer {}

                Label {
                    Layout.rightMargin: Theme.margin(1)
                    state: "subtitle2"
                    text: trackSize + "Pts. | " + trackDuration + " Secs."
                    color: Theme.navyLight
                }

                Button {
                    Layout.preferredWidth: 32
                    Layout.preferredHeight: 32
                    state: "icon"
                    font.bold: true
                    icon.source: "qrc:/icons/trash.svg"

                    onClicked: {
                        deleteTrackPoints()
                    }
                }
            }

            ValueMeter {
                id: valueMeter
                Layout.preferredWidth: 322
                Layout.preferredHeight: 8
                value: trackRms
                visible: isValid
                disabled: (trackRms < 0) ? true : false
                misc: false
            }
        }
    }

    DividerLine {
        anchors { bottom: parent.bottom }
        orientation: Qt.Horizontal
    }
}

