import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import Theme 1.0

Item {
    width: ListView.view.width
    height: Theme.margin(8)
    
    property string roleName: role_name
    property bool roleSystemAdded: role_systemAdded
    property string roleKey: role_key

    signal clicked()

    RowLayout {
        anchors { fill: parent }
        spacing: Theme.marginSize

        Item {
            Layout.preferredWidth: Theme.margin(4)
            Layout.preferredHeight: Theme.margin(4)

            CheckBox {
                id: checkbox
                anchors { fill: parent; margins: 4 }
                checked: role_systemAdded
                checkable: false
            }
        }

        Label {
            Layout.fillWidth: true
            state: "subtitle2"
            text: role_name
            font.capitalization: Font.AllUppercase
        }
    }

    MouseArea {
        anchors { fill: parent }

        onClicked: parent.clicked()
    }
}
