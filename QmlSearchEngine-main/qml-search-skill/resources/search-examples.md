# QML Search Examples
This document provides sample queries and expected responses for searching QML files using the QML Search Skill.

## Example 1: Find pinpad login object

### query
```json
{
    "application": "Drive.exe",
    "component": "login pinpad",
    "description": "QT object for entering login pin in Drive.exe"
}
```


### expected reply
```json
{
  "results": [
    {
      "file": "d:/qtObjectFinder/QmlSearchEngine-main/qml-search-skill/QML/drive/etc/rc/qml/login/Pinpad.qml",
      "objectName": "pinPad",
      "objectType": "GridView",
      "context": "Login Pinpad Grid Container",
      "lineNumber": 254,
      "snippet": "GridView { id: pinPad; enabled: userViewModel.loginAttemptsRemaining > 0; Layout.preferredWidth: 336; Layout.preferredHeight: 448; cellWidth: width / 3; cellHeight: height / 4; model: [ \"1\", \"2\", \"3\", \"4\", \"5\", \"6\", \"7\", \"8\", \"9\", \"CLEAR\", \"0\", \"UNLOCK\" ] }"
    },
    {
      "file": "d:/qtObjectFinder/QmlSearchEngine-main/qml-search-skill/QML/drive/etc/rc/qml/login/Pinpad.qml",
      "objectName": "pinPadButton_<digit>",
      "objectType": "Item (Delegate)",
      "context": "Individual Grid Button",
      "lineNumber": 267,
      "snippet": "delegate: Item { objectName: \"pinPadButton_\" + pinText.text; Rectangle { id: pin; radius: width / 2; border { color: Theme.white } }; MouseArea { onClicked: numberPressed(modelData) } }"
    }
  ]
}
```

## Example 2: Create a new patient
### query
```json
{
    "application": "Drive.exe",
    "component": "create new patient folder",
    "description": "QT object for creating a new patient folder in Drive.exe"
}
```

### expected reply
```json
{
  "results": [
    {
      "file": "d:/qtObjectFinder/QmlSearchEngine-main/qml-search-skill/QML/drive/etc/rc/qml/patients/Patients.qml",
      "objectName": "autoUINewPatientBtnObj",
      "objectType": "Button",
      "context": "Patients Page Header",
      "lineNumber": 63,
      "snippet": "Button { objectName: \"autoUINewPatientBtnObj\"; width: 100; height: 48; state: \"active\"; text: qsTr(\"New Patient\"); icon.source: \"qrc:/icons/plus.svg\"; onClicked: newPatientPopup.open() }"
    },
    {
      "file": "d:/qtObjectFinder/QmlSearchEngine-main/qml-search-skill/QML/drive/etc/rc/qml/patients/NewPatientPopup.qml",
      "objectName": "firstNameInput",
      "objectType": "TitledTextField",
      "context": "Patient First Name Input",
      "lineNumber": 70,
      "snippet": "TitledTextField { id: firstNameInput; Layout.preferredWidth: Theme.margin(30); title: qsTr(\"First Name\") }"
    },
    {
      "file": "d:/qtObjectFinder/QmlSearchEngine-main/qml-search-skill/QML/drive/etc/rc/qml/patients/NewPatientPopup.qml",
      "objectName": "lastNameInput",
      "objectType": "TitledTextField",
      "context": "Patient Last Name Input",
      "lineNumber": 74,
      "snippet": "TitledTextField { id: lastNameInput; Layout.preferredWidth: Theme.margin(30); title: qsTr(\"Last Name\") }"
    },
    {
      "file": "d:/qtObjectFinder/QmlSearchEngine-main/qml-search-skill/QML/drive/etc/rc/qml/patients/NewPatientPopup.qml",
      "objectName": "dobInput",
      "objectType": "TitledTextField",
      "context": "Date of Birth Input",
      "lineNumber": 80,
      "snippet": "TitledTextField { id: dobInput; Layout.preferredWidth: Theme.margin(30); placeholderText: \"MM-DD-YYYY\"; validator: RegExpValidator { regExp: dateRegExp }; title: qsTr(\"Date of Birth (MM-DD-YYYY)\") }"
    },
    {
      "file": "d:/qtObjectFinder/QmlSearchEngine-main/qml-search-skill/QML/drive/etc/rc/qml/patients/NewPatientPopup.qml",
      "objectName": "autoUIPatientCreateBtnObj",
      "objectType": "Button",
      "context": "Create Patient Button",
      "lineNumber": 123,
      "snippet": "Button { objectName: \"autoUIPatientCreateBtnObj\"; Layout.preferredWidth: 128; enabled: firstNameInput.text && lastNameInput.text && dobInput.text && dobInput.text.match(dateRegExp); state: \"active\"; text: qsTr(\"Create\"); onClicked: { createClicked(lastNameInput.text, firstNameInput.text, dobInput.text); close() } }"
    }
  ]
}
```