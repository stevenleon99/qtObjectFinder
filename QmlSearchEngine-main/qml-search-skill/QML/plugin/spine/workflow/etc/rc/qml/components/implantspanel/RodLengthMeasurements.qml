import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Item {
    width: parent.width
    height: Theme.margin(6)

    property string leftRodLength
    property string rightRodLength

    Label {
        anchors { left: parent.left; verticalCenter: parent.verticalCenter }
        state: "body1"
        font.bold: true
        text: leftRodLength + "mm"
        color: Theme.lineColor
    }

    Label {
        anchors { centerIn: parent  }
        Layout.alignment: Qt.AlignHCenter
        state: "subtitle1"
        font.bold: true
        text: "Distance"
    }

    Label {
        anchors { right: parent.right; verticalCenter: parent.verticalCenter }
        state: "body1"
        font.bold: true
        text: rightRodLength + "mm"
        color: Theme.lineColor
    }
}
