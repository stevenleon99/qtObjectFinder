import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Enums 1.0
import Theme 1.0
import ViewModels 1.0

import ".."
import "../trajectorysidebar"

ColumnLayout {

    ReachabilityListViewModel {
        id: reachabilityListViewModel
    }

    ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.leftMargin: Theme.margin(2)
        spacing: Theme.margin(2)
        clip: true
        model: reachabilityListViewModel.reachabilityList

        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            policy: ScrollBar.AlwaysOn
        }

        footer: Item {
            height: Theme.margin(2)
        }

        delegate: Rectangle {
            width: listView.width - scrollBar.width
            height: Theme.margin(6)
            radius: 4
            border { width: role_active ? 2 : 1; color: role_active ? Theme.blue : Theme.lineColor }
            color: role_active ? Theme.foregroundColor : Theme.backgroundColor

            TrajectoryListDelegate {
                id: layout
                anchors { fill: parent }
                textColor: role_active ? Theme.white : Theme.navyLight
                iconColor: role_cadColor
                name: role_name

                property bool statusUnknown: role_status == ReachabilityStatus.Unknown
                property bool reachable: role_status == ReachabilityStatus.Reachable
                                         || role_status == ReachabilityStatus.BarelyReachable
                property bool barelyReachable : role_status == ReachabilityStatus.BarelyReachable
                property string notReachableText: {
                    if (role_status == ReachabilityStatus.TooFar) { return "far"; }
                    else if (role_status == ReachabilityStatus.TooClose) { return "close"; }
                    else if (role_status == ReachabilityStatus.TooHigh) { return "high"; }
                    else if (role_status == ReachabilityStatus.TooLow) { return "low"; }
                    else { return ""; }
                }

                Label {
                    visible: !layout.reachable
                    Layout.alignment: Qt.AlignVCenter
                    Layout.rightMargin: Theme.margin(1)
                    color: Theme.red
                    state: "body1"
                    font { bold: true }
                    text: layout.notReachableText
                }

                IconImage {
                    Layout.alignment: Qt.AlignVCenter
                    Layout.rightMargin: Theme.margin(2)
                    sourceSize: Theme.iconSize
                    source: {
                        if (layout.statusUnknown) {
                            return "qrc:/icons/question-mark.svg";
                        } else if (layout.reachable) {
                            return "qrc:/icons/check.svg";
                        } else {
                            return "qrc:/icons/x.svg";
                        }
                    }
                    color: {
                        if (layout.statusUnknown) {
                            return Theme.white;
                        } else if (layout.reachable) {
                            if (layout.barelyReachable) {
                                return Theme.green;
                            } else {
                                return Theme.green;
                            }
                        } else {
                            return Theme.red;
                        }
                    }
                }
            }

            MouseArea {
                anchors { fill: parent }

                onClicked: reachabilityListViewModel.selectTrajectory(role_id)
            }
        }
    }
}
