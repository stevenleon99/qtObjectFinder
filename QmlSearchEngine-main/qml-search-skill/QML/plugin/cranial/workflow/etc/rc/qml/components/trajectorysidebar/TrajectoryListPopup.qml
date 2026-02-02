import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQml.Models 2.2

import Theme 1.0
import ViewModels 1.0

import ".."

Popup {
    id: popup
    height: rectangle.height
    dim: false

    property var selectedId
    property alias model: visualModel.model
    readonly property alias count: trajectoryList.count

    signal itemSelected(string id)
    signal itemMoved(string id, int position)

    background: Rectangle { radius: Theme.margin(1); color: Theme.backgroundColor }

    function setup(positionItem) {
        var topRight = positionItem.mapToItem(null, 0, positionItem.height)
        x = topRight.x
        y = topRight.y
        open()
    }

    Rectangle {
        id: rectangle
        width: popup.width
        height: trajectoryList.count * Theme.margin(6)

        color: Theme.slate700
        radius: 4

        ListView{
            id: trajectoryList
            anchors.fill: parent
            model: visualModel
            boundsBehavior: Flickable.StopAtBounds

            moveDisplaced: Transition {
                NumberAnimation{
                    properties: "x,y"
                    duration: 200
                }
            }
        }

        DelegateModel {
            id: visualModel
            delegate: trajectoryDelegate
        }

        Component {
            id: trajectoryDelegate

            MouseArea {
                id: dragArea

                width: popup.width
                height: Theme.marginSize * 3

                property bool held: false

                drag.target: held ? content : undefined
                drag.axis: Drag.YAxis
                drag.minimumY: height
                drag.maximumY: trajectoryList.height - height

                onPressAndHold: {
                    // skip dragging "none" element in list model
                    if (index > 0)
                        held = true
                }

                onClicked: {
                    itemSelected(role_id)
                    close()
                }

                onReleased: {
                    if(held) {
                        held = false
                        itemMoved(role_id, dragArea.DelegateModel.itemsIndex)
                    }
                }

                Rectangle {
                    id: content

                    anchors { horizontalCenter: parent.horizontalCenter; verticalCenter: parent.verticalCenter }

                    width: dragArea.width
                    height: dragArea.height
                    radius: 4

                    opacity: dragArea.held ? 0.8 : 1.0
                    color: dragArea.held ? "blue" : selectedId == role_id ? Theme.gunmetal : Theme.slate900

                    Drag.active: dragArea.held
                    Drag.source: dragArea
                    Drag.hotSpot.x: width / 2
                    Drag.hotSpot.y: height / 2

                    states: State{
                        when: dragArea.held
                        ParentChange { target: content; parent: trajectoryList }
                        AnchorChanges {
                            target: content
                            anchors { horizontalCenter: undefined; verticalCenter: undefined }
                        }
                    }

                    TrajectoryListDelegate {
                        anchors { fill: parent }
                        name: role_name
                        iconColor: role_cadColor
                        textColor: selectedId == role_id ? role_cadColor : Theme.white
                        isLocked: role_locked
                    }
                }

                DropArea {
                    anchors.fill: parent
                    onEntered: {
                        visualModel.items.move(drag.source.DelegateModel.itemsIndex, dragArea.DelegateModel.itemsIndex)
                    }
                }
            }
        }
    }
}
