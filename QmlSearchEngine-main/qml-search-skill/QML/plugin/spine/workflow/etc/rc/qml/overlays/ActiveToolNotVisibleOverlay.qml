import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

import ViewModels 1.0

Item {
    visible: renderer.scanList.length &&
             activeToolNotVisibleOverlayViewModel.visibleDelayed

    property var renderer

    anchors { fill: parent }

    ActiveToolNotVisibleOverlayViewModel {
        id: activeToolNotVisibleOverlayViewModel
        viewport: renderer
    }

    Rectangle {
        opacity: 0.4
        anchors { fill: parent }
    }

    ColumnLayout {
        anchors { centerIn: parent }

        Image {
            Layout.alignment: Qt.AlignHCenter
            source: "qrc:/images/no-tracking.png"
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            style: Text.Outline
            state: "h5"
            text: qsTr(activeToolNotVisibleOverlayViewModel.overlayTitle)
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            style: Text.Outline
            state: "h6"
            text: qsTr("View is not live.")
        }
    }
}
