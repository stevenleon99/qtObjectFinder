import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

RowLayout {
    spacing: 0

    property string name
    property string iconColor
    property string textColor
    property bool isLocked: false

    Item {
        Layout.fillHeight: true
        Layout.preferredWidth: height

        IconImage {
            anchors { centerIn: parent }
            source: isLocked ? "qrc:/images/trajectory-locked.svg" : "qrc:/icons/trajectory.svg"
            sourceSize: Theme.iconSize
            color: iconColor
        }
    }

    Label {
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignVCenter
        text: name
        state: "body1"
        color: textColor
        font.styleName: Theme.mediumFont.styleName
    }
}
