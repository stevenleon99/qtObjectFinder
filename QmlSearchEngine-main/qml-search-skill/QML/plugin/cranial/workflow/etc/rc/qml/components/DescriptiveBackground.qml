import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

ColumnLayout {
    width: parent.width
    anchors { centerIn: parent }
    spacing: Theme.marginSize / 2

    property string icon
    property string title
    property string description

    IconImage {
        visible: icon
        Layout.alignment: Qt.AlignHCenter
        source: icon
        sourceSize: Qt.size(Theme.marginSize * 4, Theme.marginSize * 4)
        color: Theme.navyLight
    }

    Label {
        visible: title
        Layout.alignment: Qt.AlignHCenter
        state: "h6"
        color: Theme.navyLight
        text: title
    }

    Label {
        visible: description
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        state: "body1"
        color: Theme.disabledColor
        text: description
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Label.WrapAtWordBoundaryOrAnywhere
    }
}
