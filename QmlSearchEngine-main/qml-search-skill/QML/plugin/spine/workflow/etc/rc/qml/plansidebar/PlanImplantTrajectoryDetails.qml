import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import "../components/toolspanel"

ColumnLayout {
    anchors.fill: parent

    SelectedImplantDetails {
        id: selectedImplantDetails
    }

    IndependentTrajectoryDetailsPanel {
        visible: !selectedImplantDetails.visible
    }
}
