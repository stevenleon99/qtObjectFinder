import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

IconImage {
    x: locX - (width / 2)
    y: locY - (height / 2)
    sourceSize: Qt.size(48, 48)
    source: "qrc:/icons/crosshair.svg"
    color: selected ? Theme.green : Theme.blue

    property bool selected: true
    property alias text: label.text

    property double locX: 0
    property double locY: 0

    Label {
        id: label
        visible: text
        anchors { right: parent.left; verticalCenter: parent.verticalCenter }
        font { pixelSize: 38 }
        style: Text.Outline
        styleColor: Theme.black
    }
}
