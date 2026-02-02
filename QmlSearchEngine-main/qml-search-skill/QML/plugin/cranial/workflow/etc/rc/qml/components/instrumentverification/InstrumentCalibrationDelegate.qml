import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

RowLayout {
    spacing: 0
    Layout.fillHeight: true
    Layout.fillWidth: true
    property string name
    property string textColor

    Rectangle {
        Layout.fillHeight: true
        Layout.fillWidth: true
        color: Theme.transparent
        border.color: Theme.gunmetal
        border.width: 2


        Label {
            anchors { fill: parent }
            text: name
            state: "body1"
            color: textColor
            font.styleName: Theme.mediumFont.styleName
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }
}
