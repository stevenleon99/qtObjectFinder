import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0

Button {
    id: control

    implicitWidth: Theme.margin(5)
    implicitHeight: Theme.margin(5)
    leftPadding: 0
    rightPadding: 0
    highlighted: active
    flat: true
    color: Theme.navyLight
    icon.color: control.down || control.highlighted ? Theme.blue
                                                    : control.enabled ? control.color
                                                                      : Theme.disabledColor

    property bool active: false
    property int borderWidth: 0

    background: Rectangle {
        visible: active
        radius: Theme.margin(0.5)

        border { width: borderWidth; color: Theme.blue }
        color: Theme.transparent

        Rectangle {
            anchors.fill: parent
            opacity: 0.16
            radius: Theme.margin(0.5)
            color: Theme.blue
        }
    }
}
