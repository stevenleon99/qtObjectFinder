import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import "../components"

ColumnLayout {
    Layout.alignment: Qt.AlignTop
    spacing: 0

    StudySummaryModel { id: studySummary }

    RowLayout {
        Layout.fillHeight: false
        Layout.preferredHeight: Theme.margin(10)
        spacing: Theme.margin(2)

        RowLayout {
            spacing: 0

            IconImage {
                color: Theme.navyLight
                fillMode: Image.PreserveAspectFit
                sourceSize: Theme.iconSize
                source: "qrc:/icons/image-study.svg"
            }

            Label {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.margin(2)
                state: "h6"
                font.bold: true
                maximumLineCount: 1
                text: studySummary.studyName

                Rectangle {
                    width: parent.contentWidth
                    height: 1
                    anchors { bottom: parent.bottom; bottomMargin: -Theme.margin(1) }
                    color: Theme.navy
                }

                MouseArea {
                    width: parent.contentWidth
                    height: parent.height

                    onClicked: {
                        renamePopup.text = studySummary.studyName;
                        renamePopup.open();
                    }

                    RenamePopup {
                        id: renamePopup
                        title: qsTr("Rename Study")

                        onSaveClicked: studySummary.setCaseName(text)
                    }
                }
            }
        }

        Button {
            state: "icon"
            icon.source: "qrc:/icons/trash.svg"
            highlighted: deletePopup.visible

            onClicked: deletePopup.open()

            DeleteItemPopup {
                id: deletePopup
                itemName: studySummary.studyName
                state: "study"

                onDeleteClicked: studySummary.deleteStudy()
            }
        }
    }

    DetailsTabBar {
        id: tabBar
        Layout.preferredHeight: Theme.margin(8)
        thumbnailCount: scanListModel.count
    }

    StackLayout {
        currentIndex: tabBar.currentIndex

        Loader {
            active: tabBar.currentIndex == 0
            sourceComponent: ColumnLayout {
                spacing: 0

                ScanTileView {
                    Layout.topMargin: Theme.margin(2)
                    visible: scanListModel.count > 0
                }

                ColumnLayout {
                    Layout.topMargin: Theme.margin(2)
                    spacing: Theme.margin(1.5)

                    NameValueRow { name: qsTr("Creator"); value: studySummary.creatorName }
                    NameValueRow { name: qsTr("Opened"); value: studySummary.accessedTime }
                    NameValueRow { name: qsTr("Created"); value: studySummary.createdTime }
                }

                LayoutSpacer { }
            }
        }

        Loader {
            active: tabBar.currentIndex == 1
            sourceComponent: ScanThumbnailView {
                id: scanThumbnailView
                state: "case"
            }
        }
    }
}
