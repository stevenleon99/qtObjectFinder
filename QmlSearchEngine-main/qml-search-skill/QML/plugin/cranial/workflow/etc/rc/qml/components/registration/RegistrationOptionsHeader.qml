import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

import ".."

SidebarHeader {

    Label {
        Layout.preferredHeight: 64
        state: "body1"
        verticalAlignment: Label.AlignVCenter
        text: qsTr("PATIENT REFERENCE")
        color: Theme.navyLight
    }

    RadioButton {
        Layout.fillWidth: true
        checked: ictSnapshotViewModel.isDrb
        text: qsTr("DRB Array")

//        onClicked: ictSnapshotViewModel.setPatRefDrb()
    }

    RadioButton {
        Layout.fillWidth: true
        checked: ictSnapshotViewModel.isCrw
        text: qsTr("FRA CRW")

//        onClicked: ictSnapshotViewModel.setPatRefCrw()
    }

    RadioButton {
        Layout.fillWidth: true
        checked: ictSnapshotViewModel.isLeksell
        text: qsTr("FRA Leksell")

//        onClicked: ictSnapshotViewModel.setPatRefLeksell()
    }
}
