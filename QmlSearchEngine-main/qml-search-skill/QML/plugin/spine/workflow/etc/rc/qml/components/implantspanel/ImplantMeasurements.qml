import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Item {
    Layout.fillWidth: true
    Layout.fillHeight: true

    property alias screwDistance: lable.text

    ColumnLayout {
        anchors { centerIn: parent }
        spacing: 0

        IconImage {
            sourceSize: Theme.iconSize
            Layout.alignment: Qt.AlignHCenter
            source: "qrc:/icons/measure-line-horizontal.svg"
            color: Theme.lineColor
        }

        Label {
            id: lable
            Layout.alignment: Qt.AlignHCenter
            state: "body1"
            color: Theme.lineColor
        }

        Label {
            Layout.alignment: Qt.AlignHCenter
            state: "body1"
            text: "mm"
            color: Theme.lineColor
        }
    }
}
