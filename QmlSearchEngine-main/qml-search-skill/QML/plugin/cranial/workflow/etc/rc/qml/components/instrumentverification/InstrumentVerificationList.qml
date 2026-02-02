import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import Enums 1.0
import Theme 1.0
import ViewModels 1.0
import GmQml 1.0

import ".."

ListView {
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.leftMargin: Theme.marginSize
    Layout.rightMargin: Theme.marginSize
    interactive: false
    spacing: 0

    model:  InstrumentVerificationViewModel {
                id: instrumentVerificationVMID
            }

    header: Label {
        width: parent.width
        height: Theme.marginSize * 4
        state: "subtitle1"
        font.styleName: Theme.mediumFont.styleName
        font.bold: true
        verticalAlignment: Qt.AlignVCenter
        text: qsTr("Instrument Status")
    }

    section.property: "role_instrumentGroup"
    section.criteria: ViewSection.FullString
    section.delegate: Item {
        width: parent.width
        height: Theme.marginSize * 3

        Label {
            anchors { fill: parent }
            state: "body2"
            font.styleName: Theme.boldFont.styleName
            font.bold: true
            verticalAlignment: Qt.AlignVCenter
            color: Theme.navyLight
            text: qsTr(section)
        }

        DividerLine {
            anchors { bottom: parent.bottom }
            orientation: Qt.Horizontal
        }
    }

    delegate: InstrumentVerificationListDelegate {
        state: {
            if (role_instrumentVerificationElementType == InstrumentVerificationElementTypes.BiopsyNeedle)
            {
                return "Biopsy Needle";
            }
            else
            {
                return "";
            }
        }

        instrumentName: role_instrumentName
        instrumentVisible: role_instrumentVisible
        iconColor: role_iconColor
        verifiedStatus: role_verifiedStatus
        calibratedStatus: role_calibratedStatus
        calibrationFiles: role_calibrationFiles
        calibratedFile: role_calibratedFile
    }
}
