import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import "../.."

Rectangle {
    visible: shotSelectedViewModel.hasShotSelected
    anchors { fill: parent }
    color: Theme.overlayColor

    ShotSelectedViewModel {
        id: shotSelectedViewModel
    }

    Rectangle {
        width: height
        height: parent.height
        anchors { centerIn: parent }
        radius: Theme.marginSize / 2
        color: Theme.transparent

        ImageThumbnail {
            anchors { fill: parent }
            id: imageThumbnail
            source: shotSelectedViewModel.shotSelectedPath ? "file:///" + shotSelectedViewModel.shotSelectedPath
                                                                : ""
            fillMode: Image.PreserveAspectFit

            Rectangle {
                anchors { fill: parent }
                radius: Theme.marginSize / 2
                color: Theme.transparent
                border { width: Theme.marginSize / 4; color: Theme.white }
            }

            FluoroRegistrationOverlay {
                anchors { fill: parent }
                xPad: (width-imageThumbnail.paintedWidth)/2
                yPad: (height-imageThumbnail.paintedHeight)/2
                imageScale: imageThumbnail.paintedHeight / imageThumbnail.sourceSize.height;

                orientationMarkers: shotSelectedViewModel.fixtureOrientationMarkers
                registrationMarkers: shotSelectedViewModel.fixtureRegistrationMarkers
                gridMarkers: shotSelectedViewModel.fixtureGridMarker
            }
        }

        RowLayout {
            width: parent.width
            anchors { top: parent.top }
            spacing: 0
            Item{
                Layout.preferredWidth:Theme.margin(8)
                Layout.preferredHeight:Theme.margin(8)
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 4
                Layout.leftMargin: 4

                Rectangle { anchors.fill: parent; color: Theme.black; opacity: .64}

                Button
                {
                    anchors.centerIn: parent
                    state: "icon"
                    icon.source: "qrc:/icons/trash"
                    enabled: shotSelectedViewModel.isTrashButtonEnabled

                    onClicked: shotSelectedViewModel.deleteShot(shotSelectedViewModel.selectedShot.id)
                }
            }

            LayoutSpacer {}

            Item{
                Layout.preferredWidth: Theme.margin(8)
                Layout.preferredHeight: Theme.margin(8)
                Layout.topMargin: 4
                Layout.rightMargin: 4
                Rectangle { anchors.fill: parent; color: Theme.black; opacity: .64}

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 0
                    Button {
                        state: "icon"
                        icon.source: "qrc:/icons/x"
                        onClicked: shotSelectedViewModel.deselectShot()
                    }
                }
            }
        }

        ColumnLayout {
            anchors { bottom: parent.bottom; left: parent.left; margins: Theme.margin(1.5) }
            spacing: Theme.marginSize

            Item {
                Layout.preferredWidth: selectedIndex.width
                Layout.preferredHeight: selectedIndex.height

                Rectangle { anchors.fill: parent; radius: 8; color: Theme.black; opacity: .64}

                Label {
                    id: selectedIndex
                    leftPadding: Theme.marginSize
                    rightPadding: Theme.marginSize
                    font { bold: true; pixelSize: 64 }
                    text: shotSelectedViewModel.selectedShot.captureIndex
                }
            }

            Item {
                Layout.preferredWidth: Theme.margin(21)
                Layout.preferredHeight: Theme.margin(13)

                Rectangle { anchors.fill: parent; radius: 8; color: Theme.black; opacity: .64}

                Label {
                    anchors{top:parent.top; topMargin: Theme.margin(1); horizontalCenter: parent.horizontalCenter}
                    state: "h6"
                    text: shotSelectedViewModel.leftLabelText
                }

                Button {
                    enabled: shotSelectedViewModel.isLeftButtonEnabled
                    state: "active"
                    text: shotSelectedViewModel.leftButtonText
                    font.letterSpacing: 0.25
                    anchors {bottom: parent.bottom; left: parent.left; margins: Theme.margin(1)}
                    Layout.leftMargin: Theme.margin(1)
                    leftPadding: Theme.margin(2)
                    rightPadding: Theme.margin(2)

                    onClicked: shotSelectedViewModel.setLeftShot(shotSelectedViewModel.selectedShot.id)
                }
            }
        }

        Rectangle {
            id: alertRectangle
            visible: !shotSelectedViewModel.isShotRegistered
            anchors { bottom: parent.bottom; margins: Theme.marginSize; horizontalCenter: parent.horizontalCenter }
            height: Theme.margin(9)
            width: Theme.margin(40)
            radius: 4
            color: Theme.black
            border { width: 2; color: Theme.red }

            RowLayout
            {
                id: rowLayout
                width: parent.width
                anchors { verticalCenter: parent.verticalCenter; leftMargin: Theme.margin(1); rightMargin: Theme.margin(1) }
                spacing: Theme.margin(1)

                IconImage {
                    visible: !shotSelectedViewModel.isShotRegistered
                    Layout.leftMargin: Theme.marginSize / 2
                    Layout.alignment: Qt.AlignTop
                    source: "qrc:/images/register-off.svg"
                    sourceSize: Theme.iconSize
                    color: Theme.red
                }

                Label {
                    Layout.fillWidth: true
                    Layout.rightMargin: Theme.margin(1)
                    verticalAlignment: Text.AlignVCenter
                    state: "subtitle1"
                    wrapMode: Text.WordWrap
                    elide:Text.ElideRight
                    maximumLineCount: 2
                    text: qsTr("<b>Registration Failed: </b>") + qsTr(shotSelectedViewModel.shotStatusLabel)
                }
            }
        }

        ColumnLayout {
            anchors { right: parent.right; bottom: parent.bottom; margins: Theme.margin(1.5) }
            spacing: Theme.marginSize

            Item {
                Layout.preferredWidth: Theme.margin(21)
                Layout.preferredHeight: Theme.margin(13)

                Rectangle { anchors.fill: parent; radius: 8; color: Theme.black; opacity: .64}

                Label {
                    anchors{top:parent.top; topMargin: Theme.margin(1); horizontalCenter: parent.horizontalCenter}
                    state: "h6"
                    text: shotSelectedViewModel.rightLabelText
                }

                Button {
                    enabled: shotSelectedViewModel.isRightButtonEnabled
                    state: "active"
                    text: shotSelectedViewModel.rightButtonText
                    anchors {bottom: parent.bottom; left: parent.left; margins: Theme.margin(1)}
                    font.letterSpacing: 0.25
                    leftPadding: Theme.margin(2)
                    rightPadding: Theme.margin(2)

                    onClicked: shotSelectedViewModel.setRightShot(shotSelectedViewModel.selectedShot.id)
                }
            }
        }
    }
}
