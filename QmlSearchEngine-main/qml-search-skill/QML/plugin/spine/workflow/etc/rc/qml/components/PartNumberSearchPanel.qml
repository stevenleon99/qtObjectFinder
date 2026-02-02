import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import GmQml 1.0
import Theme 1.0

ColumnLayout {
    id: layout
    width: partNumberSearchKeypad.width + Theme.margin(4)
    spacing: 0

    property string searchResult: ""
    property bool enterEnabled: false

    signal enterPressed(var partNumber)
    signal searchTextChanged(var partNumber)

    Label {
        Layout.fillWidth: true
        Layout.preferredHeight: Theme.margin(6)
        Layout.leftMargin: Theme.margin(2)
        Layout.alignment: Qt.AlignVCenter
        state: "subtitle2"
        font { bold: true; letterSpacing: 1; capitalization: Font.AllUppercase }
        verticalAlignment : Text.AlignVCenter
        color: Theme.headerTextColor
        text: qsTr("Part# Search")
    }

    Label {
        id: searchBox
        Layout.fillWidth: true
        Layout.leftMargin: Theme.margin(2)
        state: "h5"
        font.styleName: Theme.mediumFont.styleName
        text: partNumberSearchKeypad.searchString

        onTextChanged: searchTextChanged(text)
    }

    Label {
        Layout.fillWidth: false
        Layout.leftMargin: Theme.margin(2)
        Layout.bottomMargin: Theme.margin(2)
        state: "h6"
        color: Theme.navy
        font.styleName: Theme.mediumFont.styleName
        elide: Label.ElideNone
        text: searchResult
    }

    DividerLine { }

    PartNumberSearchKeypad {
        id: partNumberSearchKeypad

        enterEnabled: layout.enterEnabled

        onEnterPressed: layout.enterPressed(partNumber)
    }
}
