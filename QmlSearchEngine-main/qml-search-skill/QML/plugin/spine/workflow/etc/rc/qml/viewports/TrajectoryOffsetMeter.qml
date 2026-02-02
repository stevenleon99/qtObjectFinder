import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import "../components"

Gauge {
    visible: offsetMeterViewModel.visible
    width: 160
    value: offsetMeterViewModel.meterValue
    text: qsTr("Offset")

    OffsetMeterViewModel {
        id: offsetMeterViewModel
    }
}