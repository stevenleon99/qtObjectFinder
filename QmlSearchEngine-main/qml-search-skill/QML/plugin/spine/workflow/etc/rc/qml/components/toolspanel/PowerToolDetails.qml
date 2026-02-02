import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Templates 2.4 as T
import QtQuick.Window 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import ".."

ColumnLayout {
    visible: powerToolDetailsViewModel.detailsVisible
    Layout.fillWidth: true
    Layout.fillHeight: true

    spacing: 0

    signal editClicked

    states: [
        State {
            name: "toolVerification"
            PropertyChanges { target: toolDetailsRow;  visible: false }
            PropertyChanges { target: positionRow; visible: false }
            PropertyChanges { target: dropdownTitle;  visible: false }
            PropertyChanges { target: toolFamilyLabel;  visible: true }
            PropertyChanges {
                target: dropdown
                width: Math.min(parent.width, implicitWidth)
                height: Theme.margin(4)
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                color: Theme.navyLight
                borderEnabled: false
                popupWidth: Theme.margin(41)
                popupLeftAlignment: false
            }
        }
    ]

    PowerToolDetailsViewModel {
        id: powerToolDetailsViewModel

        onSelectedConfigurationIdChanged: dropdown.updateSelection()
    }

    Connections {
        target: powerToolDetailsViewModel.configurations

        onDataChanged: dropdown.updateSelection()
    }

    RowLayout {
        id: toolDetailsRow
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.margin(8)
        spacing: Theme.margin(2)

        Rectangle {
            Layout.preferredWidth: Theme.margin(4)
            Layout.preferredHeight: Layout.preferredWidth
            radius: width / 2
            border { width: 3; color: powerToolDetailsViewModel.arrayColor }
            color: Theme.transparent

            Label {
                id: indexText
                visible: powerToolDetailsViewModel.arrayIndex
                anchors.centerIn: parent
                state: "button1"
                text: powerToolDetailsViewModel.arrayIndex
            }
        }

        Label {
            Layout.fillWidth: true
            state: "h5"
            font.bold: true
            text: powerToolDetailsViewModel.motorFamilyDisplayName
        }

        IconImage {
            visible: !powerToolDetailsViewModel.loaded
            Layout.rightMargin: Theme.margin(2)
            sourceSize: Theme.iconSize
            source: "qrc:/images/navigation-disabled.svg"
            color: Theme.navyLight
        }
    }

    Label {
        id: dropdownTitle
        Layout.bottomMargin: 4
        state: "body1"
        color: Theme.navyLight
        text: qsTr("Pairing")
    }

    RowLayout {
        Layout.fillWidth: true

        Label {
            id: toolFamilyLabel
            visible: false
            Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
            state: "body1"
            font.bold: true
            text: powerToolDetailsViewModel.motorFamilyDisplayName
        }

        Item {
           Layout.fillWidth: true
           Layout.preferredHeight: Theme.margin(6)

           OptionsDropdown {
               id: dropdown

               enabled: count > 0
               height: parent.height
               width: parent.width - Theme.margin(1)
               textRole: "role_displayName"
               model: powerToolDetailsViewModel.configurations

               function updateSelection() {
                   if (powerToolDetailsViewModel.selectedConfigurationId) {
                       for( var indexVal = 0; indexVal < count; indexVal++ ) {
                           var item = delegateModel.items.get(indexVal)
                           if (item.model.role_key == powerToolDetailsViewModel.selectedConfigurationId) {
                               currentIndex = indexVal
                               dropdown.displayText =  Qt.binding(function() { return dropdown.currentText })
                               return
                           }
                       }
                   }

                   dropdown.displayText = qsTr("No Config Selected")
                   currentIndex = -1
               }

               onModelChanged: updateSelection()

               onCountChanged: updateSelection()

               onActivated: {
                   var item = delegateModel.items.get(index)
                   if (item.model.role_key) {
                       powerToolDetailsViewModel.selectConfigurationId(item.model.role_key)
                   }
               }

               Component.onCompleted: updateSelection()
           }
        }
    }

    RowLayout {
        id: positionRow
        visible: powerToolDetailsViewModel.refPosDisplayEnabled
        Layout.fillWidth: true
        Layout.topMargin: Theme.margin(2)
        Layout.rightMargin: Theme.margin(1)

        Label {
            Layout.fillWidth: true
            state: "body1"
            color: Theme.navyLight
            text: "Position"
        }

        PairedToolOrientationButton {
            positionText: powerToolDetailsViewModel.selectedRefPosition
            positionIcon: powerToolDetailsViewModel.refPositionIcon
            positionRotation: powerToolDetailsViewModel.refPositionIconRotation

            onClicked: powerToolDetailsViewModel.incrementRefPosition()
        }
    }
}
