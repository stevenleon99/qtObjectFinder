import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import ViewModels 1.0

import ".."

Rectangle {
    id: volumeMergeListDelegate
    height: contentItem.height + Theme.marginSize
    radius: 8
    border { width: selected ? 2 : 0; color: Theme.blue }
    color: selected ? Theme.slate800
                    : Theme.transparent

    property bool selected: false
    property bool taskRunning: false
    property bool verified: false
    property bool isToMaster: true
    property bool isModifiable: true
    property bool isToLoaded: false
    property bool isFromLoaded: false
    property bool isStudyMode: false

    property string fromVolumeLabel
    property string toVolumeLabel

    property string fromThumbnailSource
    property string toThumbnailSource

    signal thumbnailClicked()
    signal reRegisterClicked()
    signal studyClicked()
    signal verifyClicked()

    RowLayout {
        id: contentItem
        anchors { centerIn: parent }
        width: parent.width - Theme.margin(2)
        spacing: 0

        ColumnLayout {
            spacing: 0

            ImageThumbnail {
                Layout.preferredWidth: 96
                Layout.preferredHeight: 96
                source: fromThumbnailSource && isFromLoaded ? "file:///" + encodeURIComponent(fromThumbnailSource) : "qrc:/images/thumbnailError.png"

                onThumbnailClicked: volumeMergeListDelegate.thumbnailClicked()
            }

            Label {
                Layout.fillWidth: true
                state: "body1"
                text: fromVolumeLabel
                font.bold: true
            }
        }

        ColumnLayout {
            Layout.alignment: Qt.AlignVCenter
            Layout.fillWidth: false
            Layout.fillHeight: false
            spacing: 0

            IconImage {
                enabled: selected
                visible: isModifiable && !isStudyMode
                Layout.alignment: Qt.AlignHCenter
                source: "qrc:/images/merge-fill.svg"
                sourceSize: Theme.iconSize
                color: Theme.white

                MouseArea {
                    anchors { fill: parent }
                    onClicked: studyClicked()
                }

                Text {
                    id: text
                    text: role_registrationLabel
                    color: Theme.black
                    font.pixelSize: 12
                    font.bold: true
                    anchors.centerIn: parent
                }
            }

            Label {
                visible: isStudyMode
                Layout.fillWidth: true
                state: "body1"
                text: role_id
                font.bold: true
            }

            IconImage {
                Layout.alignment: Qt.AlignHCenter
                rotation: 180
                source: "qrc:/icons/arrow.svg"
                sourceSize: Theme.iconSize
                color: Theme.navyLight
            }

            Button {
                enabled: selected && !taskRunning
                visible: isModifiable
                state: "icon"
                icon.source: !taskRunning?"qrc:/icons/refresh.svg":"qrc:/images/loading-circle.svg"

                onClicked: {
                    if (enabled)
                    {
                         reRegisterClicked()
                    }
                }
            }
        }

        ColumnLayout {
            spacing: 0

            ImageThumbnail {
                Layout.preferredWidth: 96
                Layout.preferredHeight: 96
                source: toThumbnailSource && isToLoaded ? "file:///" + encodeURIComponent(toThumbnailSource) : "qrc:/images/thumbnailError.png"

                onThumbnailClicked: volumeMergeListDelegate.thumbnailClicked()

                IconImage {
                    visible: isToMaster
                    source: "qrc:/icons/star-filled.svg"
                    sourceSize: Theme.iconSize
                    color: Theme.blue
                }
            }

            Label {
                Layout.fillWidth: true
                state: "body1"
                text: toVolumeLabel
                font.bold: true
            }
        }

        CheckBox {
            visible: !isStudyMode
            enabled: isModifiable
            opacity: selected ? 1 : 0.25
            Layout.fillWidth: false
            Layout.fillHeight: false
            Layout.preferredWidth: Theme.margin(6)
            Layout.preferredHeight: Theme.margin(6)
            nextCheckState: verified
            checked: verified

            onToggled: verifyClicked()
        }

        Button {
            Layout.preferredWidth: Theme.margin(10)
            enabled: selected && !taskRunning
            visible: isStudyMode
            state: "active"
            text: "Set"

            onClicked: verifyClicked()
        }
    }

    MouseArea {
        enabled: !selected
        anchors { fill: parent }
        propagateComposedEvents: false

        onClicked: thumbnailClicked()
    }
}
