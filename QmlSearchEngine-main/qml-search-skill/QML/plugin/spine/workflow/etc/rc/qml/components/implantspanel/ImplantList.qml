import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

ListView {
    objectName: "implantList" 
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.margin(34)
    Layout.leftMargin: Theme.margin(2)
    Layout.bottomMargin: Theme.margin(2)
    Layout.rightMargin: scrollBar.visible ? 0 : Theme.margin(2)
    spacing: Theme.margin(2)
    interactive: false
    clip: true
    headerPositioning: ListView.OverlayHeader

    property ImplantListViewModel implantPlanNavListVM

    ScrollBar.vertical: ScrollBar {
        id: scrollBar
        anchors { right: parent.right; bottom: parent.bottom }
        visible: parent.contentHeight > parent.height
    }

    model: implantPlanNavListVM.implantList

    header: Rectangle {
        id: header
        visible: implantPlanNavListVM.constructMeasuresEnabled
        width: parent.width - (scrollBar.visible ? scrollBar.width : 0)
        height: implantPlanNavListVM.constructMeasuresEnabled ? Theme.margin(8) : 0
        z: 2
        color: Theme.backgroundColor

        RodLengthMeasurements {
            anchors { top: parent.top; left: parent.left }

            leftRodLength: Math.round(implantPlanNavListVM.leftRodLength * 100) / 100
            rightRodLength: Math.round(implantPlanNavListVM.rightRodLength * 100) / 100
        }

        DividerLine {
            orientation: Qt.Horizontal
            anchors { bottom: parent.bottom; bottomMargin: 16 }
        }
    }

    delegate: Item {
        id: listItem
        width: parent.width - (scrollBar.visible ? scrollBar.width : 0)
        height: ((implantPlanNavListVM.constructMeasuresEnabled && fixationItem) || (implantPlanNavListVM.reachabilityEnabled)) ? Theme.margin(9) : Theme.margin(6)

        property bool fixationItem: role_leftImplantProperties.trajectoryType == TrajectoryType.Fixation ||
                                    role_rightImplantProperties.trajectoryType == TrajectoryType.Fixation

        RowLayout {
            id: row
            anchors { fill: parent }
            spacing: Theme.marginSize

            ImplantItem {
                id: leftImplant

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 35

                trajectoryAvailable: role_leftImplantProperties.trajectoryAvailable
                trajectoryName: role_leftImplantProperties.trajectoryName
                trajectoryAngle: Math.round(role_leftImplantProperties.trajectoryAngle * 100) / 100
                selected: role_leftImplantProperties.trajectorySelected
                status: role_leftImplantProperties.trajectoryStatus
                type: role_leftImplantProperties.trajectoryType
                reachStatusDisplayString: role_leftImplantProperties.reachStatusDisplayString
                reachStatusDisplayColor: role_leftImplantProperties.reachStatusDisplayColor
                reachStatusDisplayIcon: role_leftImplantProperties.reachStatusDisplayIcon
                reachabilityEnabled: implantPlanNavListVM.reachabilityEnabled
                constructMeasuresEnabled: implantPlanNavListVM.constructMeasuresEnabled
                dragEnabled: implantPlanNavListVM.dragEnabled
                planReversed: role_levelPlanReversed

                onClicked: selected ? implantPlanNavListVM.deselectTrajectory() : implantPlanNavListVM.selectTrajectory(role_leftImplantProperties.levelSelector)

                onStartDrag: implantPlanNavListVM.startImplantDrag(role_leftImplantProperties.levelSelector)

                onEndDrag: implantPlanNavListVM.endImplantDrag()
            }

            ImplantMeasurements {
                visible: implantPlanNavListVM.constructMeasuresEnabled && listItem.fixationItem
                opacity: role_leftImplantProperties.trajectoryAvailable &&
                         role_rightImplantProperties.trajectoryAvailable ? 1.0 : 0.0

                Layout.preferredWidth: 8
                screwDistance: Math.round(role_interScrewDistance * 100) / 100 
            }

            ImplantItem {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.preferredWidth: 35

                visible: role_rightImplantProperties.trajectoryAvailable || role_leftImplantProperties.trajectoryType == TrajectoryType.Fixation

                trajectoryAvailable: role_rightImplantProperties.trajectoryAvailable
                trajectoryName: role_rightImplantProperties.trajectoryName
                trajectoryAngle: Math.round(role_rightImplantProperties.trajectoryAngle * 100) / 100
                selected: role_rightImplantProperties.trajectorySelected
                status: role_rightImplantProperties.trajectoryStatus
                type: role_rightImplantProperties.trajectoryType
                reachStatusDisplayString: role_rightImplantProperties.reachStatusDisplayString
                reachStatusDisplayColor: role_rightImplantProperties.reachStatusDisplayColor
                reachStatusDisplayIcon: role_rightImplantProperties.reachStatusDisplayIcon
                reachabilityEnabled: implantPlanNavListVM.reachabilityEnabled
                constructMeasuresEnabled: implantPlanNavListVM.constructMeasuresEnabled
                dragEnabled: implantPlanNavListVM.dragEnabled
                planReversed: role_levelPlanReversed

                onClicked: selected ? implantPlanNavListVM.deselectTrajectory() : implantPlanNavListVM.selectTrajectory(role_rightImplantProperties.levelSelector)

                onStartDrag: implantPlanNavListVM.startImplantDrag(role_rightImplantProperties.levelSelector)

                onEndDrag: implantPlanNavListVM.endImplantDrag()
            }
        }
    }
    DescriptiveBackground {
        visible: parent.count === 0
        anchors { centerIn: parent }
        source: "qrc:/icons/toolbox"
        text: qsTr("Verify Implants.") 
    }
}
