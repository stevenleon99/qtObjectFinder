import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

import Enums 1.0

import "../draggedcad"

Rectangle {
    id: implantItem
    enabled: trajectoryAvailable
    radius: 4
    border { width: 2; color: selected ? Theme.blue : Theme.lineColor }
    color: Theme.backgroundColor
    opacity: enabled ? 1.0 : 0.0

    property bool selected: false
    property bool dragEnabled: false
    property bool trajectoryAvailable: false
    property string trajectoryName
    property string trajectoryAngle
    property int status: TrajectoryStatus.Unplanned
    property int type: TrajectoryType.Fixation
    property color instrumentSetColor: Theme.white
    property string reachStatusDisplayString
    property color reachStatusDisplayColor
    property string reachStatusDisplayIcon
    property bool reachabilityEnabled: false
    property bool constructMeasuresEnabled: false
    property bool planReversed: false

    signal clicked()
    signal startDrag()
    signal endDrag()

    states: [
        State {
            when: reachabilityEnabled
            PropertyChanges { target: implantItem; border.color: selected ? Theme.blue : reachStatusDisplayColor }
            PropertyChanges { target: implantStateIcon; source: reachStatusDisplayIcon; color: reachStatusDisplayColor }
            PropertyChanges { target: aboveIcon; visible: false }
            PropertyChanges { target: reachText; visible: true; text: reachStatusDisplayString; color: reachStatusDisplayColor; font.bold: false }
            PropertyChanges { target: rowLayout; Layout.alignment: Qt.AlignVCenter | Qt.AlignLeft }
            PropertyChanges { target: rowLayout; Layout.bottomMargin: 0 }

        },
        State {
            when: constructMeasuresEnabled && type == TrajectoryType.Fixation
            PropertyChanges { target: angleText; visible: true }
            PropertyChanges { target: rowLayout; Layout.bottomMargin: 0 }
        }
    ]

    Rectangle {
        visible: selected
        opacity: 0.16
        anchors { fill: parent }
        radius: parent.radius
        color: Theme.blue
    }

    ColumnLayout {
        id: container
        objectName: "implantItemContainer_" + trajectoryName
        anchors{ left: parent.left; leftMargin: Theme.margin(1); right: parent.right; rightMargin: Theme.margin(1); topMargin: 8; margins: 8 }
        spacing: 0

        RowLayout {
            id: rowLayout
            Layout.topMargin: Theme.margin(1)
            Layout.bottomMargin: Theme.margin(1)
            Layout.alignment: Qt.AlignHCenter
            spacing: Theme.margin(1)

            IconImage {
                id: implantStateIcon
                objectName: "implantStateIcon"
                source: implantIcon()
                sourceSize: Theme.iconSize
                color: selected ? Theme.blue : Theme.lineColor

                function implantIcon() {
                    switch(type) {
                    case TrajectoryType.Fixation:
                    {
                        if((implantItem.status === TrajectoryStatus.Placed) || planReversed)
                            return "qrc:/icons/screw-done-screw"
                        else if (implantItem.status === TrajectoryStatus.Planned)
                            return "qrc:/icons/screw-planned"
                        else
                            return "qrc:/icons/screw-unplanned"
                    }
                    case TrajectoryType.Interbody:
                    {
                        if(implantItem.status === TrajectoryStatus.Placed)
                            return "qrc:/icons/interbody-done-implant"
                        else if (implantItem.status === TrajectoryStatus.Planned)
                            return "qrc:/icons/interbody-planned"
                        else
                            return "qrc:/icons/interbody-unplanned"
                    }
                    case TrajectoryType.Generic:
                    {
                        if(implantItem.status === TrajectoryStatus.Placed)
                            return "qrc:/icons/trajectory-done-no-check.svg"
                        else if (implantItem.status === TrajectoryStatus.Planned)
                            return "qrc:/icons/trajectory-planned.svg"
                        else
                            return "qrc:/icons/trajectory-unplanned.svg"
                    }
                    }
                }

                IconImage {
                    id: aboveIcon
                    visible: (implantItem.status === TrajectoryStatus.Placed) || planReversed
                    source: {
                        if (type == TrajectoryType.Interbody) {
                            return "qrc:/icons/interbody-done-check"
                        } else {
                            if (type == TrajectoryType.Fixation && planReversed)
                                return "qrc:/icons/screw-alert-above"
                            else
                                return "qrc:/icons/screw-done-check"
                        }
                    }
                    sourceSize: Theme.iconSize
                    color: planReversed ? Theme.yellow500 : Theme.green
                }
            }
            
            Label {
                id: implantText
                state: "h6"
                font.bold: true
                text: trajectoryName
            }
        }

        Label {
            id: angleText
            visible: false
            Layout.bottomMargin: Theme.margin(1)
            Layout.alignment: Qt.AlignHCenter
            state: "body1"
            font.bold: true
            text: trajectoryAngle + "°"
            elide: Text.ElideNone
        }

        RowLayout {
            spacing: Theme.margin(1)
            IconImage {
                id: spacerIcon
                visible: reachText.visible
                color: Theme.transparent
                sourceSize: Theme.iconSize
                source: reachStatusDisplayIcon
                opacity: 0

            }
            Label {
                id: reachText
                visible: false
                Layout.bottomMargin: Theme.margin(1)
                Layout.alignment: Qt.AlignLeft
                state: "body1"
                elide: Text.ElideNone
            }
        }
    }

    DraggedCadMouseArea {
        anchors { fill: parent }
        dragEnabled: implantItem.dragEnabled

        onTrajectoryPressed: parent.clicked()

        onStartDrag: parent.startDrag()

        onEndDrag: parent.endDrag()
    }
}
