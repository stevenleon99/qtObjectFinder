import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtGraphicalEffects 1.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0

Item {
    visible: renderer.scanList.length && captureShotInfoOverlayViewModel.enabled
    anchors { fill: parent }
    clip: true

    property var renderer

   ShotInfoOverlayViewModel {
       id: captureShotInfoOverlayViewModel
       viewport: renderer
   }

    LinearGradient {
        opacity: 0.64
        width: parent.width
        height: Theme.margin(8)
        anchors { top: parent.top }
        start: Qt.point(0, 0)
        end: Qt.point(0, height)
        gradient: Gradient {
            GradientStop { position: 0.0; color: Theme.black }
            GradientStop { position: 1.0; color: Theme.transparent }
        }
    }

    ColumnLayout {
        anchors { fill: parent }

        RowLayout {
            Layout.preferredHeight: Theme.margin(8)
            Layout.fillWidth: false
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.margin(1)
            spacing: Theme.margin(1)
            Label {
                Layout.fillWidth: true
                state: "subtitle1"
                font.bold: true
                text: captureShotInfoOverlayViewModel.activeLevelName 
            }
             Label {
                Layout.fillWidth: true
                state: "subtitle1"
                font.bold: true
                text: captureShotInfoOverlayViewModel.orientationLabel 
            }
        }

        LayoutSpacer { }

        Item {
            Layout.preferredWidth: shotindex.width
            Layout.preferredHeight: shotindex.height
            Layout.alignment: Qt.AlignLeft

            Rectangle { anchors.fill: parent; radius: 4; color: Theme.black; opacity: 0.64 }

            Label {
                id: shotindex
                anchors { centerIn: parent }
                state: "h3"
                font.bold: true
                leftPadding: Theme.margin(1)
                rightPadding: leftPadding
                text: captureShotInfoOverlayViewModel.captureIndex
            }
        }
    }
}
