import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Dialogs 1.3

import Theme 1.0
import GmQml 1.0

ApplicationWindow {
    id: appWindow

    fixedWidth: Theme.margin(105)
    fixedHeight: Theme.margin(60)

    flags: Qt.Dialog
    title: "Spine Debug Window"

    onClosing: gmDebug.closed()

    Rectangle {
        id: rectangle
        anchors { fill: parent }
        radius: 4
        color: Theme.foregroundColor

        ColumnLayout {
            id: layout
            anchors { fill: parent }
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(8)
                Layout.alignment: Qt.AlignTop
                clip: true

                Rectangle {
                    radius: 4
                    width: rectangle.width
                    height: rectangle.height
                    color: Theme.headerColor
                }

                Label {
                    id: headerText
                    anchors { centerIn: parent }
                    state: "h5"
                    text: qsTr("Spine Debug Window")
                }
            }

            RowLayout {
                Layout.margins: Theme.marginSize
                Layout.alignment: Qt.AlignTop
                Layout.fillHeight: false
                spacing: Theme.margin(8)

                Label {
                    state: "h6"
                    text: qsTr("Verify all tracked tools")
                }

                Button {
                    state: "active"
                    text: qsTr("Verify")
                    onClicked: gmDebug.verifyAllInstruments()
                }
            }
            
            Loader {
                sourceComponent: meshGateway != undefined ? meshInfo : undefined
            }

            Component {
                id: meshInfo
                RowLayout {
                    Layout.margins: Theme.marginSize
                    Layout.alignment: Qt.AlignTop
                    Layout.fillHeight: false
                    spacing: Theme.margin(8)
                    visible: meshGateway != undefined

                    Label {
                        state: "h6"
                        text: qsTr("Generate XR Mesh")
                    }

                    Button {
                        state: "active"
                        text: qsTr("Generate")
                        onClicked: meshGateway.buildMeshFromSelectedScan()
                    }

                    Label {
                        state: "h6"
                        text: meshGateway.status
                    }
                }
            }

            DividerLine {}

            RowLayout {
                Layout.margins: Theme.marginSize
                Layout.alignment: Qt.AlignTop
                Layout.fillHeight: false
                spacing: Theme.margin(8)

                Label {
                    Layout.alignment: Qt.AlignVCenter
                    state: "h6"
                    text: qsTr("Detect Accuracy test points")
                }

                ColumnLayout {
                    RowLayout {
                        TextField {
                            id: thresholdsText
                            text: gmDebug.accLaplacianThresholds
                        }

                        Button {
                            enabled: thresholdsText.text !== gmDebug.accLaplacianThresholds
                            state: "active"
                            text: qsTr("Set")
                            onClicked: gmDebug.setAccLaplacianThresholds(thresholdsText.text)
                        }
                    }

                    RowLayout {
                        Button {
                            text: qsTr("Select File..")
                            state: "active"
                            onClicked: fileDialog.open()
                        }

                        FileDialog {
                            id: fileDialog
                            title: "Select a File"
                            folder: shortcuts.home
                            nameFilters: ["All Files (*)"]
                            onAccepted: {
                                console.log("Selected file:", fileUrl)
                                loadFileButton.visible = true;
                            }
                            onRejected: {
                                console.log("File selection canceled")
                                loadFileButton.visible = false;
                            }
                        }

                        Button {
                            id: loadFileButton
                            visible: false
                            state: "active"
                            text: qsTr("Load")
                            onClicked: gmDebug.detectFileAccTestPoints(fileDialog.fileUrl)
                        }
                    }

                    RowLayout {
                       spacing: Theme.margin(2)

                        Button {
                            enabled: !gmDebug.detectingAccTestPoints
                            state: "active"
                            text: qsTr("CT")
                            onClicked: gmDebug.detectCtAccTestPoints()
                        }

                        Button {
                            enabled: !gmDebug.detectingAccTestPoints
                            state: "active"
                            text: qsTr("Fluoro CT")
                            onClicked: gmDebug.detectFluoroCtAccTestPoints()
                        }

                        Button {
                            enabled: !gmDebug.detectingAccTestPoints
                            state: "active"
                            text: qsTr("Field CT")
                            onClicked: gmDebug.detectFieldCtAccTestPoints()
                        }
                    }

                    Label {
                        visible: text
                        Layout.alignment: Qt.AlignHCenter
                        state: "subtitle2"
                        text: gmDebug.detectAccTestPointStatus
                    }
                }
            }

            DividerLine {}

            LayoutSpacer {}
        }
    }

    Connections {
        target: gmDebug

        function onRestoreDebugWindow() {
            appWindow.raise()
        }
    }
}
