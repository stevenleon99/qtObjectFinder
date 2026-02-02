import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0

RowLayout {
    visible: false
    spacing: Theme.margin(1)

    property string text: ""
    property bool active: false

    IconImage {
        source: active ? "qrc:/icons/check.svg" : "qrc:/icons/x.svg"
        sourceSize: Theme.iconSize
        color: active ? Theme.green : Theme.red
    }

    Label {
        state: "body1"
        text: parent.text
    }
}
