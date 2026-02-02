import QtQuick 2.4
import 'LayoutEditor'
import QtQuick.Window 2.1

Window {
    id: topLevel
//    width: 1600
//    height: 1000

    visible: true
    visibility: Window.FullScreen

    Image {
        id: background
        source: "images/background_all.jpg"
        anchors.fill: parent
    }

    LayoutEditor {
        anchors.fill: parent

    }

    function showMainWindow() {
        Qt.quit();
    }
}

