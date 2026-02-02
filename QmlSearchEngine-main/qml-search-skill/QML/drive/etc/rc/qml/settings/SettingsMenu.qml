/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
*/
import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.impl 2.4
import QtQuick.Layouts 1.15
import Theme 1.0
import GmQml 1.0

ColumnLayout {
    id: menuBarId

    property var containerItem
    property alias model: repeaterId.model
    property alias animationTarget: animationId.target
    property int activeIndex: 0

    spacing: Theme.margin(2)

    Repeater {
        id: repeaterId

        Rectangle {
            property var isItemActive: menuBarId.activeIndex == model.index
            Layout.preferredWidth: 240
            Layout.preferredHeight: 48
            radius: Theme.margin(0.5)
            color: isItemActive ? "#160099FF" : Theme.transparent

            Text {
                anchors.left: parent.left
                anchors.leftMargin: Theme.margin(2)
                height: parent.height
                verticalAlignment: Text.AlignVCenter
                color: isItemActive ? Theme.blue : Theme.navyLight
                text: model.title

                font {
                    family: Theme.fontFamily
                    pixelSize: 21
                    weight: isItemActive ? Font.Bold : Font.Medium
                }
            }

            MouseArea {
                anchors.fill: parent

                onPressed: {
                    animationId.to = model.y > (containerItem.contentHeight - containerItem.height) ? (containerItem.contentHeight - containerItem.height) : model.y;
                    animationId.start();
                    menuBarId.activeIndex = model.index;
                }
            }
        }
    }

    PropertyAnimation {
        id: animationId

        property: "contentY"
        to: 0
        duration: 100
    }
}
