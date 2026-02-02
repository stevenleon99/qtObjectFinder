import QtQuick 2.0
import "../../qml/LayoutEditor"
import QtQuick.Window 2.1

Window {
    id: topLevel
//    width: 1600
//    height: 1000

    visible: true
    visibility: Window.FullScreen

    LayoutEditor {
        anchors.fill: parent

    }

    function showMainWindow() {
        Qt.quit();
    }
}

