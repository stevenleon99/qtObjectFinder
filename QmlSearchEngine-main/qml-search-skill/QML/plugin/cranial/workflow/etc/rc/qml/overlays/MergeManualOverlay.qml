import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import ViewModels 1.0

Item {
    visible: renderer.viewType !== ImageViewport.ThreeD &&
             mergeVM.toAndFromVolumesSelected &&
             mergeVM.isSelectionModifiable && mergeVM.isMergeVolumeButtonsVisible

    property var renderer

    MergeOverlayViewModel {
        id: mergeVM
        viewport: renderer
    }

    property real _repeatDelay: 500
    property real _repeatInterval: 10

    ColumnLayout {
        anchors { right: parent.right; bottom: parent.bottom; margins: Theme.marginSize }
        spacing: 0

        RowLayout {
            spacing: 0

            Button {
                state: "icon"
                icon.source: "qrc:/icons/step-back.svg"
                autoRepeat: true
                autoRepeatDelay: _repeatDelay
                autoRepeatInterval: _repeatInterval
                onClicked: mergeVM.rotateCounterclockwise()
            }

            Button {
                rotation: 90
                state: "icon"
                icon.source: "qrc:/icons/arrow.svg"
                autoRepeat: true
                autoRepeatDelay: _repeatDelay
                autoRepeatInterval: _repeatInterval
                onClicked: mergeVM.shiftUp()
            }

            Button {
                state: "icon"
                icon.source: "qrc:/icons/step-forward.svg"
                autoRepeat: true
                autoRepeatDelay: _repeatDelay
                autoRepeatInterval: _repeatInterval
                onClicked: mergeVM.rotateClockwise()
            }
        }

        RowLayout {
            spacing: 0

            Button {
                state: "icon"
                icon.source: "qrc:/icons/arrow.svg"
                autoRepeat: true
                autoRepeatDelay: _repeatDelay
                autoRepeatInterval: _repeatInterval
                onClicked: mergeVM.shiftLeft()
            }

            Button {
                rotation: 270
                state: "icon"
                icon.source: "qrc:/icons/arrow.svg"
                autoRepeat: true
                autoRepeatDelay: _repeatDelay
                autoRepeatInterval: _repeatInterval
                onClicked: mergeVM.shiftDown()
            }

            Button {
                rotation: 180
                state: "icon"
                icon.source: "qrc:/icons/arrow.svg"
                autoRepeat: true
                autoRepeatDelay: _repeatDelay
                autoRepeatInterval: _repeatInterval
                onClicked: mergeVM.shiftRight()
            }
        }
    }
}
