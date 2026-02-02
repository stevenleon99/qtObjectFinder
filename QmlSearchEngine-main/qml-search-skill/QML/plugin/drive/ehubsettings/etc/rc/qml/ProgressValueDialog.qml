import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

Popup {
    id: progressValueDialog
    closePolicy: Popup.NoAutoClose

    property string header: ""
    property string description: ""
    property string detail: ""
    property alias from: progressBar.from
    property alias to: progressBar.to
    property alias value: progressBar.value

    Rectangle {
        id: container
        width: Theme.margin(143)
        height: contentColumn.height + (Theme.marginSize * 4)
        anchors { centerIn: parent }
        radius: 8
        color: Theme.foregroundColor

        ColumnLayout {
            id: contentColumn
            width: container.width - Theme.margin(8)
            anchors { centerIn: parent }
            spacing: Theme.margin(2)

            Label {
                Layout.fillWidth: true
                elide: Text.ElideRight
                state: "body2"
                font.styleName: Theme.mediumFont.styleName
                color: Theme.navyLight
                text: progressValueDialog.header
            }

            RowLayout {
                Layout.fillWidth: true
                Label {
                    Layout.fillWidth: true
                    elide: Text.ElideRight
                    state: "h4"
                    font.bold: true
                    text: progressValueDialog.description
                }
                Label {
                    elide: Text.ElideRight
                    state: "h4"
                    font.styleName: Theme.mediumFont.styleName
                    color: Theme.navyLight
                    text: value + "/" + to + " Images"
                }
            }

            ProgressBar {
                id: progressBar
                padding: Theme.margin(1)
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(3)
            }

            LayoutSpacer {
                Layout.preferredHeight: Theme.margin(1)
            }

            Label {
                Layout.fillWidth: true
                elide: Text.ElideRight
                state: "subtitle2"
                color: Theme.navyLight
                text: progressValueDialog.detail
            }
            

            Button {
                Layout.alignment: Qt.AlignRight
                state: "active"
                text: qsTr("Cancel")
                onClicked: headsetCalibrationViewModel.cancelCalibration()
            }
        }
    }
}
