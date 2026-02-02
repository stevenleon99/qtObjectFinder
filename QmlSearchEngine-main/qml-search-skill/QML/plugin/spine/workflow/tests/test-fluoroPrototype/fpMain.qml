import QtQuick 2.3
import QtQuick.Window 2.2

Window {
    visible: true
    width: height * 1.36
    height: 900
    title: "FluoroBot Planning Prototype"



    FluoroRegistration {
        anchors.fill: parent
    }

//    MouseArea {
//        anchors.fill: parent
//        onClicked: {
//            Qt.quit();
//        }
//   }
}
