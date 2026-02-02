import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0

import Enums 1.0
import ViewModels 1.0

import "../../components"

RowLayout {
    anchors.fill: parent
    spacing: 0

    PowerToolsPairingsViewModel {
        id: powerToolsPairingsVM
    }

    DrillConfigurationsPanel {
        powerToolsPairingsViewModel: powerToolsPairingsVM
    }

    DrillAttachmentsBurrs {
        title: qsTr("Attachment")
        model: powerToolsPairingsVM.attachments
        sortedOrder: powerToolsPairingsVM.attachmentSortOrder
        emptyListText: qsTr("Select a Configuration")

        onSortClicked: powerToolsPairingsVM.toggleAttachmentSortOrder()
        onSelectItem: powerToolsPairingsVM.selectAttachmentId(id)

        DividerLine {
            anchors { right: parent.right }
        }
    }

    DrillAttachmentsBurrs {
        title: qsTr("Burr")
        disableAllowed: true
        model: powerToolsPairingsVM.burrs
        sortedOrder: powerToolsPairingsVM.burrSortOrder
        emptyListText: qsTr("Select a Configuration")

        onSortClicked: powerToolsPairingsVM.toggleBurrSortOrder()
        onSelectItem: powerToolsPairingsVM.selectBurrId(id)
    }
}
