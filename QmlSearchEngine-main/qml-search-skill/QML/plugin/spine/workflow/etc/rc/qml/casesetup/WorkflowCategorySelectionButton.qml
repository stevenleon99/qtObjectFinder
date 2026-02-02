import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.4

import Theme 1.0

Rectangle {
    Layout.preferredWidth: Theme.margin(12)
    Layout.preferredHeight: Theme.margin(14)
    radius: 4
    border { width: selected ? 2 : 1; color: selected ? Theme.blue : Theme.navyLight }
    color: Theme.transparent
    
    property bool selected: false

    property alias text: label.text
    property alias icon: image.source
    
    objectName: "workflowSelectionBtn_"+label.text
    
    signal clicked()

    Rectangle {
        anchors { fill: parent }
        color: selected ? Theme.blue : Theme.backgroundColor
        opacity: .16
    }
    
    ColumnLayout {
        anchors { centerIn: parent }
        spacing: Theme.margin(1)

        IconImage {
            id: image
            Layout.alignment: Qt.AlignHCenter
            sourceSize.width: Theme.iconSize.width * 1.5
            sourceSize.height: Theme.iconSize.height * 1.5
            color: selected ? Theme.blue
                            : !enabled ? Theme.disabledColor
                                       : Theme.white
        }

        Label {
            id: label
            Layout.alignment: Qt.AlignHCenter
            font { bold: true }
            state: "body1"
            color: selected ? Theme.white
                            : !enabled ? Theme.disabledColor
                                       : Theme.white
        }
    }

    MouseArea {
        anchors { fill: parent }

        onClicked: parent.clicked()
    }
}
