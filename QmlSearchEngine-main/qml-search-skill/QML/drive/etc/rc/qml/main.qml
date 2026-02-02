import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtWebEngine 1.0

import Theme 1.0
import DriveEnums 1.0
import GmQml 1.0

import "header"
import "components"

ApplicationWindow {
    id: appWindow

    Component.onCompleted: pluginModel.windowCreated(this)

    header: ApplicationHeader {
        visible: drivePageViewModel.currentPage !== DrivePage.Login
    }

    Loader {
        id: loader
        objectName: "autoPluginLoader"
        anchors { fill: parent; bottomMargin: 1 }

        source: "qrc:/drive/qml/login/Login.qml"

        states: [
            State {
                when: drivePageViewModel.currentPage === DrivePage.Login
                PropertyChanges { target: loader; source: "qrc:/drive/qml/login/Login.qml" }
            },
            State {
                when: drivePageViewModel.currentPage === DrivePage.Cases
                PropertyChanges { target: loader; source: "qrc:/drive/qml/cases/Cases.qml" }
            },
            State {
                when: drivePageViewModel.currentPage === DrivePage.Patients
                PropertyChanges { target: loader; source: "qrc:/drive/qml/patients/Patients.qml" }
            },
            State {
                when: drivePageViewModel.currentPage === DrivePage.Workflow
                PropertyChanges { target: loader; source: "qrc:/drive/qml/workflow/Workflow.qml" }
            },
            State {
                when: drivePageViewModel.currentPage === DrivePage.Settings
                PropertyChanges { target: loader; source: "qrc:/drive/qml/settings/Settings.qml" }
            }
        ]
    }

    // workaround: Load settings plugin UI on top of workflow plugin.
    // This is added to avoid unloading workflow plugin when
    // settings is selected during the workflow. This need to be removed
    // after adding the fix in plugin launcher interface and plugin model.
    Loader {
        id: settingsPluginLoader
        anchors { fill: parent }
        active: false
        source: "qrc:/drive/qml/settings/SettingsPage.qml"
    }

    Loader {
        anchors { fill: parent }
        active: alertViewModel.currentAlert &&
                (alertViewModel.currentAlert.title === "Account Creation Failed" ||
                 alertViewModel.currentAlert.title === "Account Already Active" ||
                 alertViewModel.currentAlert.title === "Confirm Shut Down?" ||
                 drivePageViewModel.currentPage !== DrivePage.Login)
        source: "qrc:/drive/qml/components/AlertView.qml"
    }

    Label {
        visible: watermarkViewModel.watermarkMode != watermarkViewModel.None
        opacity: 0.5
        anchors { left: parent.left; bottom: parent.bottom; margins: Theme.margin(2) }
        state: "h1"
        text: switch (watermarkViewModel.watermarkMode) {
              case WatermarkMode.Lab: return qsTr("Lab")
              case WatermarkMode.Service: return qsTr("Service")
              case WatermarkMode.Test: return qsTr("Test")
              case WatermarkMode.Nonproduction: return qsTr("Non-production")
              default: ""
              }
    }

    Sounds { }
    ScreenTimeout {}

    // No need to load virtual keyboard if the system type is laptop. Virtual
    // keyboard may even not be functional/available, in which case attempting
    // to load it will result in a crash (SPINE-1064).
    Loader {
        active: userViewModel.platformType != PlatformType.Laptop
        source: "qrc:/imports/GmQml/OverlayInputPanel.qml"
    }
}
