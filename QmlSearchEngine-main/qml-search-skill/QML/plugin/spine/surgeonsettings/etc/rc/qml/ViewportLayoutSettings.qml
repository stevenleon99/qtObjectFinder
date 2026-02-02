import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

RowLayout {
    spacing: Theme.margin(4)

    property var layout: surgeonSettingsViewModel.volumeSetFourUpLayout
    property int selectedIndex: -1

    SurgeonSettingsDescription {
        id: settings
        Layout.alignment: Qt.AlignTop
        title: qsTr("Layout Editor")
        description: qsTr("Modify the default viewport layouts. Tap to swap.")
    }

    Rectangle {
        Layout.preferredWidth: Theme.margin(58)
        Layout.preferredHeight: Theme.margin(26)
        border{ color: Theme.navyLight }
        color: Theme.transparent
        radius: Theme.margin(1)

        GridLayout {
            anchors { centerIn: parent }
            columns: 2
            columnSpacing: Theme.marginSize
            rowSpacing: Theme.marginSize

            Repeater {
                id: repeater
                model: layout

                delegate: Rectangle {
                    Layout.preferredWidth: Theme.margin(26)
                    Layout.preferredHeight: Theme.margin(10)
                    Layout.column: layout[index]["x"]
                    Layout.row: layout[index]["y"]
                    radius: 4
                    color: Theme.transparent
                    border {
                        width: selected ? 4 : 1
                        color: {
                            if (selected)
                                return Theme.blue
                            else if (selectedIndex >= 0)
                                return Theme.white
                            return Theme.navy
                        }
                    }

                    readonly property bool selected: index === selectedIndex
                    readonly property string viewName: layout[index]["viewName"]

                    Label {
                        anchors { centerIn: parent }
                        state: "h6"
                        color: parent.selected ? Theme.blue : Theme.white
                        text: layout[index]["displayName"]
                    }

                    MouseArea {
                        anchors { fill: parent }

                        onClicked: {
                            if (selectedIndex < 0) {
                                selectedIndex = index
                            }
                            else if (!parent.selected) {
                                var sourceName = repeater.itemAt(selectedIndex).viewName
                                var newLayout = layout
                                newLayout[selectedIndex]["viewName"] = viewName
                                newLayout[index]["viewName"] = sourceName

                                selectedIndex = -1
                                var names = []
                                for (var i = 0; i < newLayout.length; i++) {
                                    names.push(newLayout[i]["viewName"]);
                                }

                                surgeonSettingsViewModel.updateVolumeSetFourUpLayout(names);
                            }
                            else {
                                selectedIndex = -1
                            }
                        }
                    }
                }
            }
        }
    }
}
