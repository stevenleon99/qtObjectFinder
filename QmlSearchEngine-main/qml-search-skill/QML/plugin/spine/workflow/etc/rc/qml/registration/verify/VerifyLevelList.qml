import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

Flickable {
    contentHeight: columnLayout.height
    interactive: contentHeight > height
    clip: true

    property var verifyLevelListVM

    ColumnLayout {
        id: columnLayout
        width: parent.width
        spacing: Theme.marginSize

        Repeater {
            Layout.alignment: Qt.AlignTop

            model: verifyLevelListVM.vertebralInfoList

            VerifyLevel {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(6)
                Layout.leftMargin: Theme.marginSize
                Layout.rightMargin: scrollBar.visible ? Theme.margin(4) : Theme.margin(2)
                scoreDisplayed: verifyLevelListVM.scoreDisplayEnabled
                selected: verifyLevelListVM.selectedAnatomy === role_key

                onLevelClicked: verifyLevelListVM.selectAnatomy(role_key)
            }
        }
    }
    ScrollBar.vertical: ScrollBar {
        id: scrollBar
        anchors { right: parent.right; rightMargin: -20; bottom: parent.bottom; top: parent.top }
        visible: parent.contentHeight > parent.height
        padding: Theme.margin(4)
    }
}
