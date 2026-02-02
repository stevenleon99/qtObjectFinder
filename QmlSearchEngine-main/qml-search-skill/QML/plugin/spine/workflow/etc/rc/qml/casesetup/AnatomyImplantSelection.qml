import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

Repeater {
    property var caseSetupSpineModelViewModel
    property bool bilateral: false

    model: caseSetupSpineModelViewModel.anatomyRegionList

    Item {
        x: role_x * 1.425
        y: role_y
        width: parent.width
        height: Theme.margin(6)
        opacity: caseSetupSpineModelViewModel.selectedImplantSetType == role_implantType ? 1.0 : 0.5

        ImplantSelection {
            objectName: "anatomyImplantSelection_"+role_name
            anchors { centerIn: parent }
            implantEnabled: role_enabled
            assigned: role_assigned
            text: role_name
            assignmentNumber: role_assignmentNumber
            color: role_assignmentColor

            onClicked: {
                if (assigned)
                {
                    caseSetupSpineModelViewModel.clearImplantSystem(role_key, bilateral ? CaseSetupPlanMode.Bilateral : CaseSetupPlanMode.Unilateral)
                }
                else
                {
                    caseSetupSpineModelViewModel.setImplantSystem(role_key, bilateral ? CaseSetupPlanMode.Bilateral : CaseSetupPlanMode.Unilateral)
                }
            }
        }
    }
}
