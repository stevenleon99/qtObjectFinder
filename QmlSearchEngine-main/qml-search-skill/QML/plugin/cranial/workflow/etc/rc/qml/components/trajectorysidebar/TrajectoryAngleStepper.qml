import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Rectangle {
    id: angleStepper
    Layout.preferredHeight: Theme.marginSize * 5
    Layout.fillWidth: true
    radius: 4
    border { width: 1; color: Theme.lineColor }
    color: Theme.backgroundColor

    property real value
    property string valueLabel

    property bool enableValue: true
    property bool absolute: false
    property bool enableArrows: true

    signal increaseClicked()
    signal decreaseClicked()
    signal labelClicked()

    states: [
        State {
            name: "Coronal"
            PropertyChanges { target: icon; source: "qrc:/images/cranial-head-front.svg" }
            PropertyChanges { target: canvas; angleStart: Math.PI / 2 }
        },
        State {
            name: "Sagittal"
            PropertyChanges { target: icon; source: "qrc:/images/cranial-head-side.svg" }
            PropertyChanges { target: canvas; angleStart: 0 }
        }
    ]

    RowLayout {
        anchors { centerIn: parent }
        spacing: -Theme.marginSize / 2

        Button {
            visible: enabled
            enabled: enableArrows
            Layout.alignment: Qt.AlignVCenter
            rotation: 180
            icon.source: "qrc:/icons/arrow-small.svg"
            color: Theme.navyLight
            state: "icon"

            onClicked: decreaseClicked()
        }

        Image {
            id: icon

            ColumnLayout {
                anchors { centerIn: parent }

                Canvas {
                    id: canvas
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: 34
                    Layout.preferredHeight: 19

                    property real angleStart
                    property real arcStart: angleStart + Math.PI
                    property real arcEnd: enableValue ? angleStart + (180 + value) * (Math.PI / 180) : arcStart
                    property real angleBar

                    onArcEndChanged: requestPaint()

                    onPaint: {
                        var barHeight = 2
                        var barWidth = width - 2

                        var arcRadius = height - barHeight - 1
                        var arcCenter = Qt.vector2d(width / 2, height - barHeight)

                        var ctx = getContext("2d")
                        ctx.reset()
                        ctx.beginPath()
                        ctx.moveTo(arcCenter.x, arcCenter.y)
                        ctx.fillStyle = Theme.blue
                        ctx.arc(arcCenter.x, arcCenter.y, arcRadius, arcStart, arcEnd, arcEnd < arcStart)
                        ctx.closePath()
                        ctx.fill()

                        ctx.fillStyle = Theme.lineColor
                        ctx.fillRect(1, height - barHeight, barWidth, barHeight)

                        ctx.beginPath()
                        ctx.moveTo(width / 2, height - 1)
                        ctx.lineTo(width / 2 - arcRadius * Math.cos(angleStart),
                                   height - 1 - arcRadius * Math.sin(angleStart))
                        ctx.strokeStyle = Theme.white
                        ctx.lineWidth = 2
                        ctx.stroke()
                    }
                }

                Label {
                    Layout.alignment: Qt.AlignHCenter
                    state: "h6"
                    text: enableValue ? displayValue + valueLabel : "---"

                    readonly property string displayValue: (absolute ? Math.abs(value) : value).toFixed(1)
                }
            }

            MouseArea {
                anchors { fill: parent }

                onClicked: labelClicked()
            }
        }

        Button {
            visible: enabled
            enabled: enableArrows
            Layout.alignment: Qt.AlignVCenter
            icon.source: "qrc:/icons/arrow-small.svg"
            color: Theme.navyLight
            state: "icon"

            onClicked: increaseClicked()
        }
    }
}
