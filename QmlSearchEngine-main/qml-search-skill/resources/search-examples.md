# QML Search Examples

## Basic Object Searches

### Example 1: Find Button Objects
**Query**: "Find all Button objects in the uploaded files"

**Expected Response**: List of all QML Button declarations with file names and line numbers

### Example 2: Search by Object ID
**Query**: "Find objects with id: submitButton"

**Expected Response**: Specific objects with matching IDs

### Example 3: Find ListView Components
**Query**: "Show me all ListView objects"

**Expected Response**: All ListView declarations and their models

## ViewModel Searches

### Example 4: Locate Model Usage
**Query**: "Which files use PatientListModel?"

**Expected Response**: Files containing `PatientListModel` instantiations or references

### Example 5: Find All ViewModels
**Query**: "List all ViewModel objects in these files"

**Expected Response**: All classes ending in "ViewModel" or "Model"

## Property and Binding Searches

### Example 6: Find Property Bindings
**Query**: "Find all bindings to userModel.userName"

**Expected Response**: All property assignments or bindings using that path

### Example 7: Search Signal Handlers
**Query**: "Show me all onClicked handlers"

**Expected Response**: All click event handlers with their parent objects

## Advanced Searches

### Example 8: Import Analysis
**Query**: "What models are imported in MainPage.qml?"

**Expected Response**: List of import statements for models/viewmodels

### Example 9: Component Dependencies
**Query**: "What components does this file depend on?"

**Expected Response**: List of all QML types used in the file

### Example 10: Cross-File References
**Query**: "Find all files that reference CaseExportViewModel"

**Expected Response**: Files that instantiate or import this ViewModel
