import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0

RowLayout {
    anchors { fill: parent; leftMargin: Theme.margin(1); rightMargin: Theme.margin(1) }
    spacing: Theme.margin(2)

    property alias trackingButtonVisible: trackingButton.visible

    Label {
        Layout.fillWidth: false
        Layout.alignment: Qt.AlignVCenter
        Layout.leftMargin: Theme.margin(1)
        Layout.rightMargin: Theme.margin(.5)
        state: "subtitle2"
        font { bold: true; letterSpacing: 1; capitalization: Font.AllUppercase }
        color: Theme.navyLight
        text: qsTr("Track")
    }

    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.rightMargin: Theme.margin(1)

        TrackingPanel {
            objectName: "trackingBarTrackingPanel"
            anchors.fill: parent
        }
    }

    Button {
        id: trackingButton
        Layout.alignment: Qt.AlignRight
        state: "icon"
        icon.source: "qrc:/icons/tracking-camera"

        onClicked: trackingPopup.setup(this)
    }

    TrackingPopup {
        id: trackingPopup
    }
}
