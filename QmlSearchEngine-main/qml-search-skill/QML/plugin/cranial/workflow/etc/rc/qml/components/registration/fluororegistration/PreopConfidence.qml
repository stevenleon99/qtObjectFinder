import QtQuick 2.10
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4
import QtQuick.Controls.impl 2.4

import Theme 1.0

Rectangle {
    visible: confidence >= 0// && preferenceManager.preferenceMap["showMergeScore"] === "true"
    antialiasing: true
    color: Theme.backgroundColor

    property int confidence

    property string level

    readonly property int confidenceMax: 10
    readonly property real confidenceRatio: confidence / confidenceMax

    readonly property double greenRegion: 0.8
    readonly property double yellowRegion: 0.4

    readonly property color confidenceColor: {
        if (confidenceRatio >= greenRegion) {
            return Theme.green
        } else if (confidenceRatio >= yellowRegion) {
            return Theme.yellow
        } else if (confidenceRatio > 0) {
            return Theme.red
        } else {
            return Theme.black
        }
    }
    property alias text: text

    Rectangle {
        anchors { fill: parent }
        color: confidence < 0? Theme.black : "#404040"
    }

    Rectangle {
        width: parent.width / 2
        height: width
        rotation: confidenceRatio * 360
        color: confidenceColor
        transformOrigin: Item.BottomRight
        smooth: true
        antialiasing: true
    }

    Rectangle {
        visible: confidence < (0.25 * confidenceMax)
        width: parent.width / 2
        height: width
        color: confidence < 0? Theme.black : "#404040"
    }

    Rectangle {
        visible: confidence > (0.25 * confidenceMax)
        x: width
        width: parent.width / 2
        height: width
        color: confidenceColor
    }

    Rectangle {
        visible: confidence > (0.5 * confidenceMax)
        x: width
        y: width
        width: parent.width / 2
        height: width
        color: confidence < 0? Theme.black :confidenceColor
    }

    Rectangle {
        visible: confidence > (0.75 * confidenceMax)
        y: width
        width: parent.width / 2
        height: width
        color: confidence < 0? Theme.black :confidenceColor
    }

    Rectangle {
        width: (parent.width * 0.8) + 1
        height: width
        radius: width / 2
        anchors { centerIn: parent }
        color: parent.color
    }

    Rectangle {
        width: parent.width + (border.width * 2)
        height: width
        radius: width / 2
        anchors { centerIn: parent }
        border { width: parent.width / 4; color: parent.color }
        color: "transparent"
    }

    Label {
        id: text
        anchors { centerIn: parent }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        state: "caption"
        text: confidence < 0? "-" : confidence
    }
}
