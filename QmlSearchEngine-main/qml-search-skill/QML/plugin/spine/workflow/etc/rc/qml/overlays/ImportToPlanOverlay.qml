import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12

import ViewModels 1.0
import Theme 1.0
import GmQml 1.0

import "../image"

Item {
    visible: importToPlanOverlayVM.visible
    anchors { fill: parent }

    property var renderer

    ImportToPlanOverlayViewModel {
        id: importToPlanOverlayVM
    }

    DescriptiveBackground {
        anchors { centerIn: parent }
        z: 1
        source: "qrc:/icons/image-single.svg"
        text: qsTr("No Image Imported")

        Button {
            Layout.topMargin: Theme.marginSize
            Layout.alignment: Qt.AlignHCenter
            state: "available"
            text: qsTr("Import")
            icon.source: "qrc:/icons/image-add.svg"

            onClicked: importPopupLoader.item.open()
        }
    }

    ImportPopupLoader {
        id: importPopupLoader
    }
}


