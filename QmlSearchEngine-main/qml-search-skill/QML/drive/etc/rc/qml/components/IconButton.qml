import QtQuick 2.4
import QtQuick.Controls 2.3
import QtQuick.Controls.impl 2.3

import Theme 1.0

IconImage {
    id: iconButton
    source: "/images/icons/" + icon + ".png"
    fillMode: Image.PreserveAspectFit
    color: active ? Theme.blue : Theme.white

    property string icon: ""
    property bool active: buttonMA.pressed

    signal clicked()

    MouseArea {
        id: buttonMA
        anchors { fill: parent }

        onClicked: iconButton.clicked()
    }
}
