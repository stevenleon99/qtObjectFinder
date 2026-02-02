import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import ViewModels 1.0

import Theme 1.0
import GmQml 1.0

import "../components"

Item {
    Layout.fillWidth: true
    Layout.preferredHeight: Theme.margin(41)

    CaseImplantSystemViewModel {
        id: caseImplantSystemViewModel
    }

    ColumnLayout {
        anchors { fill: parent; leftMargin: Theme.marginSize; rightMargin: Theme.marginSize }
        spacing: 0

        Label {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)
            state: "subtitle2"
            font.bold: true
            font.letterSpacing: 1
            font.capitalization: Font.AllUppercase
            verticalAlignment : Text.AlignVCenter
            color: Theme.headerTextColor
            text: qsTr("Implant Systems")
        }

        ListView {
            id: systemsList

            Layout.fillWidth: true
            Layout.fillHeight: true
            interactive: contentHeight > height
            highlightMoveDuration : 250
            clip: true

            model: caseImplantSystemViewModel.caseImplantSystemList

            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                anchors { right: parent.right; rightMargin: -Theme.margin(1) }
                visible: systemsList.contentHeight > systemsList.height
                padding: Theme.margin(1)
            }

            delegate: CaseImplantSystem {
                objectName: "implantSystem_"+index
                bgRightMargin: scrollBar.visible ? Theme.margin(1.5) : 0
                selected: role_implantSystemId == caseImplantSystemViewModel.activeSetUuid

                onSelectedChanged: {
                    if (selected)
                        ListView.view.currentIndex = index
                }

                ListView.onAdd: {
                    if (selected)
                        ListView.view.currentIndex = index
                }

                onClicked : {
                    caseImplantSystemViewModel.setSelectedInstrumentSet(role_implantSystemId)
                }

                onDeleteClicked: caseImplantSystemViewModel.removeSystem(role_implantSystemId)
            }

            DescriptiveBackground {
                objectName: "implantsEmptyState"
                visible: systemsList.count === 0
                anchors { centerIn: parent }
                source: "qrc:/icons/toolbox"
                text: qsTr("No systems added.")
            }
        }
    }

    DividerLine {
        anchors { bottom: parent.bottom }
        orientation: Qt.Horizontal
    }
}
