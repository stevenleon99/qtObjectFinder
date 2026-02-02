import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4
import QtMultimedia 5.12

import Theme 1.0

ColumnLayout {
    spacing: Theme.margin(4)

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
            spacing: Theme.margin(4)

            SettingsDescription {
                title: qsTr("Volume")
                description: qsTr("Change the application sound volume. Sound cannot be muted.")
            }

            SpinBox {
                id: volumeControl
                enabled: settingsPlugin.audioVolume >= 0
                opacity: enabled ? 1.0 : 0.5
                Layout.alignment: Qt.AlignTop
                Layout.preferredHeight: Theme.margin(8)
                Layout.preferredWidth: Theme.margin(25)
                stepSize: 10
                from: 10
                to: 100
                value: settingsPlugin.audioVolume

                onValueModified: {
                    settingsPlugin.audioVolume = value;
                    testSound.play();
                }
            }

            SoundEffect {
                id: testSound
                source: "qrc:/sounds/good.wav"
            }
        }

        Label {
            visible: !volumeControl.enabled
            state: "body1"
            padding: Theme.margin(1)
            leftPadding: Theme.margin(6)
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

    RowLayout {
        spacing: Theme.margin(4)

        SettingsDescription {
            title: qsTr("Screen Timeout")
            description: qsTr("Change the length of time before the screen timout and logoff.")
        }

        SpinBox {
            Layout.alignment: Qt.AlignTop
            Layout.preferredHeight: Theme.margin(8)
            Layout.preferredWidth: Theme.margin(25)
            stepSize: 10
            from: 10
            to: 500
            value: settingsPlugin.screenTimeout

            onValueModified: settingsPlugin.screenTimeout = value
        }
    }
}
