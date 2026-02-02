import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

import ViewModels 1.0
import Enums 1.0

import "../components"

Item {
    visible: renderer.scanList.length &&
             renderer.viewType !== ImageViewport.ThreeD

    property var renderer

    anchors { fill: parent }

    ExcessiveDeflectionOverlayViewModel {
        id: excessiveDeflectionOverlayViewModel
    }

    MinimalAlert {
        visible: excessiveDeflectionOverlayViewModel.alertVisible
        anchors {
            bottom: parent.bottom
            margins: Theme.marginSize
            horizontalCenter: parent.horizontalCenter
        }
        alertColor: Theme.red
        iconSource: "qrc:/icons/alert-stop.svg"
        text: qsTr("Excessive Deflection Force")
    }
}


