import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

import "../.."

ColumnLayout {
    spacing: 0

    property alias meterVisible: linkErrorMeter.visible
    property bool isEnable: false

    FluoroCentroidViewModel {
        id: fluoroCentroidVM
    }

    SectionHeader {
        title: qsTr("CENTROID")
        enabled: isEnable

        Button {
            enabled: fluoroCentroidVM.isEnabled
            state: "icon"
            icon.source: fluoroCentroidVM.isLinked ? "qrc:/images/link.svg" : "qrc:/images/link-off.svg"

            onClicked: fluoroCentroidVM.toggleLinked()
        }

        Button {
            state: "icon"
            icon.source: fluoroCentroidVM.isEnabled ? "qrc:/icons/crosshair.svg" : "qrc:/icons/crosshair-off.svg"

            onClicked: fluoroCentroidVM.toggleEnabled()
        }
    }

    ValueMeter {
        id: linkErrorMeter
        Layout.leftMargin: Theme.marginSize
        Layout.rightMargin: Theme.marginSize
        Layout.fillWidth: true
        value: fluoroCentroidVM.centroidLinkErrorMeterValue
        text: qsTr("Registration Fit")
        disabled: !fluoroCentroidVM.isCentroidLinkErrorValid
    }
}
