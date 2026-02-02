import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

ListView {
    model: reg2d3dCaptureAnatomyListVM.anatomyInfoList
    spacing: Theme.margin(2)
    interactive: false
    clip: true

    property int currentPatRegType: reg2d3dCaptureAnatomyListVM.currentPatRegType

    CaptureAnatomyListViewModel {
        id: reg2d3dCaptureAnatomyListVM
    }

    ScrollBar.vertical: ScrollBar {
        id: scrollBar
        anchors { right: parent.right; rightMargin: -20; bottom: parent.bottom }
        visible: parent.contentHeight > parent.height
        padding: Theme.margin(4)
    }

    delegate: CaptureAnatomy {
        width: parent.width - (scrollBar.visible ? Theme.margin(4) : Theme.margin(2))
        height: Theme.margin(6)

        selected: reg2d3dCaptureAnatomyListVM.selectedAnatomy === role_key

        onAnatomyClicked: reg2d3dCaptureAnatomyListVM.selectAnatomy(role_key)
    }
}
