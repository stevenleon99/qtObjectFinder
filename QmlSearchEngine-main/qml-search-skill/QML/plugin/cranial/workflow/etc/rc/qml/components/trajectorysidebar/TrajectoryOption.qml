import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Item {
    id: trajectoryOption
    Layout.preferredWidth: layout.width + Theme.margin(2)
    Layout.preferredHeight: layout.height

    property alias text: label.text
    property alias icon: icon.source
    property alias iconEnabled: icon.enabled
    property color iconColor: Theme.blue

    signal clicked()

    RowLayout {
        id: layout
        height: Theme.margin(6)
        anchors { horizontalCenter: parent.horizontalCenter }
        spacing: Theme.margin(2)

        IconImage {
            id: icon
            sourceSize: Theme.iconSize
            color: iconColor
        }

        Label {
            id: label
            Layout.fillWidth: true
            state: "body1"
            font.styleName: Theme.mediumFont.styleName
            color: Theme.white
        }
    }

    MouseArea {
        anchors { fill: parent }

        onClicked: parent.clicked()
    }
}
