import QtQuick 2.6
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

/*
    This is a sample settings plugin to exercise how it would
    load and apply settings on the system. Actual implementation
    for each of the setting will be done with separate PR.
*/

Rectangle {
    id: root
    anchors.fill: parent
    visible: true
    color: "#5E8095"

    ColumnLayout {

        spacing: 20
        anchors.leftMargin: 10
        ColumnLayout {

            Label {
                text : qsTr("System")
                font.pixelSize: 22
                font.bold: true
            }

            RowLayout
            {
                Label {
                    text: qsTr("System Volume")
                    font.pixelSize: 16
                }
                SpinBox {
                    id: volume
                    value: 50
                    stepSize: 10
                }
            }

            RowLayout
            {
                Label {
                    text: qsTr("Screen Timeout")
                    font.pixelSize: 16
                }
                SpinBox {
                    id: timeout

                    value: 50
                    stepSize: 10
                }
            }
        }

        ColumnLayout {
            Label {
                text: qsTr("Connection")
                font.pixelSize: 22
                font.bold: true
            }

            RowLayout {
                Label {
                    text: qsTr("MAC Address")
                    font.pixelSize: 16
                }
            }

            Label {
                text: qsTr("IP Address Type")
                font.pixelSize: 16
            }

            RowLayout {
                CheckBox {
                    id: staticCheck
                    text: qsTr("Static")
                    checked: false
                    onCheckStateChanged: {
                        if(staticCheck.checkState === Qt.Checked)
                        {
                            dynamicCheck.checked = false
                        }
                        else if(staticCheck.checkState === Qt.Unchecked && dynamicCheck.checkState === Qt.Unchecked)
                        {
                            dynamicCheck.checked = true
                            ip.clear()
                            gateway.clear()
                            netmask.clear()
                        }
                    }
                }

                CheckBox {
                    id: dynamicCheck
                    text: qsTr("Dynamic")
                    checked: true
                    onCheckStateChanged: {
                        if(dynamicCheck.checkState === Qt.Checked)
                        {
                            staticCheck.checked = false
                            ip.clear()
                            gateway.clear()
                            netmask.clear()
                        }
                        else if(dynamicCheck.checkState === Qt.Checked && staticCheck.checkState === Qt.Unchecked)
                        {
                            staticCheck.checked = true
                        }
                    }
                }
            }

            ColumnLayout {
                Label {
                    text: qsTr("IP Address")
                    font.pixelSize: 16
                }

                TextField {
                    id: ip
                }

                Label {
                    text: qsTr("Netmask")
                    font.pixelSize: 16
                }

                TextField {
                    id: netmask
                }

                Label {
                    text: qsTr("Gateway")
                    font.pixelSize: 16
                }

                TextField {
                    id: gateway

                }

                Button {
                    id: applyButton
                    text: qsTr("Apply")
                    onClicked: {
                        if(staticCheck.checkState === Qt.Checked) {
                            console.log(ip.text)
                            settingsPlugin.setStaticIP(ip.text, netmask.text, gateway.text)
                        }
                        else if(dynamicCheck.checkState === Qt.Checked)
                        {
                            settingsPlugin.setDynamicIP()
                        }
                    }
                }
            }
        }

        ColumnLayout {
            Label {
                text: qsTr("Fluoroscopy Configurations")
                font.pixelSize: 22
                font.bold: true
            }

            RowLayout {

                ComboBox {
                    id: cb
                    width: 100
                    height: 60
                    model: ["PAL", "NTSC"]
                    onActivated: {
                        console.log(settingsPlugin.videoFormat)
                        settingsPlugin.setVideoFormat(cb.currentText)
                    }
                }
                Label {
                    text: qsTr("Video Output")
                    font.pixelSize: 16
                }
            }

            RowLayout {

                ComboBox {
                    width: 100
                    height: 60
                    model: ["9in IIT", "12in IIT", "31cm Sphere", "31cm Disk"]
                    onActivated: {
                        settingsPlugin.setFluoroFixtureSize(cb.currentText)
                    }

                }
                Label {
                    text: qsTr("Fixture Type")
                    font.pixelSize: 16
                }
            }

            RowLayout {

                ComboBox {
                    width: 100
                    height: 60
                    model: ["Off", "Low", "Medium", "High"]
                    onActivated: {
                        settingsPlugin.setFluoroSensitivity(cb.currentText)
                    }

                }
                Label {
                    text: qsTr("Fluoro Sensitivity")
                    font.pixelSize: 16
                }
            }
        }

        ColumnLayout {
            Label {
                text: qsTr("Troubleshooting")
                font.pixelSize: 22
                font.bold: true
            }

            RowLayout {
                Label {
                    text: qsTr("Export Data")
                    font.pixelSize: 16

                }

                Button {
                    id: logsBtn
                    text: qsTr("Export Logs")
                    onClicked: {
                        settingsPlugin.exportLogs()
                    }
                }

                Button {
                    id: screenshotsBtn
                    text: qsTr("Export Screenshots")
                    onClicked: {
                        settingsPlugin.exportScreenshots()
                    }
                }
            }

            RowLayout {
                Label {
                    text: qsTr("Reset Components")
                    font.pixelSize: 16
                }

                Button {
                    id: resetSoftwareBtn
                    text: qsTr("Reset Software")
                    onClicked: {
                        settingsPlugin.resetSoftware()
                    }
                }

                Button {
                    id: resetMotionBtn
                    text : qsTr("Reset Motion")
                    onClicked: {
                        settingsPlugin.resetMotion()
                    }
                }
            }
        }

        Button {
            id: loaderButton
            text: qsTr("Close")
            onClicked: {
                settingsPlugin.requestPluginQuit()
            }
        }
    }
}
