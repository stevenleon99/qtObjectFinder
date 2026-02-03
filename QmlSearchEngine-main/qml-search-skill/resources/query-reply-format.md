# Query and Reply Format

This document defines the standard JSON structure for search queries and their expected replies when searching QML files.

## Query Format

Each search query should be a JSON object with the following fields:

```json
{
    "application": "<Application Name>",
    "component": "<Component or object to search>",
    "description": "<Optional description of the search>"
}
```

**Example:**

```json
{
    "application": "Drive.exe",
    "component": "login confirm button",
    "description": "QT object for confirming login pin in Drive.exe"
}
```

## Reply Format

The reply to a search query should be a JSON object containing a `results` array. Each result includes details about the matched QML object.

```json
{
    "results": [
        {
            "file": "<File path>",
            "objectName": "<QML object id>",
            "objectType": "<QML type>",
            "context": "<Context or parent object>",
            "lineNumber": <Line number>,
            "snippet": "<Relevant QML code snippet>"
        }
        // ... more results
    ]
}
```

**Example:**

```json
{
    "results": [
        {
            "file": "D:/Program Files/Medtronic/Drive/Resources/qml/Login/LoginPinPage.qml",
            "objectName": "confirmButton",
            "objectType": "Button",
            "context": "LoginPinPage",
            "lineNumber": 45,
            "snippet": "Button { id: confirmButton; text: qsTr(\"Confirm\"); onClicked: loginViewModel.confirmPin() }"
        }
    ]
}
```