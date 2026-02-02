import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0


ListView {
    id: arrayPairingList
    Layout.fillWidth: true
    Layout.fillHeight: true
    spacing: Theme.marginSize

    property var swappablePairingsViewModel

    model: swappablePairingsViewModel.activeArrayPairingList

    delegate: ArrayPairingElement {
        selected:  role_refElementId === swappablePairingsViewModel.selectedRefElementId
        arrayColor: role_color
        arrayNum: role_arrayIndex
        displayArrayNum: role_displayArrayIndex
        instrumentName: role_toolName
        instrumentPartNum: role_toolPartNumber
        iconSource: role_iconSource

        onClicked: swappablePairingsViewModel.selectedRefElementId = role_refElementId
    }
}
