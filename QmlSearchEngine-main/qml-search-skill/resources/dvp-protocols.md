# DVP Protocols Reference

## What are DVP Protocols?
DVP (Data-View-Protocol) protocols are patterns used to connect QML user interfaces with C++ backend models in Qt applications. They define how data flows between the view layer (QML) and the business logic layer (C++).

## Common Protocol Categories

### User Management
- **ActiveUserViewModel**: Current user session management
- **UserViewModel**: Individual user operations
- **UserListModel**: Collection of users

### Patient Management
- **PatientDetailsModel**: Detailed patient information
- **PatientItemModel**: Single patient data item
- **PatientListModel**: Patient listing
- **PatientMatchListModel**: Search results
- **PatientNameViewModel**: Name handling
- **PatientsModel**: Overall patient management

### Case Management
- **CaseItemModel**: Individual case data
- **CaseListModel**: Case listings
- **CasesModel**: Case management
- **CaseSummaryModel**: Case summaries
- **CaseExportViewModel**: Export functionality

### Study & Scan Management
- **StudySummaryModel**: Study information
- **ScanListModel**: Scan listings

### System & Configuration
- **ApplicationViewModel**: Main app state
- **ConnectionsViewModel**: Network connections
- **NetworkSettingsViewModel**: Network config
- **SystemInfoViewModel**: System information
- **SystemPower**: Power management
- **ServiceSettingsViewModel**: Services config
- **LicenseManagerViewModel**: License management

### Drive Operations
- **DrivePageViewModel**: Main drive interface
- **DriveAlerts**: Alert system
- **DriveScreenshots**: Screenshot management
- **HomingViewModel**: Device homing

### Media & Export
- **ImageExportViewModel**: Image export
- **ScreenshotsViewModel**: Screenshot handling
- **ScreenshotListModel**: Screenshot list

### Plugins
- **PluginModel**: Plugin configuration
- **PluginInfoListModel**: Plugin information

### UI & Workflow
- **OnboardingTutorialViewModel**: User onboarding
- **WatermarkViewModel**: Watermark settings
- **ImportViewModel**: Data import

## How to Identify DVP Usage in QML

### Pattern 1: Model Instantiation
```qml
PatientListModel {
    id: patientModel
}
```

### Pattern 2: Property Binding
```qml
text: patientModel.patientName
```

### Pattern 3: Signal Connection
```qml
onPatientSelected: {
    patientModel.selectPatient(patientId)
}
```

### Pattern 4: Method Invocation
```qml
Button {
    onClicked: caseModel.exportCase()
}
```

## Search Tips
- Look for class names ending in "Model" or "ViewModel"
- Check import statements for custom model namespaces
- Find property paths containing model variable names
- Locate signal handlers that call model methods
