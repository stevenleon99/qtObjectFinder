import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Enums 1.0
import ViewModels 1.0

import "../../components"

RowLayout {
    anchors.fill: parent
    spacing: 0

    SwappablePairingsViewModel {
        id: swappablePairingsVM
    }

    ArraysPanel {
        swappablePairingsViewModel: swappablePairingsVM
    }

    ArrayPairingToolsPanel {
        swappablePairingsViewModel: swappablePairingsVM
    }

    ArrayPairingFilterSearchPanel {
        swappablePairingsViewModel: swappablePairingsVM
    }
}
