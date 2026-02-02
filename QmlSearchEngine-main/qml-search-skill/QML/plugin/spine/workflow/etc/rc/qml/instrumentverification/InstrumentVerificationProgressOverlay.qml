import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import ViewModels 1.0
import Enums 1.0

Item {
    anchors { fill: parent }
    visible: verificationProgressOverlayViewModel.isVisible

    readonly property bool verifying: verificationProgressOverlayViewModel.verificationStatus == ToolVerifyingStatus.Verifying
                                      || verificationProgressOverlayViewModel.verificationStatus == ToolVerifyingStatus.Verifying_WaitForStable

    VerificationProgressOverlayViewModel {
        id: verificationProgressOverlayViewModel
    }

    Loader {
        anchors { centerIn: parent }
        active: verificationProgressOverlayViewModel.instrumentImagePath
        sourceComponent: Image {
            source: "file:///" + verificationProgressOverlayViewModel.instrumentImagePath
            height: 645
        }
    }

    Rectangle {
        id: rectangle
        anchors { right: parent.right; top: parent.top; rightMargin: Theme.margin(5); topMargin: Theme.margin(9) }

        width: Theme.margin(32)
        height: layout.height
        radius: Theme.margin(1)
        color: Theme.slate900

        ColumnLayout {
            id: layout
            width: parent.width
            spacing: 0

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: Theme.margin(17)
                Layout.topMargin: Theme.margin(2)

                BusyIndicator {
                   visible: verifying
                   width: parent.height
                   height: width
                   anchors { centerIn: parent }
                }

                IconImage {
                    id: image
                    visible: !verifying
                    anchors { centerIn: parent }
                    source: "qrc:/icons/register.svg"
                    sourceSize: Qt.size(Theme.margin(14), Theme.margin(14))
                    color: verificationProgressOverlayViewModel.verificationStatus == ToolVerifyingStatus.Passed ? Theme.green : Theme.red
                }
            }

            ColumnLayout {
                Layout.bottomMargin: Theme.margin(2)
                spacing: 0

                Label {
                    visible: verifying
                    Layout.fillWidth: true
                    state: "h6"
                    font.styleName: Theme.mediumFont.styleName
                    horizontalAlignment: Label.AlignHCenter
                    color: Theme.navyLight
                    text: verificationProgressOverlayViewModel.instrumentName
                }

                Label {
                    Layout.fillWidth: true
                    state: "h4"
                    font.styleName: Theme.mediumFont.styleName
                    horizontalAlignment: Label.AlignHCenter
                    text: verificationProgressOverlayViewModel.stateDisplayStr
                }

                Label {
                    Layout.fillWidth: true
                    state: "h6"
                    font.styleName: Theme.mediumFont.styleName
                    horizontalAlignment: Label.AlignHCenter
                    color: verificationProgressOverlayViewModel.verificationStatus == ToolVerifyingStatus.Passed ? Theme.green : Theme.white
                    text: verificationProgressOverlayViewModel.subStateDisplayStr
                }
            }
        }
    }
}
