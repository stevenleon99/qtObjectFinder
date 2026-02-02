import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

RowLayout {
    Layout.preferredWidth: Theme.margin(15)
    Layout.preferredHeight: Theme.margin(6)

    property string label
    property vector3d valueVector: Qt.vector3d()

    Label {
        Layout.fillHeight: true
        Layout.leftMargin: Theme.margin(2)
        color: Theme.navyLight
        state: "body1"
        verticalAlignment: Qt.AlignVCenter
        text: switch (index) {
              case 0: return label + "m"
              case 1: return label + "x"
              case 2: return label + "y"
              case 3: return label + "z"
              }
    }

    Label {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.rightMargin: Theme.margin(2)
        state: "body1"
        font.bold: true
        horizontalAlignment: Qt.AlignRight
        verticalAlignment: Qt.AlignVCenter
        text: switch (index) {
              case 0: return valueVector.length().toFixed(1)
              case 1: return valueVector.x.toFixed(1)
              case 2: return valueVector.y.toFixed(1)
              case 3: return valueVector.z.toFixed(1)
              }
    }
}
