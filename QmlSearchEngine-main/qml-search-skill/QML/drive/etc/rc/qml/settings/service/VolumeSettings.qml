import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4
import QtMultimedia 5.12

import Theme 1.0
import GmQml 1.0

ColumnLayout {
    spacing: Theme.marginSize * 2

    property int volumeValue: 50

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("System")
    }


    ColumnLayout {
        spacing: Theme.margin(1)

        RowLayout {
            Layout.preferredHeight: Theme.marginSize * 4
            spacing: Theme.marginSize

            ColumnLayout {
                spacing: Theme.margin(1)

                Label {
                    Layout.fillWidth: true
                    state: "h6"
                    font.bold: true
                    text:  qsTr("System Volume")
                }

                Label {
                    state: "body1"
                    text:  qsTr("Change the system sound volume.")
                }
            }

            IconImage {
                id: icon
                sourceSize: Theme.iconSize
                source: volumeSlider.value === 100 ?
                            "qrc:/icons/volume-high.svg" :
                            volumeSlider.value === 0 ?
                                "qrc:/icons/volume-off.svg" :
                                "qrc:/icons/volume-low.svg"
            }

            Slider {
                id: volumeSlider
                enabled: serviceSettingsViewModel.systemVolume >= 0
                Layout.preferredWidth: Theme.margin(30)
                from: 0
                to: 100
                stepSize: 1
                value: serviceSettingsViewModel.systemVolume

                onMoved: {
                    serviceSettingsViewModel.systemVolume = volumeSlider.value;
                    soundTimer.restart();
                }
            }

            SoundEffect {
                id: testSound
                source: "qrc:/sounds/good.wav"
            }

            Timer  {
                id: soundTimer
                interval: 300;
                onTriggered: testSound.play()
            }

            Label {
                Layout.preferredWidth: Theme.margin(6)
                state: "body1"
                horizontalAlignment: Label.AlignRight
                text: (volumeSlider.enabled ? serviceSettingsViewModel.systemVolume : 0)  + "%"
            }
        }

        Label {
            visible: !volumeSlider.enabled
            padding: Theme.margin(1)
            leftPadding: Theme.margin(6)
            state: "body1"
            text:  qsTr("Volume control inactive. Restart system if necessary.")

            background: Rectangle {
                opacity: 0.3
                width: implicitWidth
                height: implicitHeight
                radius: 8
                color: Theme.red
            }

            IconImage {
                anchors { left: parent.left; leftMargin: Theme.margin(1); verticalCenter: parent.verticalCenter }
                sourceSize: Theme.iconSize
                source: "qrc:/icons/alert-stop.svg"
                color: Theme.red
            }
        }
    }
}
