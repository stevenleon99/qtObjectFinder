import QtQuick 2.12
import ViewModels 1.0

import Theme 1.0

Item {
anchors.fill: parent
visible: labelOverlayViewModel.labelText !== "" && renderer.viewType !== ImageViewport.ThreeD
property var renderer

    LabelOverlayViewModel {
        id: labelOverlayViewModel
    }

Rectangle {
    anchors.bottom: parent.bottom
    anchors.bottomMargin: Theme.marginSize * 2
    anchors.horizontalCenter: parent.horizontalCenter
    width: 400
    height: 40
    color: "#80000000" 
    
        Text {
            text: labelOverlayViewModel.labelText
            anchors.centerIn: parent
            color: Theme.white
            font.pointSize: 18
        }
  


}
}


