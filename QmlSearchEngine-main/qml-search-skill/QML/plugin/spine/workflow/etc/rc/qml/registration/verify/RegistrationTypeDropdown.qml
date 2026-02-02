import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.impl 2.12
import QtQuick.Window 2.12

import Theme 1.0
import GmQml 1.0

import ViewModels 1.0

Popup {
    id: popup
    visible: false
    width: Theme.margin(41)
    height: layout.height
    modal: false
    dim: false

    property alias model: repeater.model
    property bool scoreVisible: false

    signal typeClicked(string type)

    background: Rectangle { radius: 4; color: Theme.slate900 }

    function setup(positionItem)
    {
        var position = positionItem.mapToItem(null, 0, 0)

        var leftX = position.x
        var bottomY =  position.y + positionItem.height
        if ((bottomY + height) > Window.height) {
            bottomY = position.y - height
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

            RegistrationTypeDelegate {
                name: qsTr(role_resultName)
                score: role_regScore
                scoreVisible: popup.scoreVisible

                onClicked: {
                    typeClicked(role_resultName)
                    close()
                }
            }
        }
    }
}
