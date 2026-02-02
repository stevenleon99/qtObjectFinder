import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.15

import Theme 1.0
import GmQml 1.0

import Enums 1.0
import ViewModels 1.0

import "../../components"

ColumnLayout{
    Layout.fillWidth: true
    Layout.leftMargin: Theme.marginSize
    Layout.rightMargin: Theme.marginSize
    spacing: 0

    signal searchTextChanged(string text)

    Label {
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.margin(8)
        Layout.alignment: Qt.AlignVCenter
        state: "subtitle2"
        font { bold: true; letterSpacing: 1; capitalization: Font.AllUppercase }
        verticalAlignment : Text.AlignVCenter
        color: Theme.headerTextColor
        text: qsTr("Part# Search")
    }

    TextField {
        id: searchBox

        Layout.fillWidth: true
        Layout.preferredHeight: Theme.margin(6)
        Layout.alignment: Qt.AlignVCenter
        maximumLength: 50
        validator: RegExpValidator { regExp: /^[0-9]{4}[\.][0-9]{4}$/ }
        leftPadding: Theme.margin(8)
        readOnly: true

        IconImage {
            anchors { left: parent.left; leftMargin: Theme.marginSize; verticalCenter: parent.verticalCenter }
            sourceSize: Theme.iconSize
            color: Theme.navy
            source: "qrc:/icons/zoom.svg"
        }

        onTextChanged: searchTextChanged(text)

        onDisplayTextChanged: partNumberSearchKeypad.searchString = searchBox.text
    }

    PartNumberSearchKeypad {
        id: partNumberSearchKeypad
        Layout.leftMargin: 0

        enterVisible: false

        onSearchStringChanged: searchBox.text = searchString
    }
}
