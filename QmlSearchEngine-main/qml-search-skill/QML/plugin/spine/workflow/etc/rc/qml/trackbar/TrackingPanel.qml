import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0
import Enums 1.0

RowLayout {
    spacing: Theme.margin(2)

    TrackingBarViewModel {
        id: trackingBarViewModel
    }

    Repeater {
        id: repeater
        objectName: "trackingPanel_"+role_activeToolProps.toolInfo
        model: trackingBarViewModel.trackingBarList
        TrackingPanelDelegate {
            active: role_isActive
            trackingValid: role_visibilityToCamera == CameraVisibilityStatus.SEEN
            source: role_iconPath
            objectName: role_name
            barActive: role_meterActive
            barValue: role_meterRatio
            barText: role_meterText
            barClearable: role_clearComponentDisplayed
            barPlusButtonEnabled: role_pairingComponentDisplayed
            barDisplayed: role_meterDisplayed
            overrideBarTracking: role_overrideMeterTracking
            displayArrayInfo: role_isTool && (role_activeToolProps.arrayIndex != 0)
            displayArrayIndex: role_activeToolProps.displayArrayIndex
            arrayIndex: role_activeToolProps.arrayIndex
            arrayColor: role_activeToolProps.color
            rotationPosition: role_activeToolProps.rotationPosition
            infoText: role_activeToolProps.toolInfo
            statusIconVisible: role_statusIconVisible
            statusIconPath: role_statusIcon
            statusIconColor: role_statusIconColor
            displayContent: role_displayContent

            onCleared: trackingBarViewModel.clear(role_key) 
            onPlusButtonClicked: trackingBarViewModel.meterAutoPairingRequested(role_key)
            onRotationPositionClicked: trackingBarViewModel.incrementToolRotationPosition()
        }
    }

    LayoutSpacer {}
}
