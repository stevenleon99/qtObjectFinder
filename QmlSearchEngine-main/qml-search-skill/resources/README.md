# QML Search Skill Resources

This folder contains reference materials to help Claude understand and search QML files effectively.

## Files in This Folder

### 1. search-examples.md
Example queries and expected responses when searching QML files.
- Basic object searches
- ViewModel location queries
- Property binding searches
- Advanced cross-file analysis

### 2. dvp-protocols.md
Reference guide for DVP (Data-View-Protocol) protocols used in the QML codebase.
- Protocol categories (User, Patient, Case, System, etc.)
- Common patterns and usage examples
- How to identify protocol usage in QML files

### 3. qml-patterns.md
Common QML code patterns found in Qt applications.
- Model instantiation examples
- Property binding patterns
- Signal handler patterns
- Component hierarchies

## How to Use This Skill

1. **Upload your QML files** to the conversation
2. **Ask questions** using natural language
3. **Reference the examples** in search-examples.md for query inspiration

## Example Workflow

```
1. Upload: MainPage.qml, PatientView.qml, CaseList.qml
2. Ask: "Which files use PatientListModel?"
3. Claude searches and responds with matching files
4. Ask: "Show me all the property bindings in PatientView.qml"
5. Claude lists all property bindings found
```

## Tips for Better Results

- Be specific about what you're looking for
- Mention file names if searching in specific files
- Use terminology from dvp-protocols.md for better understanding
- Ask follow-up questions to drill down into details

## Skill Limitations

- Only analyzes uploaded QML files (cannot access local file system)
- Requires valid QML syntax
- Cannot execute or validate QML code
- Does not analyze C++ implementation files
