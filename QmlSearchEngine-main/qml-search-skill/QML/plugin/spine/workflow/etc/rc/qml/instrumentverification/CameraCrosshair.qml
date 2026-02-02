import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import Theme 1.0

Item {
    anchors { fill: parent }

    Rectangle {
        opacity: 0.5
        height: 1
        anchors { left: parent.left; right: parent.right; verticalCenter: parent.verticalCenter }
        color: Theme.lineColor
    }

    Rectangle {
        opacity: 0.5
        width: 1
        anchors { top: parent.top; bottom: parent.bottom; horizontalCenter: parent.horizontalCenter }
        color: Theme.lineColor
    }
}
