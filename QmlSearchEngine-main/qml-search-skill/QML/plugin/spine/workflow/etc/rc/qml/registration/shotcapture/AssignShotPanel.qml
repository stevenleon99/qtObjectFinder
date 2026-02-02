import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0
import Enums 1.0

import "../../viewports"
import "../../overlays"

Item {
    anchors { fill: parent }

    property var shotAssignViewportVM

    Rectangle { anchors.fill: parent; color: Theme.black; opacity: .64}

    MouseArea { anchors.fill: parent }

    Rectangle {
        anchors { centerIn: parent }
        height: parent.height - Theme.margin(1)
        width: height

        color: Theme.transparent
        border { color: Theme.blue; width: 4 }
        radius: 4

        Viewport {
            id: viewport
            anchors { fill: parent; margins: 4 }
            viewportUid: shotAssignViewportVM.viewportId

            // Add the fluoro registation marker overlay to viewport
            Component {
                id: frmOverlay
                FluoroRegistrationMarkersOverlay {}
            }
            backgroundComponent: frmOverlay
        }

        RowLayout {
            width: parent.width
            anchors { top: parent.top }
            spacing: 0
            Item{
                Layout.preferredWidth:Theme.margin(8)
                Layout.preferredHeight:Theme.margin(8)
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 4
                Layout.leftMargin: 4
                Rectangle { anchors.fill: parent; radius: 4; color: Theme.black; opacity: .64}
                Button
                {
                    anchors.centerIn: parent
                    state: "icon"
                    icon.source: "qrc:/icons/trash"
                    onClicked: shotAssignViewportVM.deleteShot()
                }
            }

            LayoutSpacer {}

            Item{
                Layout.preferredWidth: Theme.margin(8)
                Layout.preferredHeight: Theme.margin(14)
                Layout.topMargin: 4
                Layout.rightMargin: 4

                Rectangle { anchors.fill: parent; radius: 4; color: Theme.black; opacity: .64}
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 0
                    Button {
                        state: "icon"
                        icon.source: "qrc:/icons/x"
                        onClicked: shotAssignViewportVM.clearShotSelection()
                    }
                    Button {
                        state: "icon"
                        icon.source: "qrc:/icons/center"
                        onClicked: viewport.setDefault2DView()
                    }
                }
            }
        }

        ColumnLayout{ 
            width: parent.width
            anchors { bottom: parent.bottom; bottomMargin: Theme.marginSize }
            spacing: Theme.marginSize
            Item {
                Layout.preferredWidth: selectedIndex.width
                Layout.preferredHeight: selectedIndex.height
                Layout.leftMargin: Theme.marginSize

                Rectangle { anchors.fill: parent; radius: 8; color: Theme.black; opacity: .64}

                Label {
                    id: selectedIndex
                    leftPadding: Theme.marginSize
                    rightPadding: Theme.marginSize
                    Layout.alignment: Qt.AlignBottom
                    state: "h1"
                    font.bold: true
                    text: shotAssignViewportVM.selectedShotIndex
                }
            }

            RowLayout {
                Layout.leftMargin: Theme.marginSize
                Layout.rightMargin: Theme.marginSize

                Button {
                    Layout.alignment: Qt.AlignHCenter
                    state: "active"
                    enabled: shotAssignViewportVM.assignShotEnabled
                    text: qsTr("Assign to AP")

                    onClicked: shotAssignViewportVM.assignApShot()
                }

                LayoutSpacer {}

                Button {
                    Layout.alignment: Qt.AlignHCenter
                    state: "active"
                    enabled: shotAssignViewportVM.assignShotEnabled
                    text: qsTr("Assign to LAT")

                    onClicked: shotAssignViewportVM.assignLatShot()
                }
            }
        }

        Rectangle {
            id: alertRectangle
            visible: shotAssignViewportVM.shotStatusSeverity == ShotStatusSeverity.Failure || shotAssignViewportVM.shotStatusSeverity == ShotStatusSeverity.Warning
            anchors { bottom: parent.bottom; margins: Theme.marginSize; horizontalCenter: parent.horizontalCenter }
            height: Theme.margin(9)
            width: Theme.margin(40)
            radius: 4
            color: Theme.black
            border { 
                width: 2;
                color: {
                        if(shotAssignViewportVM.shotStatusSeverity == ShotStatusSeverity.Failure)
                            return Theme.red
                        else
                            return Theme.yellow
                } 
            }

            RowLayout
            {
                width: parent.width
                anchors { verticalCenter: parent.verticalCenter; leftMargin: Theme.margin(1); rightMargin: Theme.margin(1) }
                spacing: 0

                IconImage {
                    Layout.leftMargin: Theme.margin(1)
                    Layout.alignment: Qt.AlignTop
                    source: shotAssignViewportVM.shotStatusSeverity == ShotStatusSeverity.Failure ? "qrc:/images/register-off.svg" : "qrc:/icons/alert-caution.svg"
                    sourceSize: Theme.iconSize
                    color: {
                            if(shotAssignViewportVM.shotStatusSeverity == ShotStatusSeverity.Failure)
                                return Theme.red
                            else
                                return Theme.yellow
                    } 
                }

                Label {
                    Layout.fillWidth: true
                    Layout.rightMargin: Theme.margin(1)
                    Layout.leftMargin: Theme.margin(1)
                    verticalAlignment: Text.AlignVCenter
                    state: "subtitle1"
                    wrapMode: Text.WordWrap
                    elide:Text.ElideRight
                    maximumLineCount: 2
                    text: labelPrefix + qsTr(shotAssignViewportVM.shotStatusLabel)

                    property string labelPrefix: {
                        if(shotAssignViewportVM.shotStatusSeverity == ShotStatusSeverity.Failure)
                            return "<b>Registration Failed: </b>"
                        else
                            return "<b>Warning: </b>"
                    }
                }
            }
        }

        Component.onDestruction: {
            if (shotAssignViewportVM.visible)
                shotAssignViewportVM.clearShotSelection()
        }
    }
}
