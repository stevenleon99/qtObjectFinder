/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
*/
import QtQuick 2.15

Item {
    property string title
    property alias sourceComponent: componentLoader.sourceComponent
    property var menuItemIndex

    height: componentLoader.height
    Component.onCompleted: {
        menuItemIndex = menuModel.addMenuItem(title, y);
    }
    onYChanged: {
        if (menuItemIndex != undefined) {
            menuModel.updateMenuItem(menuItemIndex, y);
        }
    }

    Loader {
        id: componentLoader

        height: item.height
        width: parent.width
    }
}
