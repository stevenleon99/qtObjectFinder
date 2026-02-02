import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import "../trackbar"

Item {
    Layout.preferredWidth: Theme.margin(180)
    Layout.fillHeight: true

    CameraViewViewModel {
        id: cameraViewViewModel
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        CameraPanel {
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.margins: Theme.margin(1)

            markerModel: cameraViewViewModel.cameraViewListModel

            CameraHeader {
                anchors {
                    top: parent.top
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.marginSize
                    rightMargin: Theme.marginSize
                }

                height: Theme.margin(8)

                cameraViewVM: cameraViewViewModel
            }

            RowLayout {
                id: rl
                anchors { horizontalCenter: parent.horizontalCenter }
                height: Theme.margin(8)
                spacing: Theme.marginSize
                visible: true

                Label {
                    state: "body1"
                    text: qsTr("Markers")
                    color: markerSwitch.checked ? Theme.headerTextColor : Theme.white
                }

                Switch {
                    id: markerSwitch
                    objectName: "cameraViewMarkerSwitchBtn"
                    checked: !cameraViewViewModel.drawArrayMarkers

                    onClicked: {
                        cameraViewViewModel.toggleDrawArrayMarkers()
                    }
                }

                Label {
                    state: "body1"
                    text: qsTr("Centroids")
                    color: markerSwitch.checked ? Theme.white : Theme.headerTextColor
                }

            }

            InstrumentVerificationProgressOverlay {
                anchors.centerIn: parent
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: Theme.margin(8)

            TrackBar {
                objectName: "cameraViewTrackBar"
                trackingButtonVisible: false
            }

            DividerLine {
                orientation: Qt.Horizontal
                anchors { top: parent.top }
            }
        }
    }

    DividerLine {
        anchors { right: parent.right }
    }
}
