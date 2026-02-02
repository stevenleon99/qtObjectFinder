import QtQuick 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

import ".."

RowLayout {
    spacing: 0
    id: probeOffsetComponent

    property real _repeatDelay: 500
    property real _repeatInterval: 10
    property bool isProbeOffsetVisible: probeOffsetViewModel.isProbeOffsetVisible

    ProbeOffsetViewModel {
        id: probeOffsetViewModel
    }

    CalculatorLPS {
        id: distanceCalculator
        positionAbove: true
    }

    Label {
        Layout.fillWidth: true
        verticalAlignment: Label.AlignVCenter
        horizontalAlignment: Label.AlignHCenter
        state: "subtitle1"
        color: Theme.white
        text: qsTr("Offset")
    }

    Button {
        state: "icon"
        icon.source: "qrc:/icons/undo.svg"
        onClicked: probeOffsetViewModel.updateOffsetProbe(0)
    }

    Button {
        rotation: 90
        icon.source: "qrc:/icons/double-arrow-down-stemless.svg"
        state: "icon"
        autoRepeat: true
        autoRepeatDelay: _repeatDelay
        autoRepeatInterval: _repeatInterval

        onClicked: probeOffsetViewModel.probeOffset >= 0?probeOffsetViewModel.stepOffsetProbe(-5):null
    }

    Button {
        rotation: 90
        icon.source: "qrc:/icons/arrow-down-stemless.svg"
        state: "icon"
        autoRepeat: true
        autoRepeatDelay: _repeatDelay
        autoRepeatInterval: _repeatInterval

        onClicked: probeOffsetViewModel.probeOffset >= 0?probeOffsetViewModel.stepOffsetProbe(-1):null
    }

    Label {
        Layout.fillWidth: true
        verticalAlignment: Label.AlignVCenter
        horizontalAlignment: Label.AlignHCenter
        state: "subtitle1"
        color: Theme.white
        text: probeOffsetViewModel.probeOffset.toFixed(1)

        MouseArea{
            anchors {fill: parent}

            onClicked: distanceCalculator.setup(probeOffsetComponent,
                                                probeOffsetViewModel.probeOffset,
                                                "",
                                                "",
                                                "",
                                                (value) => { probeOffsetViewModel.updateOffsetProbe(value) })
        }
    }

    Button {
        rotation: -90
        icon.source: "qrc:/icons/arrow-down-stemless.svg"
        state: "icon"
        autoRepeat: true
        autoRepeatDelay: _repeatDelay
        autoRepeatInterval: _repeatInterval

        onClicked: probeOffsetViewModel.stepOffsetProbe(1)
    }

    Button {
        rotation: -90
        icon.source: "qrc:/icons/double-arrow-down-stemless.svg"
        state: "icon"
        autoRepeat: true
        autoRepeatDelay: _repeatDelay
        autoRepeatInterval: _repeatInterval

        onClicked: probeOffsetViewModel.stepOffsetProbe(5)
    }
}

