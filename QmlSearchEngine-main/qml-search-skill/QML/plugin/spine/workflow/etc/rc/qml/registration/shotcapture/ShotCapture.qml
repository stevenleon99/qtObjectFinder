import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import "../../trackbar"
import "../../viewports"

Item {
    Layout.fillWidth: true
    Layout.fillHeight: true

    ViewportListViewModel {
        id: viewportListViewModel
    }

    ShotAssignViewportViewModel {
        id: shotAssignViewportViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                spacing: 0
                anchors { fill: parent }

                GridLayout {
                    Layout.margins: Theme.marginSize / 2
                    columnSpacing: Theme.marginSize / 2
                    rowSpacing: Theme.marginSize / 2
                    columns: 2

                    Repeater {
                        model: viewportListViewModel.layoutModel

                        Viewport {
                            Layout.column: role_column
                            Layout.row: role_row
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            viewportUid: role_key

                            DescriptiveBackground {
                                visible: !parent.scanList.length
                                anchors { centerIn: parent }
                                source: "qrc:/icons/image-fluoro.svg"
                                text: qsTr("No Image Assigned")
                            }
                        }
                    }
                }

                ViewportTools {
                    Layout.fillWidth: false
                    Layout.margins: Theme.marginSize / 2
                }
            }

            Loader {
                anchors.fill: parent
                active: shotAssignViewportViewModel.visible
                sourceComponent: Component {
                    AssignShotPanel {
                        shotAssignViewportVM: shotAssignViewportViewModel
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(23.5)

            ShotList { }

            DividerLine {
                orientation: Qt.Horizontal
                anchors { top: parent.top }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            TrackBar { objectName: "shotCaptureTrackBar" }

            DividerLine {
                orientation: Qt.Horizontal
                anchors { top: parent.top }
            }
        }
    }
}
