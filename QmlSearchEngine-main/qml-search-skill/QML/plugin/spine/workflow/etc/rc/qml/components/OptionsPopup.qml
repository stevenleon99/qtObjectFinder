import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12

import Theme 1.0
import GmQml 1.0

Popup {
    visible: false
    width: Theme.margin(30)
    height: layout.height
    modal: false
    dim: false

    property int popupAlignment: OptionsPopup.PopupAlignment.Left

    property alias model: repeater.model
    property alias optionDelegate: repeater.delegate

    enum PopupAlignment {
        Left,
        Right
    }

    background: Rectangle { radius: 4; color: Theme.slate900 }

    function setup(positionItem)
    {
        var position = positionItem.mapToItem(null, 0, 0)

        var leftX = position.x - width
        if (popupAlignment == OptionsPopup.PopupAlignment.Right) {
            leftX = leftX + positionItem.width
        }

        var bottomY =  position.y + positionItem.height
        if (bottomY > 1080) {
            bottomY = position.y - height - Theme.margin(1)
        }

        x = leftX
        y = bottomY

        visible = true;
    }

    ColumnLayout {
        id: layout
        width: parent.width
        spacing: 0

        Repeater {
            id: repeater
        }
    }
}
