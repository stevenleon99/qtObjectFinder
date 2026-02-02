import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import ViewModels 1.0

import Theme 1.0
import GmQml 1.0

Item {
    Layout.fillWidth: true
    Layout.fillHeight: true

    AddImplantSystemViewModel {
        id: addImplantSystemViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing:0

        Label {
            objectName: "addSystemLabel"
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize
            Layout.preferredHeight: Theme.margin(8)
            state: "subtitle1"
            font.bold: true
            font.letterSpacing: 1
            text: qsTr("Add System")
            verticalAlignment: Label.AlignVCenter
        }

        ImplantSystemList {
            id: fixationList
            objectName: "fixationSystemList"
            title: qsTr("Screws")
            model: addImplantSystemViewModel.fixationImplantSystemList
            selectedCount: addImplantSystemViewModel.selectedScrewInstrumentSetCount

            onListExpaned: interbodyList.expanded = false
            onAddSystem: {
                addImplantSystemViewModel.addSystem(id)
            }
            onRemoveSystem: {
                addImplantSystemViewModel.removeSystem(id)
            }
        }

        ImplantSystemList {
            id: interbodyList
            objectName: "InterbodiesSystemList"
            visible: systemList.count > 0
            title: qsTr("Interbodies")
            model: addImplantSystemViewModel.interbodyImplantSystemList
            selectedCount: addImplantSystemViewModel.selectedInterbodyInstrumentSetCount

            onListExpaned: fixationList.expanded = false
            onAddSystem: addImplantSystemViewModel.addSystem(id)
            onRemoveSystem: addImplantSystemViewModel.removeSystem(id)
        }

        LayoutSpacer {}
    }
}
