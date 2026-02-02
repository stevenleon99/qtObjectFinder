import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

ColumnLayout {
    Layout.preferredWidth: Theme.margin(60)
    spacing: Theme.marginSize / 2

    property alias title: titleLabel.text
    property alias description: descriptionLabel.text

    Label {
        id: titleLabel
        Layout.preferredWidth: parent.width
        state: "h6"
        font.bold: true
    }

    Label {
        id: descriptionLabel
        Layout.preferredWidth: parent.width
        state: "body1"
        color: Theme.navyLight
        wrapMode: Label.WordWrap
    }
}
