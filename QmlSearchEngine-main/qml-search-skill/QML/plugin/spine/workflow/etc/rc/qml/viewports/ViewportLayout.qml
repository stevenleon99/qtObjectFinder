import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0
import ViewportEnums 1.0

import "../trackbar"
import "../overlays"

Item {
    Layout.fillWidth: true
    Layout.fillHeight: true

    ViewportListViewModel {
        id: viewportListViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        RowLayout {
            spacing: 0

            Item {
                
                Layout.fillHeight: true
                Layout.fillWidth: true

                GridLayout {
                    id: viewportGridLayout
                    objectName: "viewportGridLayout"
                    anchors { fill: parent; margins: Theme.marginSize/2 }
                    columnSpacing: Theme.marginSize / 2
                    rowSpacing: Theme.marginSize / 2

                    Repeater {
                        id: repeater
                        model: viewportListViewModel.layoutModel

                        delegate: Loader {
                            objectName: "viewportGridRepeater_" + role_column + "_" + role_row
                            active: role_visible
                            property int index: index
                            sourceComponent: role_viewportType == ViewportViewType.ViewTypeXr ? xrViewportComponent : viewportComponent
                        
                            Layout.column: role_column
                            Layout.row: role_row
                            Layout.fillHeight: role_visible 
                            Layout.fillWidth: role_visible

                            Component {
                                id: viewportComponent
                                Viewport {
                                    anchors.fill: parent
                                    viewportUid: role_key

                                    onDisableAutoTransformUpdatesOnOtherViews: {
                                    for (var i = 0; i < repeater.count; i++) {
                                        if (i !== index) {
                                            repeater.itemAt(i).setAutoTransformUpdatesEnabled(false)
                                            }
                                        }
                                    }
                                    onEnableAndKeepTransformUpdatesOnOtherViews: {
                                        for (var i = 0; i < repeater.count; i++) {
                                            if (i !== index) {
                                                repeater.itemAt(i).enableAutoTransformUpdateAndKeepPosition()
                                            }
                                        }
                                    }
                                }
                            }

                            Component {
                                id: xrViewportComponent
                                XrViewport {
                                    anchors.fill: parent
                                    viewportUid: role_key
                                }
                            }
                        }
                    }
                }

                MergeTools {
                    id: mergeTools
                    anchors.centerIn: parent
                    anchors.verticalCenterOffset: parent.height/4
                }

                ImplantPlacedPopup {
                    anchors{ centerIn: parent }
                }

                TrajectoryOffsetMeter {
                    anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
                }
            }

            ViewportTools {
                Layout.fillWidth: false
                Layout.margins: Theme.marginSize / 2
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            TrackBar { objectName: "viewPortLayoutTrackBar" }

            DividerLine {
                orientation: Qt.Horizontal
                anchors { top: parent.top }
            }
        }
    }


}
