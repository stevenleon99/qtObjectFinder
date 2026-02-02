import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0
import DriveEnums 1.0

Popup {
    visible: true
    width: parent.width
    height: parent.height
    closePolicy: Popup.NoAutoClose
    dim: false

    background: Rectangle { color: Theme.overlayColor }

    IconButton {
        visible: drivePageViewModel.currentPage === DrivePage.Workflow
        enabled: !flash.visible
        width: Theme.margin(8)
        height: width
        anchors { top: parent.top; right: parent.right }
        source: "qrc:/icons/screenshot.svg"
        sourceSize: Theme.iconSize
        onClicked: {
            screenshotsViewModel.saveScreenshot(appWindow);
            flash.open();
        }

        ScreenshotFlash { id: flash }
    }

    Rectangle {
        id: warning
        width: Theme.margin(83)
        height: layout.height
        anchors { centerIn: parent }
        radius: Theme.margin(1)
        color: Theme.backgroundColor

        MouseArea {
            enabled: !optionList.count && !alertViewModel.currentAlert.loading
            anchors { fill: parent }

            onClicked: alertViewModel.requestClear(alertViewModel.currentAlert.id)
        }

        ColumnLayout {
            id: layout
            width: parent.width
            spacing: Theme.marginSize

            ColumnLayout {
                Layout.margins: Theme.margin(4)
                spacing: Theme.margin(4)

                RowLayout {
                    Layout.topMargin: Theme.margin(1)
                    spacing: Theme.margin(3)

                    IconImage {
                        Layout.alignment: Qt.AlignTop
                        sourceSize: Qt.size(Theme.iconSize.width * 2, Theme.iconSize.height * 2)
                        source: switch (alertViewModel.currentAlert.level) {
                                default: return "qrc:/icons/case-info.svg"
                                case AlertLevel.Warning: return "qrc:/icons/alert-caution.svg"
                                case AlertLevel.Error: return "qrc:/icons/alert-stop.svg"
                                }
                        color: switch (alertViewModel.currentAlert.level) {
                               default: return Theme.blue
                               case AlertLevel.Warning: return Theme.yellow
                               case AlertLevel.Error: return Theme.red
                               }
                    }

                    ColumnLayout {
                        Layout.topMargin: Theme.margin(1)
                        spacing: Theme.margin(2)

                        Label {
                            objectName: "warningTitle"
                            Layout.fillWidth: true
                            state: "h4"
                            wrapMode: Text.WordWrap
                            text: alertViewModel.currentAlert.title
                        }

                        ColumnLayout {
                            spacing: 0

                            Label {
                                objectName: "warningMessage"
                                visible: text
                                Layout.fillWidth: true
                                state: "h6"
                                wrapMode: Text.WordWrap
                                text: alertViewModel.currentAlert.message
                            }

                            Label {
                                objectName: "warningAction"
                                visible: text
                                Layout.fillWidth: true
                                state: "h6"
                                wrapMode: Text.WordWrap
                                text: alertViewModel.currentAlert.action
                            }
                        }

                        Label {
                            objectName: "warningRef"
                            visible: alertViewModel.currentAlert.level !== AlertLevel.Info
                            Layout.fillWidth: true
                            state: "subtitle1"
                            color: Theme.navyLight
                            text: "REF: " + alertViewModel.currentAlert.id
                        }
                    }
                }

                BusyIndicator {
                    visible: alertViewModel.currentAlert.loading
                    Layout.alignment: Qt.AlignHCenter
                    Layout.preferredWidth: Theme.margin(8)
                    Layout.preferredHeight: Theme.margin(8)
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: Theme.margin(2)

                    LayoutSpacer {}

                    Repeater {
                        id: optionList
                        model: alertViewModel.currentAlert.options

                        Button {
                            objectName: "optionButton_"+role_optionText
                            state: "active"
                            text: role_optionText

                            onClicked: alertViewModel.requestClear(alertViewModel.currentAlert.id, role_optionId)
                        }
                    }
                }
            }
        }
    }
    Item{
        objectName: "autoUIDriveAlertObj"

        function triggerButtonClick(buttonIndex) {
            var buttonItem = optionList.itemAt(buttonIndex);
            if (buttonItem) {
                buttonItem.clicked();
            }
        }
    }
}
