import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import "qrc:/drive/qml/settings/"

ColumnLayout {
    x: Theme.margin(6)
    width: parent.width
    spacing: Theme.marginSize * 2

    MenuSection {
        Layout.fillWidth: true
        title: qsTr("Coordinates")
        sourceComponent: CoordinateSettings {}
    }

    DividerLine {}

    DividerLine {}

    MenuSection {
        Layout.fillWidth: true
        title: qsTr("Graphics")
        sourceComponent: ViewportSettings {}
    }
    
    DividerLine {}

}
