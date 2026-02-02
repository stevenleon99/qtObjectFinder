import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

import ".."

Item {
    id: drillConfigurationsPanel
    Layout.preferredWidth: Theme.margin(54)
    Layout.fillHeight: true

    property var powerToolsPairingsViewModel

    ColumnLayout {
        anchors { fill: parent; leftMargin: Theme.marginSize; rightMargin: Theme.marginSize }
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: false
            Layout.preferredHeight: Theme.margin(8)
            spacing: Theme.margin(2)

            Rectangle {
                Layout.preferredWidth: Theme.margin(4)
                Layout.preferredHeight: width
                radius: width / 2
                color: powerToolsPairingsViewModel.arrayColor

                Label {
                    anchors { centerIn: parent }
                    state: "subtitle2"
                    text: powerToolsPairingsViewModel.arrayIndex
                }
            }

            Label {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(8)
                state: "h6"
                font.bold: true
                verticalAlignment : Text.AlignVCenter
                text: qsTr("Configurations")
            }

            LayoutSpacer {}

            Button {
                enabled: powerToolsPairingsViewModel.addConfigurationEnabled
                state: "icon"
                icon.source: "qrc:/icons/plus.svg"
                onClicked: powerToolsPairingsViewModel.addConfiguration()
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)
            RowLayout {
                anchors.centerIn: parent
                height: parent.height
                spacing: 0

                Repeater {
                    model: powerToolsPairingsViewModel.powerToolFamilyList

                    HeaderSelectionRectangle {
                        Layout.preferredWidth: Theme.margin(25)
                        active: powerToolsPairingsViewModel.selectedMotorId === role_motorToolId
                        text: qsTr(role_displayName)
                        icon.visible: false
                        label.font.capitalization: Font.MixedCase
                        label.font.pixelSize: 20
                        label.leftPadding: Theme.margin(2)
                        borderEnabled: false
                        onSelected: powerToolsPairingsViewModel.selectedMotorId = role_motorToolId
                    }
                }
            }

            DividerLine {
                anchors { bottom: parent.bottom }
                orientation: Qt.Horizontal
            }
        }

        DrillConfigurationList {
            id: drillConfigurationList
            Layout.topMargin: Theme.margin(2)

            powerToolsPairingsViewModel: drillConfigurationsPanel.powerToolsPairingsViewModel
        }

        LayoutSpacer {}
    }

    DescriptiveBackground {
        visible: drillConfigurationList.count === 0
        anchors { centerIn: parent }
        source: "qrc:/icons/drill.svg"
        text: qsTr("Add a Configuration")
    }

    DividerLine {
        anchors { right: parent.right }
    }
}
