import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0
import Enums 1.0

import ".."

Item {
    visible: instrumentPlanningControlsViewModel.visible
    Layout.fillWidth: true
    Layout.fillHeight: false
    Layout.preferredHeight: Theme.margin(16)

    InstrumentPlanningControlsViewModel {
        id: instrumentPlanningControlsViewModel
    }

    ColumnLayout {
        spacing: 0

        RowLayout {
            Layout.preferredHeight: Theme.margin(8)
            Layout.leftMargin: Theme.marginSize
            Layout.rightMargin: Theme.margin(1)

            Label {
                visible: text
                state: "subtitle2"
                color: Theme.navyLight
                font { bold: true; capitalization: Font.AllUppercase }
                text: qsTr("Offset")
            }

            Label {
                visible: text
                state: "body2"
                color: Theme.navyLight
                text: qsTr("Head")
            }

            LayoutSpacer { }

            Button {
                icon.source: instrumentPlanningControlsViewModel.offsetMm >= 0 ? "qrc:/icons/tool-direction-forward.svg" :
                                                                                 "qrc:/icons/tool-direction-back.svg"
                state: "icon"
                color: Theme.transparent
                onClicked: instrumentPlanningControlsViewModel.toggleProjection()
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize
            spacing: Theme.margin(1)

            ImplantOffsetControl {
                offset: instrumentPlanningControlsViewModel.offsetMm
                onOffsetValueChanged: instrumentPlanningControlsViewModel.setOffsetMm(offsetValue)
            }

            Button {
                enabled: instrumentPlanningControlsViewModel.placeEnabled
                Layout.preferredWidth: Theme.margin(15)
                state: "active"
                leftPadding: Theme.margin(2)
                rightPadding: Theme.margin(2)
                icon.source: "qrc:/icons/foot-pedal.svg"
                icon.color: Theme.black
                text: qsTr("Plan")

                onClicked: instrumentPlanningControlsViewModel.placeImplant()
            }
        }

        LayoutSpacer {}
    }

    DividerLine {
        anchors { top: parent.top }
        orientation: Qt.Horizontal
    }
}
