import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0
import GmQml 1.0

import "../components"

ColumnLayout {
    spacing: 0

    property var caseSummaryModel

    ScanTileView {
        Layout.topMargin: Theme.margin(2)
        visible: scanListModel.count > 0
    }

    Flickable {
        id: detailsFlickable
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.topMargin: Theme.margin(2)
        contentHeight: detailsLayout.height
        interactive: contentHeight > height
        clip: true

        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            anchors { right: parent.right; rightMargin: -Theme.margin(1) }
            z: 99
            visible: detailsFlickable.interactive
            padding: Theme.margin(1)
        }

        ColumnLayout {
            id: detailsLayout
            width: scrollBar.visible ? parent.width - Theme.margin(3) : parent.width
            spacing: Theme.margin(1.5)

            NameValueRow { objectName: "caseDetailsCreator"; name: qsTr("Creator"); value: caseSummaryModel.creatorName }
            NameValueRow { objectName: "caseDetailsOpenTime"; name: qsTr("Opened"); value: caseSummaryModel.accessedTime }
            NameValueRow { objectName: "caseDetailsCreateTime"; name: qsTr("Created"); value: caseSummaryModel.createdTime }
            NameValueRow { objectName: "caseDetailsType"; name: qsTr("Type"); value: caseSummaryModel.workflow }

            Repeater {
                id: repeater
                model: caseSummaryModel.caseSummaryList 
                NameValueRow { objectName: "caseDetails_"+role_name; name: role_name; value: role_value; textWrap: true }
            }

            RowLayout {
                spacing: Theme.margin(2)

                Label {
                    Layout.fillWidth: true
                    maximumLineCount: 1
                    color: Theme.navyLight
                    text: qsTr("Notes")
                    font.pixelSize: 21
                }

                Button {
                    state: "icon"
                    icon.source: "qrc:/icons/text-bubble-filled.svg"

                    onClicked: caseNotesPopup.open()

                    CaseNotesPopup {
                        id: caseNotesPopup
                        caseName: caseSummaryModel.caseName
                        caseNotes: caseSummaryModel.caseNotes

                        onSavedClicked: caseSummaryModel.setCaseNotes(notesText)
                    }
                }
            }

            Label {
                Layout.fillWidth: true
                Layout.fillHeight: true
                state: "body1"
                verticalAlignment: Label.AlignTop
                wrapMode: Label.Wrap
                lineHeight: 1.25
                color: Theme.navyLight
                text: caseSummaryModel.caseNotes ? caseSummaryModel.caseNotes : qsTr("Add notes...")
            }
        }
    }
}
