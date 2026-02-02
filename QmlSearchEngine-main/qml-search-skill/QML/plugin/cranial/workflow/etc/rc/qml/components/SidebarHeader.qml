import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0
import GmQml 1.0

import "registration"

ColumnLayout {
    Layout.fillHeight: false
    Layout.leftMargin: Theme.marginSize
    Layout.rightMargin: Theme.marginSize
    spacing: 0

    property string title
    property string description
    property int maxPageNumber: 0
    property int pageNumber

    property alias resetViewModel: registrationResetButton.resetViewModel

    states: [
        State {
            name: "Registration Sidebar"
            PropertyChanges {
                target: registrationResetButton
                visible: true
            }
        }
    ]

    RowLayout {
        Layout.fillWidth: true
        spacing: 5

        Label {
            state: "subtitle1"
            verticalAlignment: Label.AlignVCenter
            Layout.preferredHeight: 64
            font.styleName: Theme.mediumFont.styleName
            text: title
        }

        Label {
            visible: maxPageNumber > 0
            state: "body1"
            verticalAlignment: Label.AlignVCenter
            color: Theme.navyLight
            font.styleName: Theme.mediumFont.styleName
            text: pageNumber + "/" + maxPageNumber
        }

        LayoutSpacer { }

        RegistrationResetButton {
            id: registrationResetButton
            visible: false
        }
    }

    Label {
        Layout.fillWidth: true
        state: "subtitle1"
        font.styleName: Theme.regularFont.styleName
        wrapMode: Label.WordWrap
        text: description
        color: Theme.navyLight
    }
}
