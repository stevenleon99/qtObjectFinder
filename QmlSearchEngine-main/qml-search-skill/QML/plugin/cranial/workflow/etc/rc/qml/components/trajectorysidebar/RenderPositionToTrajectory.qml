import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

RowLayout {
    spacing: Theme.margin(2)

    property bool areDistancesVisible: true

    property real distanceToTarget
    property real distanceToTrajectory
    property real acPcDistance

    property bool enableDistanceToTarget: true
    property bool enableDistanceToTrajectory: true

    signal acPressed()
    signal pcPressed()

    RowLayout {
        visible: areDistancesVisible
        spacing: Theme.margin(3)
        Layout.fillWidth: true

        RowLayout {
            Layout.preferredWidth: 1
            spacing: 0
            Layout.alignment: Qt.AlignVCenter

            IconImage {
                source: "qrc:/icons/trajectory-measuretotarget.svg"
                sourceSize: Theme.iconSize
                color: Theme.disabledColor
            }

            Label {
                Layout.fillWidth: true
                state: "h6"
                elide: Text.ElideNone
                text: enableDistanceToTarget ? distanceToTarget.toFixed(1) : "---"
            }
        }

        RowLayout {
            Layout.preferredWidth: 1
            spacing: 0
            Layout.alignment: Qt.AlignVCenter

            IconImage {
                source: "qrc:/icons/trajectory-measuretoline.svg"
                sourceSize: Theme.iconSize
                color: Theme.disabledColor
            }

            Label {
                Layout.fillWidth: true
                state: "h6"
                elide: Text.ElideNone
                text: enableDistanceToTrajectory ? distanceToTrajectory.toFixed(1) : "---"
            }
        }
    }


    LayoutSpacer { visible: !areDistancesVisible}

    RowLayout {
        Layout.fillWidth: false
        spacing: 0
        Layout.alignment: Qt.AlignVCenter
        opacity: acPcDistance > 0 ? 1 : 0

        Button {
            width: Theme.iconSize.width
            height: Theme.iconSize.height
            state: "icon"
            icon.source: "qrc:/icons/reset-ac.svg"

            onClicked: acPressed()
        }

        ColumnLayout {
            spacing: 0

            Label {
                Layout.fillWidth: true
                horizontalAlignment: Qt.AlignHCenter
                state: "h6"
                elide: Text.ElideNone
                text: acPcDistance.toFixed(1)
            }

            // TODO: Make this an arrow
            Rectangle {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 1
                Layout.preferredWidth: parent.width
                color: Theme.disabledColor
            }
        }

        Button {
            width: Theme.iconSize.width
            height: Theme.iconSize.height
            state: "icon"
            icon.source: "qrc:/icons/reset-pc.svg"

            onClicked: pcPressed()
        }
    }
}

