import QtQuick 2.4
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1

Rectangle {
    color: "#333333"

    property bool regMode: modeGroup.current.text === "Registration"
    property bool ringMode: modeGroup.current.text === "Rings"
    property bool planningMode: modeGroup.current.text === "Plan"
    property bool navMode: modeGroup.current.text === "Navigation"

    FluoroImage {
        id: apImage
        anchors.top: parent.verticalCenter
        anchors.right: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.left: parent.left

        uuid: "APImage"
    }

    FluoroImage {
        id: latImage
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.bottom: parent.verticalCenter
        anchors.left: parent.horizontalCenter

        uuid: "LatImage"
    }

    BorderImage {
        id: view_border
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.horizontalCenter
        anchors.bottom: parent.verticalCenter
        border { left: 34; right: 34; top: 34; bottom: 34 }
        source: "view_border.png"
        FluoroPseudoAxialView {
            anchors { fill: parent;margins: 10  }
        }
    }

    Column {
        id: myColumn;
        anchors.top: parent.verticalCenter
        anchors.left: parent.horizontalCenter
        anchors.margins: 40
        spacing: 10

        GroupBox {
            title: "Mode"

            ColumnLayout {
                ExclusiveGroup {
                    id: modeGroup

                    onCurrentChanged: {
                        console.log("Current",current.text)
                        fluoroMgr.update()
                    }
                }
                RadioButton {
                    text: "Rings"
                    checked: true
                    exclusiveGroup: modeGroup
                }
                RadioButton {
                    text: "Registration"
                    exclusiveGroup: modeGroup
                }
                RadioButton {
                    text: "Plan"
                    exclusiveGroup: modeGroup
                }
                RadioButton {
                    text: "Navigation"
                    exclusiveGroup: modeGroup
                }
            }
        }

        CheckBox {
            id: cursorCB
            text: qsTr("Cursor")
        }

        Button {
            id: resetScrews
            text: qsTr("Reset Plans")

            onPressedChanged: {
                fluoroMgr.autoScrewPlacement()
            }
        }
    }

    BorderImage {
        id: threeD
        visible: false
        anchors.top: view_border.bottom
        anchors.left: myColumn.right
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        border { left: 34; right: 34; top: 34; bottom: 34 }
        source: "view_border.png"
        FluoroRegistration3dView {
            anchors { fill: parent;margins: 10  }
        }
    }
}

