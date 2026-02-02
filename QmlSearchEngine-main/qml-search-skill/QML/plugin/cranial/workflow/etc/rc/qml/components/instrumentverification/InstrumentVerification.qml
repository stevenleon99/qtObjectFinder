import QtQuick 2.4
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.4

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import ".."

Rectangle {
    Layout.margins: Theme.marginSize / 2
    Layout.fillWidth: true
    Layout.fillHeight: true
    radius: 8
    color: Theme.black
    property alias switchOption: rl.visible
    property alias toolOption: markerSwitch.checked

    InstrumentVerificationViewModel {
        id: instrumentVerificationViewModel
    }

    Label {
        anchors { left: parent.left; leftMargin: Theme.margin(2); top: parent.top; topMargin: Theme.margin(2) }
        font { bold: true }
        text: qsTr("Camera View")
        state: "h6"
        color: Theme.headerTextColor
    }

    DividerLine {
        anchors { centerIn: parent }
        orientation: Qt.Horizontal
        lineThickness: 1
    }

    DividerLine {
        anchors { centerIn: parent }
        orientation: Qt.Vertical
        lineThickness: 1
    }

    RowLayout {
        id: rl
        anchors { horizontalCenter: parent.horizontalCenter }
        height: Theme.margin(8)
        spacing: Theme.marginSize
        visible: true

        Label {
            state: "body1"
            text: qsTr("Markers")
            color: markerSwitch.checked ? Theme.headerTextColor : Theme.white
        }

        Switch {
            id: markerSwitch
            checked: true

        }

        Label {
            state: "body1"
            text: qsTr("Centroids")
            color: markerSwitch.checked ? Theme.white : Theme.headerTextColor
        }

    }

    Repeater {
        model: instrumentVerificationViewModel

        delegate: Rectangle {
            visible: role_instrumentVisible && markerSwitch.checked
            x: (parent.width - width) * role_xRatio
            y: (parent.height - height) * role_yRatio
            width: Theme.marginSize * 4
            height: width
            radius: width / 2
            scale: 0.25 + (role_scaleRatio * 0.75)
            border { width: Theme.marginSize / 4; color: role_iconColor }
            color: role_instrumentVisible ? role_iconColor : Theme.transparent
        }
    }

    Repeater {
        model: instrumentVerificationViewModel.markersModel

        delegate: Rectangle {
            visible: role_markerVisible && !markerSwitch.checked
            x: (parent.width - width) * role_xRatio
            y: (parent.height - height) * role_yRatio
            width: switchOption?Theme.marginSize * 4:Theme.marginSize * 2
            height: width
            radius: width / 2
            scale: 0.25 + (role_scaleRatio * 0.75)
            border { width: Theme.marginSize / 4; color: "black" }
            color: role_markerVisible ? role_iconColor : Theme.transparent
        }
    }

    InstrumentVerificationStatus {
        anchors { top: parent.top; right: parent.right; margins: Theme.margin(2) }
    }
}
