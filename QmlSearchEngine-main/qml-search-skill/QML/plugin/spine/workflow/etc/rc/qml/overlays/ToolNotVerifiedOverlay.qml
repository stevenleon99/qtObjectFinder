import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

import ViewModels 1.0
import Enums 1.0

import "../components"

Item {
    visible: renderer.scanList.length > 0 &&
             (toolNotVerifiedOverlayViewModel.showToolNotVerified ||
              toolNotVerifiedOverlayViewModel.showToolLengthNotVerified)

    property var renderer

    anchors { fill: parent }

    ToolNotVerifiedOverlayViewModel {
        id: toolNotVerifiedOverlayViewModel
    }

    MinimalAlert {
        visible: toolNotVerifiedOverlayViewModel.showAlert
        anchors {
            bottom: parent.bottom
            margins: Theme.marginSize
            horizontalCenter: parent.horizontalCenter
        }
        alertColor: Theme.red
        iconSource: "qrc:/icons/alert-stop.svg"
        text: toolNotVerifiedOverlayViewModel.alertText
    }
}


