import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0

import "../components"

Item {
    property CameraViewViewModel cameraViewVM

    Label {
        anchors {left: parent.left; verticalCenter: parent.verticalCenter}
        state: "subtitle2"
        font { bold: true; letterSpacing: 1; capitalization: Font.AllUppercase }
        color: Theme.headerTextColor
        text: "Camera"
    }

    StringOptionsDropdown {
        enabled: cameraViewVM.xrEnabled
        anchors {right: parent.right; verticalCenter: parent.verticalCenter}
        optionList: cameraViewVM.availableTrackers
        selectedOption: cameraViewVM.selectedTracker
        displayString: qsTr("<font color=\"#95C1DA\"> POV: </font>") + cameraViewVM.selectedTracker

        onSelected: cameraViewVM.selectedTracker = option
    }
}

