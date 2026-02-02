import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import "../components"

import ViewModels 1.0
import Theme 1.0
import GmQml 1.0

import Enums 1.0

Item {
    id: setupOverview

    Layout.preferredWidth: Theme.margin(195)
    Layout.fillHeight: true

    property alias caseSetupSpineModelViewModelAlias: caseSetupSpineModelViewModel

    CaseSetupSpineModelViewModel {
        id: caseSetupSpineModelViewModel
    }

    Label {
        x: Theme.margin(2)
        height: Theme.margin(8)
        state: "subtitle2"
        verticalAlignment: Label.AlignVCenter
        font.bold: true
        font.letterSpacing: 1
        color: Theme.headerTextColor
        text: qsTr("OVERVIEW")
    }

    RowLayout {
        anchors { top: parent.top; horizontalCenter: parent.horizontalCenter }
        height: Theme.margin(8)

        Label {
            Layout.alignment: Qt.AlignVCenter
            state: "button1"
            text: qsTr("Bilateral")
            color: planSwitch.unilateral ? Theme.navyLight : Theme.white
        }

        Switch {
            id: planSwitch
            objectName: "caseSetupPlanSwitch"
            Layout.alignment: Qt.AlignVCenter
            checked: false

            property bool unilateral: planSwitch.checked
        }

        Label {
            Layout.alignment: Qt.AlignVCenter
            state: "button1"
            text: qsTr("Unilateral")
            color: planSwitch.unilateral ? Theme.white : Theme.navyLight
        }
    }

    Flickable {
        id: flickable
        objectName: "caseSetupFlickable"
        anchors { fill: parent; topMargin: Theme.margin(8) }
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.VerticalFlick
        contentWidth: image.width
        contentHeight: image.height
        clip: true

        Image {
            id: image
            x: (flickable.width / 2) - (width / 2)
            width: Theme.margin(135)
            source: "qrc:/images/Spine/spine.png"
            // Commented out to allow drive to exit correctly without freezing
            // asynchronous: true 
            fillMode: Image.PreserveAspectFit

            Loader {
                anchors { fill: parent }
                active: image.status == Image.Ready &&
                        caseSetupSpineModelViewModel.selectedImplantSetType != ImplantTypes.Unknown
                sourceComponent: AnatomyImplantSelection {
                    caseSetupSpineModelViewModel: caseSetupSpineModelViewModelAlias
                    bilateral: !planSwitch.unilateral
                }
            }

            onStatusChanged: {
                if (status == Image.Ready)
                    flickable.contentY = caseSetupSpineModelViewModel.spineModelPosition
            }
        }
    }

    CaseName {
        anchors { right: parent.right; margins: Theme.margin(1) }
    }

    PageControls {
        width: Theme.margin(45)
        anchors {
            right: parent.right
            rightMargin: -Theme.margin(1)
            bottom: parent.bottom
        }
    }
}
