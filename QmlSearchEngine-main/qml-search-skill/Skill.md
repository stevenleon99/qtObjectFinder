# QML Search Engine Skill

## Description
This skill helps you search and analyze QT QML files for objects, components, ViewModels, and DVP (Data-View-Protocol) protocols in Qt/QML codebases. It's designed to help developers navigate large QML projects, understand component relationships, and locate specific objects quickly.

## Instructions
When a user query is received:
1. Traverse QML file structure to identify objects, components, and imports
2. Search for specific object types, IDs, or property names
3. Identify ViewModels and Model usage patterns
4. Map relationships between QML components and C++ backend models
5. Help locate DVP protocol implementations and usages

## Capabilities
- Search QML files for specific object types (Button, ListView, Rectangle, etc.)
- Find ViewModels and backend models (e.g., PatientListModel, CaseItemModel)
- Locate object IDs and property bindings
- Identify signal handlers and method invocations
- Analyze component hierarchies and dependencies
- Map DVP protocol usage across files

## Key Concepts
- **QML Objects**: Visual and non-visual items (Item, Rectangle, Button, ListView, etc.)
- **ViewModels**: C++ classes exposed to QML for business logic (e.g., ApplicationViewModel, PatientDetailsModel)
- **DVP Protocols**: Design Verification Protocols for GUI features
- **Property Bindings**: Dynamic connections between QML properties

## Use Cases
1. **Find all instances of a specific object type**: "Search for all Button objects"
2. **Locate ViewModel usage**: "Which QML files use PatientListModel?"
3. **Identify property bindings**: "Find all properties bound to caseViewModel.caseName"
4. **Search by object ID**: "Find the object with id: submitButton"
5. **Analyze dependencies**: "What models does this QML file import?"
6. **Refactoring support**: "List all files that reference UserViewModel"

## Technical Details
- Supports Qt 5.x and Qt 6.x QML syntax
- Understands standard QML types and custom components
- Recognizes C++ model integration patterns
- Handles property bindings, signal handlers, and method calls
- Can parse import statements and component hierarchies

## Limitations
- Only analyzes QML files (not C++ implementation files)
- Requires syntactically correct QML (may not parse files with errors)
- Cannot execute or run QML code
- Does not validate property types or bindings at runtime

## Resources

See the `resources/` folder for:

- **search-examples.md**  
	Practical examples of search queries in JSON format and their expected results. Demonstrates how to structure requests and interpret responses for common QML search scenarios.

- **dvp-protocols.md**  
	Reference for Data-View-Protocol (DVP) usage in QML, including protocol types (User, Patient, Case, System, etc.), common usage patterns, and how to recognize protocol usage in QML files.

- **query-reply-format.md**  
	Defines the standard JSON structure for search queries and replies, including required fields and example formats for both requests and responses.

- **qml-file-structure.md**  
	Outlines the typical structure of QML files, including common directories and file organization patterns to help users navigate QML codebases effectively.

