import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0
import PageEnum 1.0

Item {
    id: spineQmlRoot
    anchors { fill: parent }

    Component.onDestruction: console.log("spine.qml about to be destroyed")

    signal reloadQmlRequest

    RowLayout {
        anchors { fill: parent }
        spacing: 0

        Repeater {
            model: applicationViewModel.pageContentList

            Loader {
                id: spineQmlLoader
                Layout.margins: item ? item.Layout.margins : 0
                Layout.fillHeight: item ? item.Layout.fillHeight : 0
                Layout.fillWidth: item ? item.Layout.fillWidth : 0
                Layout.preferredWidth: item ? item.Layout.preferredWidth : 0
                Layout.preferredHeight: item ? item.Layout.preferredHeight : 0
                source: role_source

                function reloadQml() {
                    // Check that hot reload manager has expected signal.
                    // If not, this would indicate that hot reloading is not enabled.
                    if (hotReloadManager.reloadQmlRequest) {
                        source = ""
                        hotReloadManager.clearComponentCache()
                        source = Qt.binding(function() { return role_source })
                        console.log("Completed hot reload of Spine QML.")
                    } else {
                        console.log("Hot reload of Spine QML requested but not enabled.")
                    }
                }

                Connections {
                    target: spineQmlRoot
                    function onReloadQmlRequest() {
                        spineQmlLoader.reloadQml()
                    }
                }

                Connections {
                    target: hotReloadManager
                    ignoreUnknownSignals: true

                    function onReloadQmlRequest() {
                        spineQmlLoader.reloadQml()
                    }
                }
            }
        }
    }

    Shortcut {
        enabled: applicationViewModel.labModeEnabled || applicationViewModel.testModeEnabled
        sequence: "Ctrl+D"
        onActivated: applicationViewModel.openDebugWindow(false)
    }

    Shortcut {
        enabled: true
        sequence: "Ctrl+T"
        onActivated: applicationViewModel.dumpTransforms()
    }

    Shortcut {
        enabled: true
        sequence: "Ctrl+R"
        onActivated: spineQmlRoot.reloadQmlRequest()
    }

    Shortcut {
        enabled: true
        sequence: "Alt+H"
        onActivated: applicationViewModel.recordEeTargetHeight()
    }

    // SPINE-1972: Temporary measure to capture eHub foot pedal press while it isn't compatible with IFootPedal
    Shortcut {
        enabled: true
        sequence: "Alt+P"
        onActivated: applicationViewModel.simulateFootPedalPress()
    }
}

