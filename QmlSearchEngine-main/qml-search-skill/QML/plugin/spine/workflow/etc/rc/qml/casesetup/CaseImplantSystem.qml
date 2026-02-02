import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

Item {
    width: ListView.view.width
    height: Theme.margin(8)

    property bool selected: false
    property int bgRightMargin: 0

    signal clicked()
    signal deleteClicked()

    Rectangle {
        radius: 4
        anchors { fill: parent; rightMargin: bgRightMargin }
        color: selected ? Theme.blue : Theme.transparent
        opacity: .16
    }

    MouseArea {
        anchors { fill: parent }

        onClicked: parent.clicked()
    }
    
    RowLayout {
        anchors { fill: parent; leftMargin: Theme.marginSize; rightMargin: Theme.margin(1) }
        spacing: 0

        Rectangle {
            objectName: "implantNumberedCircle"
            Layout.preferredWidth: Theme.margin(4)
            Layout.preferredHeight: Theme.margin(4)
            radius: width/2
            color: role_color

            Label {
                objectName: "implantNumberLabel"
                anchors.centerIn: parent
                state: "subtitle1"
                text: role_key
                color: Theme.black
            }
        }

        Label {
            objectName: "implantNameLabel"
            Layout.fillWidth: true
            Layout.leftMargin: Theme.marginSize
            state: "subtitle1"
            font.bold: true
            text: role_name
            font.capitalization: Font.AllUppercase
        }

        Button {
            objectName: "deleteButton"
            state: "icon"
            rotation: 90
            icon.source: "qrc:/icons/x.svg"

            onClicked: deleteClicked()
        }
    }
}
