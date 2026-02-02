import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import ViewModels 1.0
import Theme 1.0
import GmQml 1.0

import "../components"

RowLayout {
    id: contentLayout
    objectName: "caseName"

    spacing: Theme.marginSize

    CaseSetupCaseNameViewModel {
        id: caseSetupCaseNameViewModel
    }

    Label {
        objectName: "caseNameLabel"
        Layout.preferredHeight: Theme.margin(8)
        state: "subtitle2"
        font.bold: true
        font.letterSpacing: 1
        color: Theme.headerTextColor
        verticalAlignment: Label.AlignVCenter
        text: "Case Name"
    }

    Rectangle {
        Layout.preferredWidth: Theme.margin(36)
        Layout.preferredHeight: Theme.margin(6)
        Layout.alignment: Qt.AlignVCenter
        color: Theme.transparent
        border.color: Theme.navyLight
        radius: 4

        Label {
            objectName: "caseNameContainer"
            anchors { fill: parent; margins: Theme.margin(1.5) }
            state: "subtitle1"
            verticalAlignment: Label.AlignVCenter
            elide: Text.ElideRight
            text: caseSetupCaseNameViewModel.caseName

            MouseArea {
                anchors.fill: parent

                onClicked: caseNamePopup.open()

                TextFieldPopup {
                    id: caseNamePopup
                    initialText: caseSetupCaseNameViewModel.caseName
                    popupTitle: qsTr("Rename Case")
                    /**
                         * Regular expression to validate the acceptable characters
                         * Supports year value from 1900. This should match the regex
                         * validation in drive for renaming a case: RenamePopup.qml,
                         * once added there.
                         *
                         * A-B
                         * a-b
                         * 0-9
                         * <space>, comma, dash, <underscore>, colon
                         */
                    textValidator: RegExpValidator { regExp: /^[0-9a-zA-Z, _:\-]{,50}/ }

                    onConfirmClicked: caseSetupCaseNameViewModel.caseName = confirmedText
                }
            }

        }
    }
}
