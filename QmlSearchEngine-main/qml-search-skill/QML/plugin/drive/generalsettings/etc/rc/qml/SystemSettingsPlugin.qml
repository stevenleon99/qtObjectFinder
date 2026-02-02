import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import "./" 
//import "common"
import "qrc:/drive/qml/settings/"

ColumnLayout {
    objectName: "systemSettingsPluginColumnLayout"
    x: Theme.margin(6)
    width: parent.width
    spacing: Theme.marginSize * 2

    MenuSection {
        objectName: "systemSettingsSection"
        Layout.fillWidth: true
        title: qsTr("System")
        sourceComponent: Loader {
            Layout.margins: item ? item.Layout.margins : 0
            Layout.fillHeight: item ? item.Layout.fillHeight : 0
            Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
            active: true
            source: "GeneralSettings.qml"
        }
    }

    DividerLine {
        Layout.fillWidth: true
    }

    MenuSection {
        objectName: "networkSettingsSection"
        Layout.fillWidth: true
        title: qsTr("Network")
        sourceComponent: Loader {
            Layout.margins: item ? item.Layout.margins : 0
            Layout.fillHeight: item ? item.Layout.fillHeight : 0
            Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
            active: true
            source: "NetworkSettings.qml"
        }
    }

    DividerLine {
        Layout.fillWidth: true
    }

    MenuSection {
        objectName: "pacsSettingsSection"
        Layout.fillWidth: true
        title: qsTr("PACS")
        sourceComponent: Loader {
            Layout.margins: item ? item.Layout.margins : 0
            Layout.fillHeight: item ? item.Layout.fillHeight : 0
            Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
            active: true
            source: "ScanManagerSettings.qml"
        }
    }

    DividerLine {
        Layout.fillWidth: true
    }

    MenuSection {
        objectName: "fluoroscopySettingsSection"
        Layout.fillWidth: true
        title: qsTr("Fluoroscopy")
        sourceComponent: Loader {
            Layout.margins: item ? item.Layout.margins : 0
            Layout.fillHeight: item ? item.Layout.fillHeight : 0
            Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
            active: true
            source: "FluoroscopySettings.qml"
        }
    }

    DividerLine {
        Layout.fillWidth: true
    }

    MenuSection {
        objectName: "troubleshootingSettingsSection"
        Layout.fillWidth: true
        title: qsTr("Troubleshooting")
        sourceComponent: Loader {
            Layout.margins: item ? item.Layout.margins : 0
            Layout.fillHeight: item ? item.Layout.fillHeight : 0
            Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
            active: true
            source: "TroubleshootingSettings.qml"
        }
    }

    DividerLine {
        Layout.fillWidth: true
    }

    MenuSection {
        objectName: "licensingSettingsSection"
        Layout.fillWidth: true
        title: qsTr("Licensing")
        sourceComponent: Loader {
            Layout.margins: item ? item.Layout.margins : 0
            Layout.fillHeight: item ? item.Layout.fillHeight : 0
            Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
            active: true
            source: "LicensingSettings.qml"
        }
    }
}
