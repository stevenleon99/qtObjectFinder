import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import ViewportEnums 1.0
import GmQml 1.0


Popup {
    id: navigationTrackingModePopup
    width: Theme.margin(30)
    height: Theme.margin(24)
    modal: false
    dim: false

    background: Rectangle { radius: Theme.margin(1); color: Theme.slate900 }

    NavigationTrackingModeViewModel {
        id: navigationTrackingModeViewModel
    }

    property var navigationTrackingMode: navigationTrackingModeViewModel.navigationTrackingMode

    function setup(positionItem) {
        var bottomLeft = positionItem.mapToItem(null, 0, positionItem.height)
        x = bottomLeft.x
        y = bottomLeft.y

        open()
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors { fill: parent }
                spacing: Theme.marginSize / 2

                RowLayout {
                    Layout.leftMargin: Theme.margin(2)
                    Layout.rightMargin: Theme.margin(2)
                    spacing: Theme.margin(2)

                    IconImage {
                        source: "qrc:/images/image-lock.svg"
                        sourceSize: Theme.iconSize
                        color: navigationTrackingMode == View2DNavigationTrackingMode.ScanCentric ? Theme.blue : Theme.white
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Scan Centric")
                        color: navigationTrackingMode == View2DNavigationTrackingMode.ScanCentric ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                objectName: "scanCentricOption"  
                anchors { fill: parent }
                onClicked: {
		            navigationTrackingModeViewModel.setScanCentric()
                    navigationTrackingModePopup.close()
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors { fill: parent }
                spacing: Theme.marginSize / 2

                RowLayout {
                    Layout.leftMargin: Theme.margin(2)
                    Layout.rightMargin: Theme.margin(2)
                    spacing: Theme.margin(2)

                    IconImage {
                        source: "qrc:/images/tool-centric2.svg"
                        sourceSize: Theme.iconSize
                        color: navigationTrackingMode == View2DNavigationTrackingMode.ToolCentric ? Theme.blue : Theme.white
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Tool Centric")
                        color: navigationTrackingMode == View2DNavigationTrackingMode.ToolCentric ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                objectName: "toolCentricOption"  
                anchors { fill: parent }
                onClicked: {
		            navigationTrackingModeViewModel.setToolCentric()
                    navigationTrackingModePopup.close()
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors { fill: parent }
                spacing: Theme.marginSize / 2

                RowLayout {
                    Layout.leftMargin: Theme.margin(2)
                    Layout.rightMargin: Theme.margin(2)
                    spacing: Theme.margin(2)

                    IconImage {
                        source: "qrc:/images/tool-dynamic.svg"
                        sourceSize: Theme.iconSize
                        color: navigationTrackingMode == View2DNavigationTrackingMode.ToolDynamic ? Theme.blue : Theme.white
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Tool Dynamic")
                        color: navigationTrackingMode == View2DNavigationTrackingMode.ToolDynamic ? Theme.blue : Theme.white

                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                objectName: "toolDynamicOption" 
                anchors { fill: parent }
                onClicked: {
		            navigationTrackingModeViewModel.setToolDynamic()
                    navigationTrackingModePopup.close()
                }
            }
        }
    }
}
