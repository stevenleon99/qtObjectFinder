import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0

import ".."

RowLayout {
    spacing: Theme.marginSize

    property alias value: label.text

    IconImage {
        source: "qrc:/icons/measure.svg"
        sourceSize: Theme.iconSize
    }

    SectionHeader {
        Layout.leftMargin: 0
        Layout.rightMargin: 0
        title: qsTr("AC-PC Distance (mm)")

        Label {
            id: label
            Layout.fillWidth: false
            state: "h6"
        }
    }
}
