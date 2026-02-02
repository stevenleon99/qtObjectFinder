import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

Item {
    id: item
    Layout.preferredWidth: Theme.margin(4)
    Layout.preferredHeight: Theme.margin(4)

    property double score: 0

    readonly property int greenRegion: 8
    readonly property int yellowRegion: 4

    readonly property color color: {
        if (score >= greenRegion) {
            return Theme.green
        } else if (score >= yellowRegion) {
            return Theme.yellow
        } else if (score > 0) {
            return Theme.red
        } else {
            return Theme.white
        }
    }

    onScoreChanged: canvas.requestPaint()

    onColorChanged: canvas.requestPaint()

    onEnabledChanged: canvas.requestPaint()

    Label {
        anchors { centerIn: parent }
        state: "subtitle1"
        font { bold: true }
        text: parent.score
        horizontalAlignment: Label.AlignLeft
    }

    Canvas {
        id: canvas
        rotation: 270

        anchors { fill: parent }

        onPaint: {
            var ctx = getContext("2d")
            var x = width / 2
            var y = height / 2
            var startRadians = 0
            var endDegrees = 360
            var endRadians = (Math.PI / 180) * endDegrees
            var lineWidth = 4
            var lineRadius = (width / 2) - (lineWidth / 2)

            ctx.reset()
            ctx.beginPath()
            ctx.lineWidth = lineWidth
            ctx.strokeStyle = Theme.slate400
            ctx.arc(x, y, lineRadius, startRadians, endRadians, false)
            ctx.stroke()

            if (enabled) {
                ctx.beginPath()
                var currentDegrees = (parent.score / 10) * endDegrees
                currentDegrees = currentDegrees > endDegrees ? endDegrees : currentDegrees
                var currentRadians = (Math.PI / 180) * currentDegrees
                ctx.strokeStyle = parent.color
                ctx.arc(x, y, lineRadius, startRadians, currentRadians, false)
                ctx.stroke()
            }
        }
    }
}
