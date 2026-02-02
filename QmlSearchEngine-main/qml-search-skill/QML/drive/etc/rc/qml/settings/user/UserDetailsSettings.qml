import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import DriveEnums 1.0

import ".."
import "../../components"

ColumnLayout {
    spacing: Theme.marginSize

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("General")
    }

    RowLayout {
        Layout.preferredHeight: Theme.margin(8)
        spacing: Theme.margin(4)

        SettingsDescription {
            title: qsTr("Measurement System")
            description: qsTr("Change the measurement system used in the software.")
        }

        RowLayout {
            Layout.preferredHeight: Theme.margin(8)
            spacing: Theme.marginSize

        Label {
            opacity: userViewModel.useMetric ? 1.0 : 0.5
            state: "body1"
            font.bold: true
            text: qsTr("Metric")
        }

        Switch {
            id: measurementSwitch
            checked: !userViewModel.useMetric
			
            onClicked: userViewModel.setUseMetric(!checked)
        }

        Label {
            opacity: userViewModel.useMetric ? 0.5 : 1.0
            state: "body1"
            font.bold: true
            text: qsTr("Imperial")
        }

        }
    }

    RowLayout {
        visible: driveMirrorViewModel.usingGPS && (connectionsViewModel.connectedPeerType !== ConnectedPeerType.E3d)

        Layout.preferredHeight: Theme.marginSize * 4
        spacing: Theme.margin(4)

        SettingsDescription {
            title: qsTr("Screen Mirroring")
            description: qsTr("Enable screen mirroring with ExcelsiusLaptop.")
        }

        CheckBox {
            checked: userViewModel.activeUser.isMirrorEnabled
            onClicked: {
                if (checked)
                {
                    console.log("Starting Mirror Server");
                    driveMirrorViewModel.startMirrorServer();
                } else {
                    console.log("Stopping Mirror Server")
                    driveMirrorViewModel.stopMirrorServer();
                }
                userViewModel.setMirrorEnbled(checked);
            }
        }
    }

    RowLayout {
        Layout.preferredHeight: Theme.marginSize * 4
        spacing: Theme.margin(4)

        SettingsDescription {
            title: qsTr("Onboarding Tutorial")
            description: qsTr("Launch the onboarding tutorial.")
        }

        Button {
            state: "active"
            text: qsTr("Launch Tutorial")

            onClicked: tutorialLoader.active = true

            TutorialLoader {
                id: tutorialLoader
                anchors.fill: parent
            }
        }
    }
}
