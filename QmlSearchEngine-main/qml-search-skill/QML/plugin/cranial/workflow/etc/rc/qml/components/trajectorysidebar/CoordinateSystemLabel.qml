import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0


RowLayout {
    spacing: 0

    property string coordinateSystem

    Label {
        Layout.fillWidth: true
        state: "body1"
        color: Theme.navyLight
        font.bold: true
        text: qsTr("Coord Sys")
    }

    Label {
        state: "body1"
        font.bold: true
        text: coordinateSystem
    }
}
