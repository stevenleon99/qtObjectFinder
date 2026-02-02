# Sample QML Patterns

## Pattern 1: Simple Component with Model

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Page {
    id: patientPage
    
    PatientListModel {
        id: patientModel
    }
    
    ListView {
        anchors.fill: parent
        model: patientModel
        
        delegate: ItemDelegate {
            text: model.patientName
            onClicked: patientModel.selectPatient(model.patientId)
        }
    }
}
```

## Pattern 2: Multiple ViewModels

```qml
import QtQuick 2.15

Item {
    PatientDetailsModel {
        id: patientDetails
    }
    
    CaseSummaryModel {
        id: caseSummary
        patientId: patientDetails.currentPatientId
    }
    
    Text {
        text: patientDetails.patientName + " - " + caseSummary.caseName
    }
}
```

## Pattern 3: Signal Handlers

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Dialog {
    ImageExportViewModel {
        id: exportModel
        
        onExportCompleted: {
            statusText.text = "Export successful"
        }
        
        onExportFailed: function(error) {
            statusText.text = "Error: " + error
        }
    }
    
    Button {
        text: "Export"
        onClicked: exportModel.startExport()
    }
    
    Label {
        id: statusText
    }
}
```

## Pattern 4: Property Bindings

```qml
import QtQuick 2.15

Rectangle {
    ApplicationViewModel {
        id: appModel
    }
    
    width: appModel.windowWidth
    height: appModel.windowHeight
    visible: appModel.isVisible
    enabled: appModel.isEnabled && !appModel.isBusy
}
```

## Pattern 5: Dynamic Object Creation

```qml
import QtQuick 2.15

Item {
    Component {
        id: patientComponent
        
        PatientItemModel {
            property string patientId
        }
    }
    
    function createPatient(id) {
        return patientComponent.createObject(parent, {
            "patientId": id
        })
    }
}
```

## Common Search Patterns

### Finding Model Declarations
Look for: `ModelName { id: variableName }`

### Finding Property Usage
Look for: `property: modelId.propertyName`

### Finding Signal Handlers
Look for: `onSignalName:` or `onSignalName: function(args)`

### Finding Method Calls
Look for: `modelId.methodName(arguments)`

### Finding Imports
Look for: `import com.company.models 1.0`
