import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

ColumnLayout {
    visible: mergeToolsViewModel.isMergeToolsVisible
    spacing: Theme.marginSize

    MergeToolsViewModel {
        id: mergeToolsViewModel
    }

    Rectangle {
        Layout.preferredWidth: Theme.margin(6)
        Layout.preferredHeight: Theme.margin(6)
        radius: height/2

        Button {
            anchors { centerIn: parent }
            state: "icon"
            icon.source: "qrc:/icons/blend-play.svg"
            color: Theme.black
            highlighted: mergeToolsViewModel.playbackActive

            onClicked: mergeToolsViewModel.toggleMergePlayback()
        }
    }

    Rectangle {
        Layout.preferredWidth: Theme.margin(6)
        Layout.preferredHeight: Theme.margin(6)
        radius: height/2

        Button {
            anchors { centerIn: parent }
            state: "icon"
            icon.source: "qrc:/icons/merge-arrow.svg"
            color: Theme.black

            onClicked: mergeToolsViewModel.switchMergeImage()
        }
    }

    Rectangle {
        Layout.preferredWidth: Theme.margin(6)
        Layout.preferredHeight: Theme.margin(6)
        radius: height/2

        Button {
            anchors { centerIn: parent }
            state: "icon"
            icon.source: "qrc:/icons/checkerboard.svg"
            color: Theme.black
            highlighted: mergeToolsViewModel.checkerboardActive

            onClicked: mergeToolsViewModel.toggleCheckerboard()
        }
    }
}
