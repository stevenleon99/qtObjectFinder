import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Rectangle {
    height: Theme.margin(6)
    width: rowLayout.width
    radius: Theme.margin(1)
    color: Theme.black
    border { width: 1; color: alertColor }

    property color alertColor: Theme.yellow500
    property alias text: label.text
    property alias iconSource: icon.source

    RowLayout
    {
        id: rowLayout
        height: parent.height
        spacing: Theme.margin(1)

        IconImage {
            id: icon
            Layout.leftMargin: Theme.margin(1)
            source: "qrc:/icons/alert-caution.svg"
            sourceSize: Theme.iconSize
            color: alertColor
        }

        Label {
            id: label
            Layout.fillWidth: true
            Layout.rightMargin: Theme.margin(2)
            verticalAlignment: Text.AlignVCenter
            state: "body1"
            color: alertColor
            font { bold:true; capitalization: Font.AllUppercase }
        }
    }
}
