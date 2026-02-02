import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0
import DriveEnums 1.0
import DriveImport 1.0

import "../components"

ColumnLayout {
    Layout.alignment: Qt.AlignTop
    spacing: 0
    visible: caseSummary.casePluginInfo !== undefined

    CaseSummaryModel {
        id: caseSummary

        readonly property var casePluginInfo: pluginInfoListModel.pluginInfoForWorkflow(workflow)
    }

    ProgressValueDialog {
        visible: caseExportViewModel.exportState > CaseExportState.WAITING &&
                 caseExportViewModel.exportState < CaseExportState.EXPORT_SUCCESS
        from: CaseExportState.WAITING
        to: CaseExportState.EXPORT_SUCCESS
        value: caseExportViewModel.exportState
        header: qsTr("EXPORT CASE")
        description: caseExportViewModel.exportStep
        detail: caseExportViewModel.exportStepDetail
    }

    RowLayout {
        Layout.preferredHeight: Theme.margin(10)
        spacing: Theme.margin(2)

        RowLayout {
            spacing: 0

            IconImage {
                color: Theme.navyLight
                fillMode: Image.PreserveAspectFit
                sourceSize: Theme.iconSize
                source: caseSummary.casePluginInfo
                        ? caseSummary.casePluginInfo.pluginIcon
                        : "qrc:/icons/image-study.svg"
            }

            Label {
                Layout.fillWidth: true
                Layout.leftMargin: Theme.margin(2)
                state: "h6"
                font.bold: true
                maximumLineCount: 1
                text: caseSummary.caseName

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
                        renamePopup.text = caseSummary.caseName;
                        renamePopup.open();
                    }

                    RenamePopup {
                        id: renamePopup
                        title: qsTr("Rename Case")

                        onSaveClicked: caseSummary.setCaseName(text)
                    }
                }
            }
        }

        Button {
            enabled: locationsPopup.count
            state: "icon"
            icon.source: "qrc:/icons/export.svg"
            highlighted: locationsPopup.visible

            onClicked: locationsPopup.visible = !locationsPopup.visible

            LocationsPopup {
                id: locationsPopup
                y: parent.height
                x: parent.width - width - Theme.margin(2)
                model: caseExportViewModel.locationList

                onLocationSelected: {
                    caseExportViewModel.exportCase(caseSummary.casePluginInfo.pluginName,
                                                   caseSummary.caseId, location)
                    close()
                }
            }
        }

        Button {
            state: "icon"
            icon.source: "qrc:/icons/trash.svg"

            onClicked: deletePopup.open()

            DeleteItemPopup {
                id: deletePopup
                itemName: caseSummary.caseName
                state: "case"

                onDeleteClicked: pluginModel.deletePluginCase(caseSummary.casePluginInfo.pluginName,
                                                              caseSummary.caseId,
                                                              caseSummary.screenshotsIds)
            }
        }
    }

    Button {
        objectName: "openCaseButton"
        Layout.fillWidth: true
        state: "active"
        text: qsTr("Open Case")

        onClicked: pluginModel.openWorkflowPlugin(caseSummary.workflow)
    }

    TabBar {
        id: tabBar
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.margin(8)

        SummaryTabButton { 
            objectName:"summaryTabDetailsBtn" 
            name: qsTr("Details") 
        }
        SummaryTabButton {
            id: images
            objectName:"summaryTabImageBtn"
            width: Theme.margin(21)
            state: "images"
            name: qsTr("Images")
            thumbnailCount: scanListModel.count
        }
        SummaryTabButton {
            objectName:"summaryTabScreenShotBtn"
            width: Theme.margin(26)
            state: "images"
            name: qsTr("Screenshots")
            thumbnailCount: screenshotsViewModel.screenshotList.count
        }

        background: Item {
            Rectangle {
                width: parent.width; height: 1;
                anchors { bottom: parent.bottom }
                color: Theme.navyLight
            }
        }
    }

    StackLayout {
        currentIndex: tabBar.currentIndex

        Loader {
            active: tabBar.currentIndex == 0
            sourceComponent: CaseDetails {
                caseSummaryModel: caseSummary
            }
        }

        Loader {
            active: tabBar.currentIndex == 1
            sourceComponent: ScanThumbnailView {
                id: scanThumbnailView
                state: "case"
                exportSeriesEnabled: true

                onExportSeries: caseSummary.exportSeries()
            }
        }

        ColumnLayout {
            spacing: 0

            RowLayout {
                Layout.preferredHeight: Theme.margin(8)

                Label {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignVCenter
                    state: "body1"
                    color: Theme.navyLight
                    font { bold: true }
                    font.capitalization: Font.AllUppercase
                    text: qsTr("screenshots")
                }

                Button {
                    enabled: exportLocationsPopup.count &&
                             screenshotsViewModel.screenshotList.count > 0
                    Layout.alignment: Qt.AlignVCenter
                    state: "icon"
                    icon.source: "qrc:/icons/export.svg"

                    onClicked: exportLocationsPopup.open()

                    LocationsPopup {
                        id: exportLocationsPopup
                        y: -height
                        x: parent.width - width - Theme.margin(2)
                        model: caseExportViewModel.locationList

                        onLocationSelected: {
                            screenshotsViewModel.exportScreenshots(location)
                            close()
                        }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                CaseScreenshots { }
            }
        }
    }
}
