import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0

import "../components"

ColumnLayout {
    visible: driverSelector.count > 0
    enabled: driverSelector.count > 1
    Layout.fillWidth: true
    Layout.rightMargin: 0

    DriverSelectionViewModel {
        id: driverSelectionViewModel

        onSelectedDriverToolIdChanged: driverSelector.updateSelection()
    }

    Connections {
        target: driverSelectionViewModel.availableDrivers

        function onDataChanged() { driverSelector.updateSelection() }
    }

    ImplantPropertySelector {
        id: driverSelector
        Layout.fillWidth: true
        title: ""
        stepperEnabled: false
        model: driverSelectionViewModel.availableDrivers
        comboBox.textRole: "role_name"

        function updateSelection() {
            if (driverSelectionViewModel.selectedDriverToolId) {
                for( var indexVal = 0; indexVal < count; indexVal++ ) {
                    var item = comboBox.delegateModel.items.get(indexVal)
                    if (item.model.role_key == driverSelectionViewModel.selectedDriverToolId) {
                        comboBox.currentIndex = indexVal
                        comboBox.displayText =  Qt.binding(function() { return comboBox.currentText })
                        return
                    }
                }
            }
            comboBox.currentIndex = -1
        }

        onValueSelected: {
            var item = comboBox.delegateModel.items.get(selectedIndex)
            driverSelectionViewModel.selectedDriverToolId = item.model.role_key
        }

        onModelChanged: updateSelection()

        onCountChanged: updateSelection()
    }
}
