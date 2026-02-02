import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import AppPage 1.0 

Item {
    id: cranialQmlRoot
    anchors { fill: parent }

    Component.onDestruction: console.log("cranial.qml about to be destroyed")

    signal reloadQmlRequest

    RowLayout {
        anchors { fill: parent }
        spacing: 0

        ColumnLayout {
            Layout.fillHeight: true
            Layout.fillWidth: true
            spacing: 0

            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                spacing: 0

                Loader {
                    id: leftSidebarLoader
                    Layout.margins: item ? item.Layout.margins : 0
                    Layout.fillHeight: item ? item.Layout.fillHeight : 0
                    Layout.fillWidth: item ? item.Layout.fillWidth : 0
                    Layout.preferredWidth: item ? item.Layout.preferredWidth : 0
                    Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
                    source: applicationViewModel.pageContentList.leftSidebar

                    function reloadQml() {
                        console.log("**** LEFT RELOAD")
                        // Check that hot reload manager has expected signal.
                        // If not, this would indicate that hot reloading is not enabled.
                        if (hotReloadManager.reloadQmlRequest) {
                            source = ""
                            hotReloadManager.clearComponentCache()
                            source = Qt.binding(function() { return applicationViewModel.pageContentList.leftSidebar })
                            console.log("Completed hot reload of Cranial QML.")
                        } else {
                            console.log("Hot reload of Cranial QML requested but not enabled.")
                        }
                    }
                }

                Loader {
                    id: contentAreaLoader
                    Layout.margins: item ? item.Layout.margins : 0
                    Layout.fillHeight: item ? item.Layout.fillHeight : 0
                    Layout.fillWidth: item ? item.Layout.fillWidth : 0
                    Layout.preferredWidth: item ? item.Layout.preferredWidth : 0
                    Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
                    source: applicationViewModel.pageContentList.contentArea

                    function reloadQml() {
                        // Check that hot reload manager has expected signal.
                        // If not, this would indicate that hot reloading is not enabled.
                        if (hotReloadManager.reloadQmlRequest) {
                            source = ""
                            hotReloadManager.clearComponentCache()
                            source = Qt.binding(function() { return applicationViewModel.pageContentList.contentArea })
                            console.log("Completed hot reload of Cranial QML.")
                        } else {
                            console.log("Hot reload of Cranial QML requested but not enabled.")
                        }
                    }
                }
            }

            Loader {
                id: bottomBarLoader
                Layout.margins: item ? item.Layout.margins : 0
                Layout.fillHeight: item ? item.Layout.fillHeight : 0
                Layout.fillWidth: item ? item.Layout.fillWidth : 0
                Layout.preferredWidth: item ? item.Layout.preferredWidth : 0
                Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
                source: applicationViewModel.pageContentList.bottomBar

                function reloadQml() {
                    // Check that hot reload manager has expected signal.
                    // If not, this would indicate that hot reloading is not enabled.
                    if (hotReloadManager.reloadQmlRequest) {
                        source = ""
                        hotReloadManager.clearComponentCache()
                        source = Qt.binding(function() { return applicationViewModel.pageContentList.bottomBar })
                        console.log("Completed hot reload of Cranial QML.")
                    } else {
                        console.log("Hot reload of Cranial QML requested but not enabled.")
                    }
                }
            }
        }

        Loader {
            id: rightSidebarLoader
            Layout.margins: item ? item.Layout.margins : 0
            Layout.fillHeight: item ? item.Layout.fillHeight : 0
            Layout.fillWidth: item ? item.Layout.fillWidth : 0
            Layout.preferredWidth: item ? item.Layout.preferredWidth : 0
            Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
            source: applicationViewModel.pageContentList.rightSidebar

            function reloadQml() {
                // Check that hot reload manager has expected signal.
                // If not, this would indicate that hot reloading is not enabled.
                if (hotReloadManager.reloadQmlRequest) {
                    source = ""
                    hotReloadManager.clearComponentCache()
                    source = Qt.binding(function() { return applicationViewModel.pageContentList.rightSidebar })
                    console.log("Completed hot reload of Cranial QML.")
                } else {
                    console.log("Hot reload of Cranial QML requested but not enabled.")
                }
            }
        }


    }


    Connections {
        target: cranialQmlRoot
        onReloadQmlRequest: {
            leftSidebarLoader.reloadQml()
            contentAreaLoader.reloadQml()
            rightSidebarLoader.reloadQml()
            bottomBarLoader.reloadQml()
        }
    }

    Connections {
        target: hotReloadManager
        ignoreUnknownSignals: true

        onReloadQmlRequest: {
            leftSidebarLoader.reloadQml()
            contentAreaLoader.reloadQml()
            rightSidebarLoader.reloadQml()
            bottomBarLoader.reloadQml()
        }
    }

    Shortcut {
        enabled: applicationViewModel.labModeEnabled || applicationViewModel.testModeEnabled
        sequence: "Ctrl+D"
        onActivated: applicationViewModel.openDebugWindow()
    }

    Shortcut {
        enabled: true
        sequence: "Ctrl+R"
        onActivated: cranialQmlRoot.reloadQmlRequest()
    }
}

