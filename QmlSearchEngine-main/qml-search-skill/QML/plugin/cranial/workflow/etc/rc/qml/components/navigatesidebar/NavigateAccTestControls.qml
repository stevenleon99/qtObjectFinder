import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0


ColumnLayout {
    spacing: 0

    AccTestNavViewModel {
        id: accTestNavViewModel
    }

    RowLayout {
        visible: applicationViewModel.testModeEnabled
        spacing: Theme.marginSize / 2

        Label {
            state: "body1"
            font.styleName: Theme.mediumFont.styleName
            font.bold: true
            text: "Guidance"
        }

        Switch {
            position: accTestNavViewModel.isGuidanceTest?0:1
            onPositionChanged:
            {
                accTestNavViewModel.setIsGuidanceTest(position==0)
                position = Qt.binding( function () { return accTestNavViewModel.isGuidanceTest?0:1})
            }

        }

        Label {
            state: "body1"
            font.styleName: Theme.mediumFont.styleName
            font.bold: true
            color: Theme.navyLight
            text: "Navigate"
        }
    }

    Label {
        state: "body1"
        font.styleName: Theme.mediumFont.styleName
        font.bold: true
        text: "Landmarks done: " + accTestNavViewModel.landmarksDone.toString()
    }

    Label {
        state: "body1"
        font.styleName: Theme.mediumFont.styleName
        font.bold: true
        text: "Latest result: " + accTestNavViewModel.currentResult
    }

    Label {
        state: "body1"
        font.styleName: Theme.mediumFont.styleName
        font.bold: true
        text: "Mean: " + accTestNavViewModel.meanResult
    }

    Label {
        state: "body1"
        font.styleName: Theme.mediumFont.styleName
        font.bold: true
        text: "TI: " + accTestNavViewModel.tiResult
    }

    Button {
        Layout.fillWidth: true
        state: "active"
        text: qsTr("Remove Active Trajectory")

        onClicked: {
            accTestNavViewModel.deleteActiveTrajectory()
        }
    }
}
