import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0


Popup {
    width: 250
    height: 144

    background: Rectangle { radius: Theme.margin(1); color: Theme.backgroundColor }

    property bool isMaskActivated: false

    function setup(positionItem) {
        var bottomLeft = positionItem.mapToItem(null, 0, positionItem.height)
        x = bottomLeft.x - width/2
        y = bottomLeft.y

        open()
    }

    ColumnLayout {
        anchors { fill: parent }
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors { fill: parent }
                spacing: Theme.marginSize / 2

                RowLayout {
                    Layout.leftMargin: Theme.marginSize / 2
                    Layout.rightMargin: Theme.marginSize / 2

                    IconImage {
                        source: "qrc:/images/mask-intensity-off.svg"
                        sourceSize: Theme.iconSize
                        color: !isMaskActivated ? Theme.blue : Theme.disabledColor
                    }

                    Label {
                        state: "body1"
                        text: qsTr("Without Intensity Mask")
                        color: !isMaskActivated ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    isMaskActivated = false
                    intensityMaskPopup.visible = false;
                }
            }
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            RowLayout {
                anchors { fill: parent }
                spacing: Theme.marginSize / 2

                RowLayout {
                    Layout.leftMargin: Theme.marginSize / 2
                    Layout.rightMargin: Theme.marginSize / 2

                    IconImage {
                        source: "qrc:/images/mask-intensity.svg"
                        sourceSize: Theme.iconSize
                        color: isMaskActivated ? Theme.blue : Theme.disabledColor
                    }

                    Label {
                        state: "body1"
                        text: qsTr("With Intensity Mask")
                        color: isMaskActivated ? Theme.blue : Theme.white
                    }

                    LayoutSpacer {}
                }
            }

            MouseArea {
                anchors { fill: parent }
                onClicked: {
                    isMaskActivated = true
                    intensityMaskPopup.visible = false;
                }
            }
        }
    }
}
