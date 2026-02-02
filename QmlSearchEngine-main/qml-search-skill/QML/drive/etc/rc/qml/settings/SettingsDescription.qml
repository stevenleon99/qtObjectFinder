import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

ColumnLayout {
    Layout.preferredWidth: Theme.margin(60)
    spacing: Theme.marginSize / 2

    property string title
    property string description

    Label {
        Layout.preferredWidth: parent.width
        state: "h6"
        font.bold: true
        text: title
    }

    Label {
        Layout.preferredWidth: parent.width
        state: "body1"
        text: description
        wrapMode: Label.WordWrap
    }
}
