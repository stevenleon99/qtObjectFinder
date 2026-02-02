import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import ".."

ColumnLayout {
    spacing: 0

    property alias mergeId: volumeMergeStudyViewModel.mergeId
    property bool isVisible: visible
    property int indexSelected

    SectionHeader {
        title: qsTr("MERGE LIST")
    }

    VolumeMergeStudyViewModel {
        id: volumeMergeStudyViewModel
    }

    Timer {
        id: timer
        interval: 100
        running: false
        repeat: false
        onTriggered: volumeMergeStudyViewModel.runStudy()
    }

    onVisibleChanged: {
        if (visible)
            timer.start()
    }

    ListView {
        id: listView
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.preferredHeight: 250
        Layout.leftMargin: Theme.marginSize
        Layout.rightMargin: Theme.marginSize
        z: -1
        spacing: 5
        clip: true

        model: volumeMergeStudyViewModel

        delegate: VolumeMergeStudyDelegate {
            width: parent.width
            selected: role_isSelected
            compareSelected: role_isSelectedToCompare;
            taskRunning: !role_isCompleted
            isStudyMode: isVisible
            indexPositionLabel: role_idLabel
            algorithmLabel: role_algorithmLabel

            onThumbnailClicked: {
                volumeMergeStudyViewModel.selectRegistrationType(role_registrationType)
            }

            onReRegisterClicked: volumeMergeStudyViewModel.runSpecificStudy(role_registrationType)

            onVerifyClicked: volumeMergeStudyViewModel.stopStudy()
        }
    }

    Button {
        Layout.fillWidth: true
        Layout.margins: Theme.marginSize
        enabled: true
        visible: true
        state: "active"
        icon.source: "qrc:/images/merge-fill.svg"
        text: "Last Compare"

        onClicked:volumeMergeStudyViewModel.compareCycle()

    }

    LayoutSpacer { }

}
