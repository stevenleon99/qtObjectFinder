import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

Rectangle {
    id: placedPopup
    height: 150
    width: 100
    radius: 5
    color: Theme.slate700
    visible: viewmodel.implantPlaced

    ImplantPlacedPopupViewModel {
        id: viewmodel
    }

    ColumnLayout {
    anchors{ fill: parent }
    IconImage {
        source: "qrc:/icons/check"
        Layout.alignment: Qt.AlignHCenter
        sourceSize: Theme.iconSize * 6
        color: Theme.green
    }

    Label {
        
        Layout.alignment: Qt.AlignHCenter
        state: "body1"
        text: "Implant \n Placed"
        color: Theme.white
    }
    }


    Connections {
        target: viewmodel

        onImplantPlacedChanged: placedPopup.visible = viewmodel.implantPlaced
    }

    Timer {
        interval: 3000; running: placedPopup.visible; repeat: false;
        onTriggered: { 
            placedPopup.visible = false 
        }
    }   
}
