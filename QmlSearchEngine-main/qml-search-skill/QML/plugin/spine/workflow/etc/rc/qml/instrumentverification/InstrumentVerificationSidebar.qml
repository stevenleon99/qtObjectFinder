import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0

import "../components"

Item {
    id: instrumentVerificationSidebar
    Layout.preferredWidth: Theme.margin(60)
    Layout.fillHeight: true

    ActiveRefElementSetViewModel {
        id: activeRefElementSet
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        RowLayout {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            spacing: Theme.marginSize

            IconImage {
                Layout.leftMargin: Theme.marginSize
                Layout.alignment: Qt.AlignHCenter
                sourceSize: Theme.iconSize
                color: Theme.navyLight
                source: "qrc:/icons/tools.svg"
            }

            Label {
                Layout.fillWidth: true
                state: "subtitle2"
                font { bold: true; letterSpacing: 1; capitalization: Font.AllUppercase }
                verticalAlignment : Text.AlignVCenter
                color: Theme.navyLight
                text: qsTr("Tools")
            }
        }

        Flickable {
            id: flickable
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin( 111)

            contentHeight: layout.height
            boundsBehavior: Flickable.StopAtBounds
            interactive: flickable.contentHeight > flickable.height
            clip: true

            ScrollBar.vertical: ScrollBar {
                id: scrollBar
                visible: flickable.contentHeight > flickable.height
                anchors { right: parent.right }
                padding: Theme.margin(.5)
            }

            ColumnLayout {
                id: layout

                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.marginSize
                    rightMargin: Theme.marginSize
                }

                StandardNavigationVerification {
                    Layout.fillWidth: true
                }

                VerificationSets {
                    Layout.fillWidth: true
                    activeRefElementSetViewModel: activeRefElementSet
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            PageControls {
                anchors { right: parent.right; verticalCenter: parent.verticalCenter }
                width: parent.width
            }

            DividerLine {
                orientation: Qt.Horizontal
                anchors { top: parent.top }
            }
        }
    }
}
