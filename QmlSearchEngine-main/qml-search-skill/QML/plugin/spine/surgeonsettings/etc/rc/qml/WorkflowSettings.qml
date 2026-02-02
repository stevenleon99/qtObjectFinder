import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

ColumnLayout {
    spacing: Theme.marginSize

    Label {
        Layout.preferredHeight: Theme.margin(6)
        state: "h5"
        font.bold: true
        verticalAlignment: Label.AlignVCenter
        text : qsTr("Workflow")
    }

    CheckableSettingsItem {
        title: qsTr("Show Invalid Shots")
        description: qsTr("Show invalid fluoro shots on image timeline. ")
        checkState: surgeonSettingsViewModel.displayInvalidShots ? Qt.Checked : Qt.Unchecked

        onCheckBoxClicked: surgeonSettingsViewModel.toggleInvalidShotsDisplay()
    }

    CheckableSettingsItem {
        title: qsTr("ICT Instability Alert")
        description: qsTr("Display an alert when ICT is unstable.")
        checkState: surgeonSettingsViewModel.displayIctUnstableAlert ? Qt.Checked : Qt.Unchecked

        onCheckBoxClicked: surgeonSettingsViewModel.toggleIctUnstableAlertDisplay()
    }

    CheckableSettingsItem {
        title: qsTr("Reduce Backoff Distance")
        description: qsTr("Enables a shorter End Effector backup distance which can increase reachability range.")
        checkState: surgeonSettingsViewModel.reduceBackoffDistance ? Qt.Checked : Qt.Unchecked

        onCheckBoxClicked: surgeonSettingsViewModel.toggleReduceBackoffDistance()
    }

    CheckableSettingsItem {
        title: qsTr("Merge Scores")
        description: qsTr("Show the Pre OP CT Merge scores while verifying levels")
        checkState: !surgeonSettingsViewModel.hideMergeScores ? Qt.Checked : Qt.Unchecked

        onCheckBoxClicked: surgeonSettingsViewModel.toggleHideMergeScores()
    }
}
