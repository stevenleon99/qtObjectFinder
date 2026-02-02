import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import ViewModels 1.0

import Theme 1.0

import ".."

Item {
    id: fluoroRegistrationMarkersOverlay
    visible: fluoroRegistrationMarkersOVM.isVisible
    clip: true
    property var renderer
    objectName: "FluoroRegistrationMarkersOverlay"

    FluoroRegistrationMarkersOverlayViewModel {
        id: fluoroRegistrationMarkersOVM
        viewport: renderer
    }

    Item {
        // Ordered largest to smallest. Z-order is tied to this order and we don't
        // want larger ones appearing above and potentially hiding smaller ones.

        Repeater {
            model: fluoroRegistrationMarkersOVM.detectedMarkers

            delegate: RegistrationMarker {
                color: Theme.orange500
                is2d: true
                scale: 1.6
                position: fluoroRegistrationMarkersOVM.detectedMarkers[index]
            }
        }

        Repeater {
            model: fluoroRegistrationMarkersOVM.orientationMarkers

            delegate: RegistrationMarker {
                color: Theme.purple500
                position: fluoroRegistrationMarkersOVM.orientationMarkers[index]
            }
        }

        Repeater {
            model: fluoroRegistrationMarkersOVM.registrationMarkers

            delegate: RegistrationMarker {
                color: Theme.blueLight500
                position: fluoroRegistrationMarkersOVM.registrationMarkers[index]

            }
        }

        Repeater {
            model: fluoroRegistrationMarkersOVM.gridMarkers

            delegate: RegistrationMarker {
                color: Theme.teal500
                scale: 1.0 / 3
                position: fluoroRegistrationMarkersOVM.gridMarkers[index]
            }
        }
    }
}


